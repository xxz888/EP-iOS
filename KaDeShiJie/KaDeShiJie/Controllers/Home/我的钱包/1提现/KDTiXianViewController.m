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

-(void)requestData{
    __weak __typeof(self)weakSelf = self;
    NSString * url1 = @"/api/v1/player/wallet";
    [self.sessionManager mc_GET:url1 parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        NSDictionary * dic = [NSDictionary dictionaryWithDictionary:resp];
        weakSelf.zhanghuyue.text = [NSString stringWithFormat:@"%.2f",[dic[@"balance"] doubleValue]];
        weakSelf.ketixianjine.text = [NSString stringWithFormat:@"%.2f",[dic[@"availableAmount"] doubleValue]];
    }];
}
-(void)clicktixianjiluAction{

    
    [self pushCardVCWithType:MCBankCardTypeChuxuka];
//    MCCardManagerController *vc = [[MCCardManagerController alloc] init];
//    vc.titleString = @"选择储蓄卡";
//    vc.selectCard = ^(MCBankCardModel * _Nonnull cardModel, NSInteger type) {
//        if (type == 0) {
//
//        } else {
//            self.chuxuInfo = cardModel;
//
//            MCBankCardInfo *ii = [MCBankStore getBankCellInfoWithName:self.chuxuInfo.bank];
//            self.bankLogo.image = ii.logo;
//            NSString *cardNo = self.chuxuInfo.bankCardNo;
//            if (cardNo && cardNo.length > 4) {
//                NSString *bank = [NSString stringWithFormat:@"%@ (%@)",self.chuxuInfo.bank,[cardNo substringFromIndex:cardNo.length-4]];
//                self.bankLbl.text = bank;
//            }
//        }
//    };
//    [self.navigationController pushViewController:vc animated:YES];

}

- (void)pushCardVCWithType:(MCBankCardType)cardType
{
    MCCardManagerController *vc = [[MCCardManagerController alloc] init];
    vc.selectCard = ^(MCBankCardModel * _Nonnull cardModel, NSInteger type) {
        
    };
    if (cardType == MCBankCardTypeXinyongka) {
        vc.titleString = @"选择信用卡";
    } else {
        vc.titleString = @"选择储蓄卡";
    }
    [self.navigationController pushViewController:vc animated:YES];
    vc.selectCard = ^(MCBankCardModel * _Nonnull cardModel, NSInteger type) {
        if (type == 0) {
//            self.xinyongInfo = cardModel;
        } else {
//            self.chuxuInfo = cardModel;
        }
    };
}

- (IBAction)tixianRequestLast:(id)sender {

}
    
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tixianAction:(id)sender {
    [MCPagingStore pagingURL:rt_card_list];
}
@end
