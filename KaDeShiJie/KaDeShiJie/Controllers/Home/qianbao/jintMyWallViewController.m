//
//  jintMyWallViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/5.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "jintMyWallViewController.h"
#import "KDMyWallView.h"
#import "KDTiXianViewController.h"
@interface jintMyWallViewController ()
@property (nonatomic, strong) KDMyWallView *headerView;

@property(nonatomic, assign) BOOL updateViewIsShow;

@end

@implementation jintMyWallViewController

- (KDMyWallView *)headerView
{
    if (!_headerView) {
        _headerView = [[KDMyWallView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _headerView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"我的钱包" tintColor:[UIColor whiteColor]];

   
    
    
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.mc_tableview.tableHeaderView = self.headerView;
    self.mc_tableview.backgroundColor = [UIColor whiteColor];

//    [self setNavigationBarHidden];


    [self requestData];
}
-(void)requestData{
    __weak __typeof(self)weakSelf = self;
    NSString * url1 = @"/api/v1/player/wallet";
    [self.sessionManager mc_GET:url1 parameters:nil ok:^(NSDictionary * _Nonnull resp) {
        [weakSelf.headerView setDataDic:[NSDictionary dictionaryWithDictionary:resp]];
    }];
    
    
}
-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)layoutTableView
{
    self.mc_tableview.frame = CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop);
}
@end
