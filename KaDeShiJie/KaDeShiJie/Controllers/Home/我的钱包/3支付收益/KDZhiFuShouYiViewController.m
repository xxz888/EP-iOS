//
//  KDZhiFuShouYiViewController.m
//  KaDeShiJie
//
//  Created by mac on 2021/11/25.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDZhiFuShouYiViewController.h"
#import "KDZhiFuShouYiHeaderView.h"

@interface KDZhiFuShouYiViewController ()
@property (nonatomic, strong) KDZhiFuShouYiHeaderView *headerView;

@end

@implementation KDZhiFuShouYiViewController

- (KDZhiFuShouYiHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[KDZhiFuShouYiHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TabBarHeight)];
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
    
//    [self setNavigationBarTitle:@"我的钱包" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    [self setNavigationBarHidden];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, StatusBarHeightConstant, 150, 44)];
    titleLabel.text = @"支付收益";
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [self requestData];
}

-(void)requestData{
    __weak __typeof(self)weakSelf = self;
    NSString * url1 = @"/api/v1/player/wallet/commission/payment";
    [self.sessionManager mc_GET:url1 parameters:nil ok:^(NSDictionary * _Nonnull resp) {

            weakSelf.headerView.zongshouyi.text = [NSString stringWithFormat:@"%.2f",[resp[@"totalCommission"]doubleValue]];
            weakSelf.headerView.dangrishouyi.text = [NSString stringWithFormat:@"%.2f",[resp[@"todayCommission"]doubleValue]];
            weakSelf.headerView.dangyueshouyi.text = [NSString stringWithFormat:@"%.2f",[resp[@"monthCommission"]doubleValue]];
 
        weakSelf.headerView.kuaijiefenrun.text = [NSString stringWithFormat:@"%.2f",[resp[@"consumptionCommission"]doubleValue]];
        weakSelf.headerView.huankuanfenrun.text = [NSString stringWithFormat:@"%.2f",[resp[@"receivePaymentCommission"]doubleValue]];
        weakSelf.headerView.jiujifenrun.text = [NSString stringWithFormat:@"%.2f",[resp[@"agentLevelCommission"]doubleValue]];

        
    }];
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
