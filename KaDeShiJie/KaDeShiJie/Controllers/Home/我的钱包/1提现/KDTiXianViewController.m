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

@end

@implementation KDTiXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor qmui_colorWithHexString:@"#F6F6F6"];
    
    [self setNavigationBarTitle:@"提现" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    
    QMUIButton *kfBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [kfBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
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
    NSString * url1 = @"/api/v1/player/wallet/withdraw";
    if ([self.inputPrice.text doubleValue] <=0) {
        [MCToast showMessage:@"请输入提现金额"];
        return;
    }
    if (!self.chuxuInfo) {
        [MCToast showMessage:@"请选择提现储蓄卡"];
        return;
    }
//    "amount": 0,
//    "debitCardId": 0
    __weak typeof(self) weakSelf = self;
    [MCSessionManager.shareManager mc_Post_QingQiuTi:url1 parameters:@{@"amount":self.inputPrice.text,@"debitCardId":self.chuxuInfo.id} ok:^(NSDictionary * _Nonnull respDic) {
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
