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
    
    
    [self setNavigationBarTitle:@"我的钱包" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];

}

- (void)layoutTableView
{
    self.mc_tableview.frame = CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop);
}

@end
