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
    
//    [self setNavigationBarTitle:@"我的钱包" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    [self setNavigationBarHidden];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, StatusBarHeightConstant, 150, 44)];
    titleLabel.text = @"支付收益";
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}
-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
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
