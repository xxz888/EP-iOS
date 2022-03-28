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
#import "KDTrandingRecordViewController.h"
@interface KDMineViewController ()<UITableViewDelegate>
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
 
//    NSString * level = [self getLevel:SharedUserInfo.level];
    
//    self.header.phoneLabel.text = SharedUserInfo.phone;
//    self.header.nameLabel.text = [NSString stringWithFormat:@"昵称:%@",SharedUserInfo.nickname];
//    self.header.levelViwe.text = [NSString stringWithFormat:@"%@",level];
////    self.header.nameLabel.text = [NSString stringWithFormat:@"昵称：%@ %@",SharedUserInfo.nickname,level];
//    self.header.dianhua.text =   [NSString stringWithFormat:@"联系客服：%@",SharedDefaults.configDic[@"servicePhone"]];
//    [self.header.headImv sd_setImageWithURL:[NSURL URLWithString:SharedUserInfo.headImg] placeholderImage:[UIImage imageNamed:@"pImv"]];
//    self.header.idLabel.text =[NSString stringWithFormat:@"邀请码:%@", SharedUserInfo.promoteId];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    self.mc_tableview.tableHeaderView = self.header;
    self.mc_tableview.delegate = self;
    self.mc_tableview.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self reloadData];

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
//    [self.view addSubview:titleLabel];
    
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"交易记录" forState:UIControlStateNormal];
//    [shareBtn setBackgroundColor:[UIColor whiteColor]];
//    shareBtn.layer.cornerRadius = 11;
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(jiaoyijiluAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.titleLabel.font = LYFont(13);
    shareBtn.frame = CGRectMake(SCREEN_WIDTH - 84, StatusBarHeightConstant + 12, 94, 22);
//    [self.view addSubview:shareBtn];
}
-(void)jiaoyijiluAction{
    [MCLATESTCONTROLLER.navigationController pushViewController:[KDTrandingRecordViewController new] animated:YES];

}
- (void)mc_tableviewRefresh {
    [self reloadData];
}
- (void)reloadData {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBannerImage" object:nil];
    // 头部数据
    [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
        if ([self.mc_tableview.mj_header isRefreshing]) {
            [self.mc_tableview.mj_header endRefreshing];
        }
        
        //
        NSString * level = [self getLevel:userInfo.level];
        self.header.nameLabel.text = [NSString stringWithFormat:@"%@",userInfo.nickname];
        self.header.levelViwe.text = [NSString stringWithFormat:@"%@",level];
        self.header.dianhua.text =   [NSString stringWithFormat:@"联系客服：%@",SharedDefaults.configDic[@"servicePhone"]];
        [self.header.headImv sd_setImageWithURL:[NSURL URLWithString:userInfo.headImg] placeholderImage:[UIImage imageNamed:@"pImv"]];
        self.header.idLabel.text =[NSString stringWithFormat:@"邀请码:%@", userInfo.promoteId];

    }];
    
    
    

    
}

/*
 
 1、普通用户
 2、VIP用户
 3、一星代理
 4、二星代理
 5、三星代理
 6、四星代理
 7、五星代理
 8、六星代理
 9、七星代理
 10、八星代理
 11、九星代理
 **/
-(NSString *)getLevel:(NSString *)level{
    if ([level isEqualToString:@"Normal"]) {
        return  @"普通用户";
    }
    if ([level isEqualToString:@"Diamond"]) {
        return  @"VIP用户";
    }
    if ([level containsString:@"1"]) {
        return  @"一星代理";
    }
    if ([level containsString:@"2"]) {
        return  @"二星代理";
    }
    if ([level containsString:@"3"]) {
        return  @"三星代理";
    }
    if ([level containsString:@"4"]) {
        return  @"四星代理";
    }
    if ([level containsString:@"5"]) {
        return  @"五星代理";
    }
    if ([level containsString:@"6"]) {
        return  @"六星代理";
    }
    if ([level containsString:@"7"]) {
        return  @"七星代理";
    }
    if ([level containsString:@"8"]) {
        return  @"八星代理";
    }
    if ([level containsString:@"9"]) {
        return  @"九星代理";
    }
    return  @"";
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.navigationController.navigationBar.hidden = YES;
}
@end
