//
//  KDTiXianViewController.m
//  KaDeShiJie
//
//  Created by BH on 2021/11/24.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDTiXianViewController.h"
#import "KDTixianjiluViewController.h"

@interface KDTiXianViewController ()
@property(nonatomic, strong) MCBankCardModel *chuxuInfo;

@property(nonatomic, assign) BOOL canWithdraw;
@property(nonatomic,strong)NSString * payPassword;
@property (weak, nonatomic) IBOutlet UILabel *tip;
@end

@implementation KDTiXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor qmui_colorWithHexString:@"#F6F6F6"];
    self.canWithdraw = NO;
    [self setNavigationBarTitle:@"提现" tintColor:nil];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.tip.text = [NSString stringWithFormat:@"需大于100元，%@元/笔",SharedDefaults.extraFee];
    
    QMUIButton *kfBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [kfBtn setTitleColor:[UIColor qmui_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [kfBtn setTitle:@"提现记录" forState:UIControlStateNormal];
    [kfBtn addTarget:self action:@selector(clicktixianjiluAction) forControlEvents:UIControlEventTouchUpInside];
    kfBtn.spacingBetweenImageAndTitle = 5;
    kfBtn.titleLabel.font = LYFont(13);
    kfBtn.frame = CGRectMake(SCREEN_WIDTH - 84, StatusBarHeight, 64, 44);
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:kfBtn];
    
    [self requestData];
    
    
    
}
-(void)clicktixianjiluAction{
    [self.navigationController pushViewController:[KDTixianjiluViewController new] animated:YES];
}
-(void)requestData{
    __weak __typeof(self)weakSelf = self;
    NSString * url1 = @"/api/v1/player/wallet";
    [self.sessionManager mc_GET:url1 parameters:nil ok:^(NSDictionary * _Nonnull resp) {
        NSDictionary * dic = [NSDictionary dictionaryWithDictionary:resp];
        weakSelf.zhanghuyue.text = [NSString stringWithFormat:@"%.2f",[dic[@"balance"] doubleValue]];
        weakSelf.ketixianjine.text = [NSString stringWithFormat:@"%.2f",[dic[@"availableAmount"] doubleValue]];
        weakSelf.inputPrice.text =  [NSString stringWithFormat:@"%.2f",[dic[@"availableAmount"] doubleValue]];
       
        weakSelf.tipLbl.text = [NSString stringWithFormat:@"税费:%.2f元 手续费:%@元 实际到账%.2f元",
                                [dic[@"availableAmount"] doubleValue]*0.06,
                                @"2",
                                [dic[@"availableAmount"] doubleValue]*0.94 -2];
        if ([dic[@"canWithdraw"] integerValue] == 1) {
            self.canWithdraw = true;

        }else{
            self.canWithdraw = NO;

        }
        
    }];
    
    
    NSString * url2 = @"/api/v1/player/bank/debit";
    [self.sessionManager mc_GET:url2 parameters:nil ok:^(NSDictionary * _Nonnull resp) {
        NSArray *temArr = [MCBankCardModel mj_objectArrayWithKeyValuesArray:resp];
        if ([temArr count] != 0) {
            MCBankCardModel * model = temArr[0];
            weakSelf.chuxuInfo = model;
            [self setChuxuKaData];
        }else{
            
        }
    }];
}
- (IBAction)tixianAction:(id)sender{
    MCCardManagerController *vc = [[MCCardManagerController alloc] init];
    vc.titleString = @"选择储蓄卡";
    [self.navigationController pushViewController:vc animated:YES];
    vc.selectCardBlock = ^(MCBankCardModel * _Nonnull cardModel, NSInteger type) {
        if (type == 0) {

        } else {
            self.chuxuInfo = cardModel;
            [self setChuxuKaData];
        }
    };
}


-(void)setChuxuKaData{
    MCBankCardInfo *ii = [MCBankStore getBankCellInfoWithName:self.chuxuInfo.bankName];
    self.bankLogo.image = ii.logo;
    NSString *cardNo = self.chuxuInfo.bankCardNo;
    if (cardNo && cardNo.length > 4) {
        NSString *bank = [NSString stringWithFormat:@"%@ (%@)",self.chuxuInfo.bankName,[cardNo substringFromIndex:cardNo.length-4]];
        self.bankLbl.text = bank;
    }
}

- (IBAction)tixianRequestLast:(id)sender {
    if (!self.canWithdraw) {
        [MCToast showMessage:@"当前状态不可提现"];
        return;
    }
    
    
    if ([SharedUserInfo.hasPayPassword integerValue]  == 0) {
        QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先设置支付密码" preferredStyle:QMUIAlertControllerStyleAlert];
        [alert addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
        [alert addAction:[QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
            KDForgetPwdViewController * VC= [[KDForgetPwdViewController alloc]init];
            VC.iscome = @"3";
            [MCLATESTCONTROLLER.navigationController pushViewController:VC animated:YES];

        }]];
        [alert showWithAnimated:YES];
    }else{
        QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:@"请输入支付密码" message:[NSString stringWithFormat:@"提现金额%@元",self.inputPrice.text] preferredStyle:QMUIAlertControllerStyleAlert];
        
        [alert addTextFieldWithConfigurationHandler:^(QMUITextField * _Nonnull textField) {
            textField.tag = 1003;
           
        }];
        [alert addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
        [alert addAction:[QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
            QMUITextField * tf = [aAlertController.view viewWithTag:1003];
            self.payPassword = tf.text;
            [self withdraw];
        }]];
        [alert showWithAnimated:YES];

    }

}
-(void)withdraw{
    NSString * url1 = @"/api/v1/player/wallet/withdraw";
    if ([self.inputPrice.text doubleValue] <=0) {
        [MCToast showMessage:@"请输入提现金额"];
        return;
    }
    if ([self.payPassword doubleValue] <=0) {
        [MCToast showMessage:@"请输入提现密码"];
        return;
    }
    if (!self.chuxuInfo) {
        [MCToast showMessage:@"请选择提现储蓄卡"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [MCSessionManager.shareManager mc_Post_QingQiuTi:url1 parameters:@{@"debitCardId":self.chuxuInfo.id,@"payPassword":self.payPassword} ok:^(NSDictionary * _Nonnull respDic) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MCToast showMessage:@"操作成功"];
        });
        [weakSelf clicktixianjiluAction];
    } other:^(NSDictionary * _Nonnull respDic) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
