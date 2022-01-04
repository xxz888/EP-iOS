//
//  KDJiangLiShouYiViewController.m
//  KaDeShiJie
//
//  Created by mac on 2021/11/25.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJiangLiShouYiViewController.h"
#import "KDJiangliView.h"

@interface KDJiangLiShouYiViewController ()
@property (nonatomic, strong) KDJiangliView *headerView;

@end

@implementation KDJiangLiShouYiViewController


- (KDJiangliView *)headerView
{
    if (!_headerView) {
        _headerView = [[KDJiangliView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TabBarHeight)];
    }
    return _headerView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateNavigationBarAppearance];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.mc_tableview.tableHeaderView = self.headerView;
    self.mc_tableview.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage mc_imageNamed:@"nav_left_white"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
        backBtn.frame = CGRectMake(0, StatusBarHeightConstant, 44, 44);
        [self.view addSubview:backBtn];
    
//    [self setNavigationBarTitle:@"我的钱包" tintColor:nil];
    [self setNavigationBarHidden];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, StatusBarHeightConstant, 150, 44)];
    titleLabel.text = @"奖励收益";
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [self requestData];
}
-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)requestData{
    __weak __typeof(self)weakSelf = self;
    NSString * url1 = @"/api/v1/player/wallet/commission/other";
    [self.sessionManager mc_GET:url1 parameters:nil ok:^(NSDictionary * _Nonnull resp) {

            weakSelf.headerView.zongshouyi.text = [NSString stringWithFormat:@"%.2f",[resp[@"totalCommission"]doubleValue]];
            weakSelf.headerView.dangrishouyi.text = [NSString stringWithFormat:@"%.2f",[resp[@"receivePaymentCommission"]doubleValue]];
            weakSelf.headerView.dangyueshouyi.text = [NSString stringWithFormat:@"%.2f",[resp[@"monthCommission"]doubleValue]];
 
        weakSelf.headerView.shuakayongjin.text = [NSString stringWithFormat:@"%.2f",[resp[@"receivePaymentCommission"]doubleValue]];
        weakSelf.headerView.huankuanyongjin.text = [NSString stringWithFormat:@"%.2f",[resp[@"consumptionCommission"]doubleValue]];
        weakSelf.headerView.fenxiangjiang.text = [NSString stringWithFormat:@"%.2f",[resp[@"share"]doubleValue]];
        weakSelf.headerView.tuanduizhuoyue.text = [NSString stringWithFormat:@"%.2f",[resp[@"team"]doubleValue]];
        weakSelf.headerView.ganen.text = [NSString stringWithFormat:@"%.2f",[resp[@"thanksgiving"]doubleValue]];
        weakSelf.headerView.dailishoukuanyongjin.text = [NSString stringWithFormat:@"%.2f",[resp[@"agentReceivePaymentCommission"]doubleValue]];
        weakSelf.headerView.dailihuankuanyongjin.text = [NSString stringWithFormat:@"%.2f",[resp[@"agentConsumptionCommission"]doubleValue]];
        weakSelf.headerView.pipngjifenrun.text = [NSString stringWithFormat:@"%.2f",[resp[@"sameLevelCommission"]doubleValue]];


    }];
}

/*
 -(NSString *)inStatusOutValue:(NSString*)key{
 //    AgentConsumptionCommission, AgentReceivePaymentCommission, ConsumptionCommission, Coupon, ReceivePaymentCommission, RepaymentSurplusFee, SameLevelCommission, Share, Team, Thanksgiving, Withdraw
     
     if ([key isEqualToString:@"ReceivePaymentCommission"]) {
         return @"刷卡佣金";
     }
     if ([key isEqualToString:@"ConsumptionCommission"]) {
         return @"还款佣金";
     }
     if ([key isEqualToString:@"Share"]) {
         return @"分享奖";
     }
     if ([key isEqualToString:@"Team"]) {
         return @"团队卓越奖";
     }
     if ([key isEqualToString:@"Thanksgiving"]) {
         return @"感恩奖";
     }
     if ([key isEqualToString:@"AgentReceivePaymentCommission"]) {
         return @"代理收款佣金";
     }
     if ([key isEqualToString:@"AgentConsumptionCommission"]) {
         return @"代理还款佣金";
     }
     if ([key isEqualToString:@"SameLevelCommission"]) {
         return @"平级分润";
     }
     if ([key isEqualToString:@"Coupon"]) {
         return @"红包";
     }
     if ([key isEqualToString:@"Withdraw"]) {
         return @"提现";
     }
     if ([key isEqualToString:@"RepaymentSurplusFee"]) {
         return @"还款返现";
     }
     return @"";
 }
*/

@end
