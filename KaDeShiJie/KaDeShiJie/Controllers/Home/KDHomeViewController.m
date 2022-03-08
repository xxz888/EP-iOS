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
#import "MCMessageModel.h"
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
    

    
    [self.navigationController.tabBarController.tabBar setHidden:NO];

    [self getMessage];
    if (MCModelStore.shared.isFirstLogin) {
        [self popFirstLogin];
        MCModelStore.shared.isFirstLogin= NO;
    }
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
    self.headerView.callBack = ^(CGFloat viewHig) {
        weakSelf.headerView.ly_height = viewHig;
    };
    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.mc_tableview.mj_header endRefreshing];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBannerImage" object:nil];
        [weakSelf getMessage];
    }];
    
    self.mc_tableview.mj_footer = nil;
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
    [shareBtn setTitle:@"  客服" forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"kd_home_kf"] forState:UIControlStateNormal];

//    [shareBtn setBackgroundColor:[UIColor whiteColor]];
//    shareBtn.layer.cornerRadius = 11;
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickKFAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.titleLabel.font = LYFont(13);
    shareBtn.frame = CGRectMake(SCREEN_WIDTH - 120, StatusBarHeightConstant + 12, 120, 22);
    [self.view addSubview:shareBtn];
    [self setNavigationBarHidden];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, StatusBarHeightConstant, 150, 44)];
    titleLabel.text = @"首页";
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    

    
    [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
       
    }];
}

- (void)clickKFAction
{
    [self.navigationController pushViewController:[[MCHomeServiceViewController alloc] init] animated:YES];
}
- (void)getMessage {
    kWeakSelf(self)
    [MCLATESTCONTROLLER.sessionManager mc_GET:@"/api/v1/player/init" parameters:nil ok:^(NSDictionary * _Nonnull resp) {
        
    
        //Dialog
        NSString * alertString = @"";
        NSString * alertTitle = @"";
        NSString * msgId = @"";
            if ([resp[@"notice"][@"noticeType"] isEqualToString:@"Dialog"]) {
                msgId = [NSString stringWithFormat:@"%@",resp[@"notice"][@"id"]];
                alertString = resp[@"notice"][@"content"];
                alertTitle = resp[@"notice"][@"title"];
            }
           
        NSString * currentId =  [NSString stringWithFormat:@"%@%@",@"msgShow",msgId];
        NSString * saveId = [[NSUserDefaults standardUserDefaults] objectForKey:currentId];
        if (saveId && [saveId isEqualToString:@"1"]) {
            
        }else{
            if (alertString.length == 0) {
                
            }else{
                if (msgId.length == 0) {
                    
                }else{
                    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:currentId];
                    [self messageAlert1:alertTitle content:alertString];
                }
               
            }

        }
//        MCUpdateAlertView *updateView = [[[NSBundle OEMSDKBundle] loadNibNamed:@"MCUpdateAlertView" owner:nil options:nil] firstObject];
//        NSString * str = @"染发的身份获得随机发货速度放寒假开始的染发的身份获得随机发货速度放寒假开始的染发的身份获得随机发货速度放寒假开始的染发的身份获得随机发货速度放寒假开始的染发的身份获得随机发货速度放寒假开始的染发的身份获得随机发货速度放寒假开始的染发的身份获得随机发货速度放寒假开始的";
//        [updateView showWithVersion:@"1.0.1" content:str downloadUrl:resp[@"config"][@"iosDownLink"] isForce:YES];
        
//        NSString *localVersion = @"";
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"currentVersion"]) {
//            localVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentVersion"];
//        }else{
//
//            if ([SharedAppInfo.build isEqualToString:@"1.0.0"] ||
//                [SharedAppInfo.version isEqualToString:@"1.0.0"] ||
//                [SharedAppInfo.version containsString:@"1.0"]) {
//                    MCUpdateAlertView *updateView = [[[NSBundle OEMSDKBundle] loadNibNamed:@"MCUpdateAlertView" owner:nil options:nil] firstObject];
//                    NSString * str = @"1、修改已知bug。\n2、优化用户体验";
//                    [updateView showWithVersion:remoteVersion content:str downloadUrl:resp[@"iosVersion"][@"downloadUrl"] isForce:[resp[@"iosVersion"][@"mandatoryUpdate"] integerValue]];
//            }else{
//                [[NSUserDefaults standardUserDefaults] setValue:remoteVersion forKey:@"currentVersion"];
//            }
//            return;
//        }
        //升级
        NSString *remoteVersion = resp[@"iosVersion"][@"versionCode"];
        NSString *localVersion = SharedAppInfo.version;
        NSComparisonResult result = [remoteVersion compare:localVersion options:NSNumericSearch];
        if (result == NSOrderedDescending) {
            MCUpdateAlertView *updateView = [[[NSBundle OEMSDKBundle] loadNibNamed:@"MCUpdateAlertView" owner:nil options:nil] firstObject];
            NSString * str = @"1、修改已知bug。\n2、优化用户体验";
            [updateView showWithVersion:remoteVersion content:str downloadUrl:resp[@"iosVersion"][@"downloadUrl"] isForce:[resp[@"iosVersion"][@"mandatoryUpdate"] integerValue]];
        }
    }];
}
-(void)messageAlert1:(NSString *)title content:(NSString *)content{
    QMUIModalPresentationViewController * alert = [[QMUIModalPresentationViewController alloc]init];
    KDWenZinTiShi * renzhengView = [KDWenZinTiShi renZhengView];
    renzhengView.titleString = title;
    renzhengView.contentString = content;
    [renzhengView setData];
    renzhengView.frame = CGRectMake(0, 0, 316, 330);
    alert.contentView = renzhengView;
    alert.dimmingView.userInteractionEnabled = NO;
    [alert showWithAnimated:YES completion:nil];
    
    
    renzhengView.closeActionBlock = ^{
        [alert hideWithAnimated:YES completion:nil];

    };
}
@end
