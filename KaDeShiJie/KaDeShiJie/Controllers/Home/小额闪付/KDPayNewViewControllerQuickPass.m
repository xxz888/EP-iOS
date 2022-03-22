//
//  KDPayNewViewControllerQuickPass.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/12.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDPayNewViewControllerQuickPass.h"
#import "KDCommonAlert.h"
#import "LoginAndRegistHTTPTools.h"
#import "BRStringPickerView.h"
#import "KDCommonAlert.h"
#import "MCDateStore.h"
#import "KDSlotCardHistoryModel.h"
#import "KDSlotCardOrderInfoViewController.h"
#import "KDTrandingRecordViewController.h"
@interface KDPayNewViewControllerQuickPass ()//<WBQRCodeVCDelegate>
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


@property (nonatomic, strong) BRStringPickerView *pickView1;
@property (nonatomic, strong) BRStringPickerView *pickView2;
@end

@implementation KDPayNewViewControllerQuickPass

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
    [self setNavigationBarTitle:@"支付确认" tintColor:nil];
    self.change1TagLbl.text = @"手机号";
    self.change2TagLbl.text = @"验证码";
    self.change2Lbl.hidden = YES;
    self.codeBtn.hidden = self.codeView.hidden =  NO;
    self.phoneLabel.textColor = [UIColor blackColor];
    self.change2Lbl.textColor = [UIColor blackColor];
    self.phoneLabel.userInteractionEnabled = self.change2Lbl.userInteractionEnabled = NO;
    
    self.stackViewHeight.constant = 320;
    self.smsView.hidden = NO;
}


-(void)payConfirm{
    if ([self.codeView.text isEqualToString:@""]) {
        [MCToast showMessage:@"请填写正确的验证码"];
        return;
    }
    NSDictionary *params =
    @{
        @"code":self.codeView.text,
        @"orderId":self.orderId,
     };
    __weak typeof(self) weakSelf = self;
    [MCSessionManager.shareManager mc_Post_QingQiuTi:@"/api/v1/player/quickPay/confirm" parameters:params ok:^(NSDictionary * _Nonnull respDic) {
        [weakSelf.navigationController pushViewController:[KDTrandingRecordViewController new] animated:YES];
    } other:^(NSDictionary * _Nonnull respDic) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark ---------------底部按钮的公共方法-------------------
- (IBAction)payBtnAction:(UIButton *)sender {
    [self payConfirm];

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
