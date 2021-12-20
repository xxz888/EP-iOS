//
//  KDBingCardNewViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/12.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDBingCardNewViewController.h"
#import "KDCommonAlert.h"
#import "LoginAndRegistHTTPTools.h"
#import "BRStringPickerView.h"
#import "KDCommonAlert.h"
#import "MCDateStore.h"
@interface KDBingCardNewViewController ()//<WBQRCodeVCDelegate>
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

@property (nonatomic, strong) BRStringPickerView *pickView1;
@property (nonatomic, strong) BRStringPickerView *pickView2;
@end

@implementation KDBingCardNewViewController

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
    [self setNavigationBarTitle:@"绑卡确认" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    self.change1TagLbl.text = @"手机号";
    self.change2TagLbl.text = @"验证码";
    self.change2Lbl.hidden = YES;
    self.codeBtn.hidden = YES;
   self.codeView.hidden =  NO;
    self.phoneLabel.textColor = [UIColor blackColor];
    self.change2Lbl.textColor = [UIColor blackColor];
    self.phoneLabel.userInteractionEnabled = self.change2Lbl.userInteractionEnabled = NO;
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
#pragma mark ---------------绑卡确认请求方法-------------------
-(void)requestBindCardVCAction{
    if ([self.codeView.text isEqualToString:@""]) {
        [MCToast showMessage:@"请填写正确的验证码"];
        return;
    }
    NSDictionary *params =
    @{
        @"channelBindId":[NSString stringWithFormat:@"%@",self.channelBindId],
        @"code":self.codeView.text,
     };
    __weak typeof(self) weakSelf = self;
    [MCSessionManager.shareManager mc_Post_QingQiuTi:@"/api/v1/player/plan/bind/confirm" parameters:params ok:^(NSDictionary * _Nonnull respDic) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MCToast showMessage:@"绑定成功"];
        });
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } other:^(NSDictionary * _Nonnull respDic) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
    
//    [MCSessionManager.shareManager mc_POST:@"/paymentgateway/topup/dy/bindCard" parameters:params ok:^(NSDictionary * _Nonnull resp) {
//        [weakSelf.cardModel setJumpWhereVC:@"2"];
//        [MCPagingStore pagingURL:rt_card_add withUerinfo:@{@"param":self.cardModel}];
//    } other:^(NSDictionary * _Nonnull resp) {
//        [MCLoading hidden];
//        [MCToast showMessage:resp[@"messege"]];
//    }];
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
