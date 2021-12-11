//
//  KDPayNewViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/12.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDPayNewViewController.h"
#import "KDCommonAlert.h"
#import "LoginAndRegistHTTPTools.h"
#import "BRStringPickerView.h"
#import "KDCommonAlert.h"
#import "MCDateStore.h"
@interface KDPayNewViewController ()//<WBQRCodeVCDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *validityLabel;
@property (weak, nonatomic) IBOutlet UILabel *safeCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeView;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property(nonatomic, copy) NSString *orderCode;//订单order
@property(nonatomic, copy) NSString *inprovincecode;//省code
@property(nonatomic, copy) NSString *incitycode;//市code
@property(nonatomic, copy) NSString *bindcardmessageid;//验证码id
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewHeight;
@property (weak, nonatomic) IBOutlet UIView *smsView;
@property (nonatomic ,strong)NSString * orderId;
@property (nonatomic, strong) BRStringPickerView *pickView1;
@property (nonatomic, strong) BRStringPickerView *pickView2;
@end

@implementation KDPayNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inprovincecode = nil;
    self.incitycode = nil;
    [self.payBtn setTitle:@"确认" forState:0];
    self.nameLabel.text = self.cardModel.name;
    self.cardNoLabel.text = self.cardModel.bankCardNo;
    self.validityLabel.text = self.cardModel.validPeriod;
    self.safeCodeLabel.text = self.cardModel.cvc;
    self.phoneLabel.text = self.cardModel.phone;
    //鉴权绑卡界面
    [self setNavigationBarTitle:@"支付确认" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    self.change1TagLbl.text = @"手机号";
    self.change2TagLbl.text = @"验证码";
    self.change2Lbl.hidden = YES;
    self.codeBtn.hidden = self.codeView.hidden =  NO;
    self.phoneLabel.textColor = [UIColor blackColor];
    self.change2Lbl.textColor = [UIColor blackColor];
    self.phoneLabel.userInteractionEnabled = self.change2Lbl.userInteractionEnabled = NO;
    
    self.stackViewHeight.constant = 270;
    self.smsView.hidden = YES;
}
#pragma mark ---------------获取验证码-------------------
- (IBAction)getCodeAction:(UIButton *)sender {
    // 发送验证码
    __weak typeof(self) weakSelf = self;
    
    NSString * url = [NSString stringWithFormat:@"/api/v1/player/sms?smsType=BindChannel&phone=%@",self.cardModel.phone];
    [[MCSessionManager shareManager] mc_GET:url parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
        [MCToast showMessage:@"验证码已发送"];
        [self changeSendBtnText:weakSelf.codeBtn];
    }];
}
#pragma mark ---------------确认支付请求方法-------------------
-(void)requestBindCardVCAction{
    //代表第一次进来，不需要验证码
    if (self.smsView.hidden ) {
        [self gotoPay];
    }else{
        if ([self.codeView.text isEqualToString:@""]) {
            [MCToast showMessage:@"请填写正确的验证码"];
            return;
        }
        [self receivePayment];
    }
}
-(void)receivePayment{
    NSDictionary *params =
    @{
        @"code":self.codeView.text,
        @"orderId":self.orderId,
     };
    __weak typeof(self) weakSelf = self;
    [MCSessionManager.shareManager mc_Post_QingQiuTi:@"/api/v1/player/receivePayment/confirm" parameters:params ok:^(NSDictionary * _Nonnull respDic) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MCToast showMessage:@"操作成功"];
        });
    
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    } other:^(NSDictionary * _Nonnull respDic) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
-(void)gotoPay{
    NSDictionary *params =
    @{
        @"creditCardId":self.cardModel.id,
        @"debitCardId":self.cardchuxuModel.id,
        @"amount":self.amount,
        @"channelId":self.channelId,
        @"channelPlatform":@"Bank"
     };
    __weak typeof(self) weakSelf = self;
    [MCSessionManager.shareManager mc_Post_QingQiuTi:@"/api/v1/player/receivePayment/pre" parameters:params ok:^(NSDictionary * _Nonnull respDic) {
        //发短信
        if ([respDic[@"state"] isEqualToString:@"Process"] ) {
            weakSelf.stackViewHeight.constant = 320;
            weakSelf.smsView.hidden = NO;
            [MCToast showMessage:@"需要获取验证码来验证"];
            weakSelf.orderId = respDic[@"orderId"];
        }
        //完成
        if ([respDic[@"state"] isEqualToString:@"Successful"] ) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MCToast showMessage:@"操作成功"];
                
            });
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];

        }
        //完成
        if ([respDic[@"state"] isEqualToString:@"Unpaid"] ) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MCToast showMessage:@"订单处理中"];
            });
        }
     
    } other:^(NSDictionary * _Nonnull respDic) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
#pragma mark ---------------底部按钮的公共方法-------------------
- (IBAction)payBtnAction:(UIButton *)sender {
    //鉴权绑卡界面
    [self requestBindCardVCAction];
}

#pragma mark ---------------获取上一个界面的参数，不常用-------------------
- (instancetype)initWithClassification:(MCBankCardModel *)cardModel{
    self = [super init];
    if (self) {
        self.cardModel = cardModel;
    }
    return self;
}
@end
