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
#import "KDHomeCardKnowledgeTableViewCell.h"

@interface KDHomeViewController ()<UITableViewDelegate,UITableViewDataSource,QMUITableViewDataSource, QMUITableViewDelegate>
{
    CGFloat alpha;
}
@property(nonatomic, strong) QMUIModalPresentationViewController *withdrawTypeModal;
@property (nonatomic, strong) KDHomeHeaderView *headerView;
@property (nonatomic, strong) UILabel *redMessageLbl;//未读消息小红点
@property (nonatomic, strong) KDWenZinTiShi *wenZinTiShi;
@property (nonatomic ,strong) UIView * bgView;

@property(nonatomic, assign) BOOL updateViewIsShow;
@property (nonatomic,  assign) BOOL  statusBarFlag;

@end

@implementation KDHomeViewController

- (KDHomeHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[KDHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1300)];
    }
    return _headerView;
}
-(void)layoutTableView{
    self.mc_tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -TabBarHeight);
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateNavigationBarAppearance];


    [self getMessage];
    if (MCModelStore.shared.isFirstLogin) {
        [self popFirstLogin];
        MCModelStore.shared.isFirstLogin= NO;
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (_statusBarFlag) {
            return UIStatusBarStyleDefault; // 黑色
        }
        return UIStatusBarStyleLightContent; // 白色
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
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setNavigationBarHidden];


    
    __weak typeof(self) weakSelf = self;
    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.mc_tableview.mj_header endRefreshing];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBannerImage" object:nil];
        [weakSelf getMessage];
    }];
    
    self.mc_tableview.mj_footer = nil;


    self.mc_tableview.tableHeaderView = self.headerView;
    self.mc_tableview.tableHeaderView.ly_height = 1155;
    self.mc_tableview.backgroundColor = [UIColor clearColor];
    [self.mc_tableview registerNib:[UINib nibWithNibName:@"KDHomeCardKnowledgeTableViewCell" bundle:nil] forCellReuseIdentifier:@"KDHomeCardKnowledgeTableViewCell"];
    self.mc_tableview.delegate = self;
    self.mc_tableview.dataSource = self;
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;

    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"  客服" forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"kd_home_kf"] forState:UIControlStateNormal];

    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickKFAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.titleLabel.font = LYFont(13);
    shareBtn.frame = CGRectMake(SCREEN_WIDTH - 120, StatusBarHeightConstant + 12, 120, 22);
//    [self.view addSubview:shareBtn];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, StatusBarHeightConstant, 150, 44)];
    titleLabel.text = @"首页";
    titleLabel.tag = 104;
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.adjustsFontSizeToFitWidth  = YES;
    //[self.view addSubview:titleLabel];
    
    
    

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
        MCAppDelegate *appdelegate = (MCAppDelegate *)[UIApplication sharedApplication].delegate;
        appdelegate.versionCode = resp[@"iosVersion"][@"versionCode"];
        NSString *remoteVersion = resp[@"iosVersion"][@"versionCode"];
        NSString *localVersion = @"";
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"currentVersion"]) {
            localVersion =   [[NSUserDefaults standardUserDefaults] objectForKey:@"currentVersion"];
        }else{
            [[NSUserDefaults standardUserDefaults] setValue:remoteVersion forKey:@"currentVersion"];
            localVersion =   [[NSUserDefaults standardUserDefaults] objectForKey:@"currentVersion"];
        }
        NSComparisonResult result = [remoteVersion compare:localVersion options:NSNumericSearch];
        if (result == NSOrderedDescending) {
            MCUpdateAlertView *updateView = [[[NSBundle OEMSDKBundle] loadNibNamed:@"MCUpdateAlertView" owner:nil options:nil] firstObject];
            NSString * str = @"1、修改已知bug。\n2、优化用户体验";
            [updateView showWithVersion:remoteVersion content:str downloadUrl:resp[@"iosVersion"][@"downloadUrl"] isForce:[resp[@"iosVersion"][@"mandatoryUpdate"] integerValue]];
        }
        MCUserInfo * userInfo = SharedUserInfo;
        if ([userInfo.phone isEqualToString:@"13383773800"]) {
            UILabel * tagLbl = [weakself.view viewWithTag:104];
            tagLbl.text = [NSString stringWithFormat:@"首页-%@-%@",SharedAppInfo.version,localVersion];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDHomeCardKnowledgeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"KDHomeCardKnowledgeTableViewCell" forIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
}

- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height+20)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,8, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height+20)];
        titleLabel.text = @"首页";
        titleLabel.tag = 104;
        titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        titleLabel.adjustsFontSizeToFitWidth  = YES;
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.hidden = YES;
        [_bgView addSubview:titleLabel];
        
        [self.navigationController.view insertSubview:_bgView belowSubview:self.navigationController.navigationBar];
    }
    return _bgView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    alpha = scrollView.contentOffset.y/100;
    UILabel * lbl = [self.bgView viewWithTag:104];

    if (alpha > 1) {
        alpha = 1;
        _statusBarFlag = YES;
        lbl.hidden = NO;
        [self setNeedsStatusBarAppearanceUpdate];
    }else{
        _statusBarFlag = NO;
        lbl.hidden = YES;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    lbl.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:alpha];
    [self bgView].backgroundColor = [UIColor colorWithRed:252/255.0 green:155/255.0 blue:51/255.0 alpha:alpha];
}


@end
