//
//  KDHomeViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/5.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDHomeViewController.h"
#import "KDHomeHeaderView.h"
#import "MCHomeServiceViewController.h"
#import "MQServiceToViewInterface.h"
#import <MeiQiaSDK/MQDefinition.h>
#import "KDGuidePageManager.h"
#import "KDRenZhengView.h"
#import "KDWenZinTiShi.h"

@interface KDHomeViewController ()
@property(nonatomic, strong) QMUIModalPresentationViewController *withdrawTypeModal;
@property (nonatomic, strong) KDHomeHeaderView *headerView;
@property (nonatomic, strong) UILabel *redMessageLbl;//未读消息小红点
@property (nonatomic, strong) KDWenZinTiShi *wenZinTiShi;


@property(nonatomic, assign) BOOL updateViewIsShow;

@end

@implementation KDHomeViewController

- (KDHomeHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[KDHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TabBarHeight)];
    }
    return _headerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateNavigationBarAppearance];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBannerImage" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMQMessages:) name:MQ_RECEIVED_NEW_MESSAGES_NOTIFICATION object:nil];

    
    [self.navigationController.tabBarController.tabBar setHidden:NO];

    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)popFirstLogin{
    QMUIModalPresentationViewController * alert = [[QMUIModalPresentationViewController alloc]init];
    KDWenZinTiShi * renzhengView = [KDWenZinTiShi renZhengView];
    renzhengView.frame = CGRectMake(0, 0, 316, 330);
    alert.contentView = renzhengView;
    alert.dimmingView.userInteractionEnabled = NO;
    [alert showWithAnimated:YES completion:nil];
    
    
    renzhengView.closeActionBlock = ^{
        [alert hideWithAnimated:YES completion:nil];

    };
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    if (@available(iOS 11.0, *)) {
//        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
//
//    self.mc_tableview.tableHeaderView = self.headerView;
//    self.mc_tableview.backgroundColor = [UIColor whiteColor];
//
//
//
    __weak typeof(self) weakSelf = self;
//    self.headerView.callBack = ^(CGFloat viewHig) {
//        weakSelf.headerView.ly_height = viewHig;
//    };
    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.mc_tableview.mj_header endRefreshing];
    }];
//    [self setNavigationBarTitle:@"首页" backgroundImage:[UIImage qmui_imageWithColor:[UIColor colorWithHexString:@"#F07E1B"]]];
//
//    QMUIButton *kfBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
//    [kfBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//    [kfBtn setTitle:@"客服" forState:UIControlStateNormal];
//    [kfBtn addTarget:self action:@selector(clickKFAction) forControlEvents:UIControlEventTouchUpInside];
//    kfBtn.spacingBetweenImageAndTitle = 5;
//    kfBtn.titleLabel.font = LYFont(13);
//    [kfBtn setImage:[UIImage imageNamed:@"kd_home_kf"] forState:UIControlStateNormal];
//    kfBtn.frame = CGRectMake(SCREEN_WIDTH - 84, StatusBarHeight, 64, 44);
//    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:kfBtn];
//    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
//    [UITabBar appearance].layer.borderWidth = 0.0f;
//    [UITabBar appearance].clipsToBounds = YES;
//
//
//    [kfBtn addSubview:self.redMessageLbl];
 
    
    
//    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    self.mc_tableview.tableHeaderView = self.headerView;

    self.mc_tableview.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setImage:[UIImage mc_imageNamed:@"nav_left_white"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.frame = CGRectMake(0, StatusBarHeightConstant, 44, 44);
//    [self.view addSubview:backBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"客服" forState:UIControlStateNormal];
//    [shareBtn setBackgroundColor:[UIColor whiteColor]];
//    shareBtn.layer.cornerRadius = 11;
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickKFAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.titleLabel.font = LYFont(13);
    shareBtn.frame = CGRectMake(SCREEN_WIDTH - 84, StatusBarHeightConstant + 12, 94, 22);
    [self.view addSubview:shareBtn];
    [self setNavigationBarHidden];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, StatusBarHeightConstant, 150, 44)];
    titleLabel.text = @"首页";
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    if (MCModelStore.shared.isFirstLogin) {
        [self popFirstLogin];
        MCModelStore.shared.isFirstLogin= NO;
    }

}

- (void)clickKFAction
{
    [self.navigationController pushViewController:[[MCHomeServiceViewController alloc] init] animated:YES];
    //    [MCServiceStore pushMeiqiaVC];
}
-(void)showGuidePage{
    UIButton * btn = [self.headerView viewWithTag:102];
    //空白的frame
    CGRect emptyRect = CGRectMake(0, kTopHeight+29, btn.size_sd.width, btn.size_sd.height);
    //图片的frame
    CGRect imgRect = CGRectMake(btn.size_sd.width/2, kTopHeight+35+btn.size_sd.height, kRealWidthValue(200), kRealWidthValue(200)*1417/1890);
    kWeakSelf(self);
    [[KDGuidePageManager shareManager] showGuidePageWithType:KDGuidePageTypeHome emptyRect:emptyRect imgRect:imgRect imgStr:@"guide1" completion:^{
        [weakself.headerView btnAction:[weakself.headerView viewWithTag:102]];
    }];
}
@end
