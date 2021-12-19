//
//  KDMineViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/5.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDMineViewController.h"
#import "KDMineHeaderView.h"
#import "MCUserHeaderView.h"
@interface KDMineViewController ()
@property (nonatomic, strong) KDMineHeaderView *header;
@end

@implementation KDMineViewController

- (KDMineHeaderView *)header
{
    if (!_header) {
        _header = [[KDMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 470)];
    }
    return _header;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
    [self reloadData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    self.mc_tableview.tableHeaderView = self.header;

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
    
    [self setNavigationBarHidden];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, StatusBarHeightConstant, 150, 44)];
    titleLabel.text = @"我的";
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}


- (void)reloadData {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBannerImage" object:nil];
    // 头部数据
    [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
        if ([self.mc_tableview.mj_header isRefreshing]) {
            [self.mc_tableview.mj_header endRefreshing];
        }
        
        //
        NSString * level = @"";
        if (userInfo.level) {
            if ([userInfo.level isEqualToString:@"Normal"]) {
                level = @"普通用户";
            }else{
                level = @"钻石用户";
            }
        }
     
    
        self.header.phoneLabel.text = userInfo.phone;
        self.header.nameLabel.text = [NSString stringWithFormat:@"%@ [%@]",userInfo.nickname,level];
        
        
//        SharedUserInfo = userInfo;
//        self.header.nameLabel.text = SharedUserInfo.nickname || SharedUserInfo.nickname.length != 0 ? SharedUserInfo.nickname :SharedUserInfo.realname;
        
//        NSString *firstName = [userInfo.realname substringWithRange:NSMakeRange(0, 1)];
//        if (userInfo.realname.length == 2) {
//            self.header.nameLabel.text = [NSString stringWithFormat:@"%@*", firstName];
//        } else {
//            NSString *lastName = [userInfo.realname substringFromIndex:userInfo.realname.length-1];
//            self.header.nameLabel.text = [NSString stringWithFormat:@"%@*%@", firstName, lastName];
//        }
//        NSString *first = [userInfo.phone substringWithRange:NSMakeRange(0, 3)];
//        NSString *last = [userInfo.phone substringWithRange:NSMakeRange(7, 4)];
//        self.header.phoneLabel.text = [NSString stringWithFormat:@"%@****%@", first, last];
//        self.header.idLabel.text = [NSString stringWithFormat:@"ID：%@", userInfo.userid];
//
//
//        [self.header getUserGradeName];
//
//        MCUserHeaderView * mcUserHeaderView = [self.header viewWithTag:2001];
//        [mcUserHeaderView fetchHeaderPath];
    }];
}

@end
