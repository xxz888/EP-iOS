//
//  jintMyWallViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/5.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "jintMyWallViewController.h"
#import "KDMyWallView.h"

@interface jintMyWallViewController ()
@property (nonatomic, strong) KDMyWallView *headerView;

@property(nonatomic, assign) BOOL updateViewIsShow;

@end

@implementation jintMyWallViewController

- (KDMyWallView *)headerView
{
    if (!_headerView) {
        _headerView = [[KDMyWallView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TabBarHeight)];
    }
    return _headerView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateNavigationBarAppearance];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBannerImage" object:nil];
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
    self.mc_tableview.backgroundColor = [UIColor whiteColor];
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage mc_imageNamed:@"nav_left_white"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
        backBtn.frame = CGRectMake(0, StatusBarHeightConstant, 44, 44);
        [self.view addSubview:backBtn];
    
//    [self setNavigationBarTitle:@"我的钱包" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    [self setNavigationBarHidden];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, StatusBarHeightConstant, 150, 44)];
    titleLabel.text = @"我的钱包";
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}
-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
