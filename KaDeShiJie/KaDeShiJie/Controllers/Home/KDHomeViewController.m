//
//  KDHomeViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/5.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDHomeViewController.h"
#import "KDHomeHeaderView.h"
#import "KDHomeServeViewController.h"
#import "MQServiceToViewInterface.h"
#import <MeiQiaSDK/MQDefinition.h>
#import "KDGuidePageManager.h"
#import "KDRenZhengView.h"
#import "KDWenZinTiShi.h"
#import "MCMessageModel.h"
#import "KDHomeCardKnowledgeTableViewCell.h"
#import "KDHtmlWebViewController.h"

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

@property (nonatomic ,strong) NSMutableArray * cardEncyArray;


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
    self.mc_nav_hidden = YES;
    [self getMessage];
    [self getCreditArticleList];
    [self reloadUserInfo];
    [self.mc_tableview reloadData];
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

    
    
    [[MCSessionManager shareManager] mc_GET:@"/api/v1/player/init" parameters:nil ok:^(NSDictionary * _Nonnull okResponse) {
        SharedDefaults.configDic = okResponse;
    } other:^(NSDictionary * _Nonnull resp) {
        
    }];
    __weak typeof(self) weakSelf = self;
    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.mc_tableview.mj_header endRefreshing];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBannerImage" object:nil];
        [weakSelf getMessage];
        [weakSelf getCreditArticleList];
        [weakSelf reloadUserInfo];

    }];
    
    self.mc_tableview.mj_footer = nil;
    
    self.mc_tableview.tableHeaderView = self.headerView;
    self.mc_tableview.tableHeaderView.ly_height =  1155;
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
    
    
    self.cardEncyArray = [[NSMutableArray alloc]init];
 
}

- (void)clickKFAction
{
    [self.navigationController pushViewController:[[KDHomeServeViewController alloc] init] animated:YES];
}
-(void)reloadUserInfo{
    kWeakSelf(self)
    [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
        [weakself.headerView.persionBtn sd_setImageWithURL:[NSURL URLWithString:userInfo.headImg] forState:0 placeholderImage:[UIImage imageNamed:@"pImv"]];

    }];
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
        
//        if ([SharedDefaults.host isEqualToString:@"https://wukatest.flyaworld.com:443"]) {
//
//        }else{
//            MCAppDelegate *appdelegate = (MCAppDelegate *)[UIApplication sharedApplication].delegate;
//            appdelegate.versionCode = resp[@"iosVersion"][@"versionCode"];
//            NSString *remoteVersion = resp[@"iosVersion"][@"versionCode"];
//            NSString *localVersion = @"";
//            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"currentVersion"]) {
//                localVersion =   [[NSUserDefaults standardUserDefaults] objectForKey:@"currentVersion"];
//            }else{
//                [[NSUserDefaults standardUserDefaults] setValue:remoteVersion forKey:@"currentVersion"];
//                localVersion =   [[NSUserDefaults standardUserDefaults] objectForKey:@"currentVersion"];
//            }
//            NSComparisonResult result = [remoteVersion compare:localVersion options:NSNumericSearch];
//            if (result == NSOrderedDescending) {
//                MCUpdateAlertView *updateView = [[[NSBundle OEMSDKBundle] loadNibNamed:@"MCUpdateAlertView" owner:nil options:nil] firstObject];
//                NSString * str = @"1、修改已知bug。\n2、优化用户体验";
//                [updateView showWithVersion:remoteVersion content:str downloadUrl:resp[@"iosVersion"][@"downloadUrl"] isForce:[resp[@"iosVersion"][@"mandatoryUpdate"] integerValue]];
//            }
//            MCUserInfo * userInfo = SharedUserInfo;
//            if ([userInfo.phone isEqualToString:@"13383773800"]) {
//                UILabel * tagLbl = [weakself.view viewWithTag:104];
//                tagLbl.text = [NSString stringWithFormat:@"首页-%@-%@",SharedAppInfo.version,localVersion];
//            }
//        }
   
        if ([SharedDefaults.host isEqualToString:@"https://wukatest.flyaworld.com:443"]) {
            
        }else{
          
            NSString *remoteVersion = resp[@"iosVersion"][@"versionCode"];
            NSString *localVersion = SharedAppInfo.build;
            NSComparisonResult result = [remoteVersion compare:localVersion options:NSNumericSearch];
            if (result == NSOrderedDescending) {
                MCUpdateAlertView *updateView = [[[NSBundle OEMSDKBundle] loadNibNamed:@"MCUpdateAlertView" owner:nil options:nil] firstObject];
                NSString * str = @"1、修改已知bug。\n2、优化用户体验";
                [updateView showWithVersion:remoteVersion content:str downloadUrl:resp[@"iosVersion"][@"downloadUrl"] isForce:[resp[@"iosVersion"][@"mandatoryUpdate"] integerValue]];
            }
         
        }
    }];
}
- (void)getCreditArticleList {
  
        kWeakSelf(self)
        NSString * url1 = [NSString stringWithFormat:@"/api/v1/player/creditArticle/list?articleType=%@",@"CardEncy"];
        [self.cardEncyArray removeAllObjects];
        [MCLATESTCONTROLLER.sessionManager mc_GET:url1 parameters:nil ok:^(NSDictionary * _Nonnull resp) {
            [weakself.cardEncyArray addObjectsFromArray:resp];
            [weakself.mc_tableview reloadData];
            
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
    return 110;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cardEncyArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDHomeCardKnowledgeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"KDHomeCardKnowledgeTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.cardEncyArray[indexPath.row];
    [cell.cellImv sd_setImageWithURL:dic[@"thumb"] placeholderImage:[UIImage imageNamed:@"logo"]];
    cell.cellTitle.text = dic[@"title"];
    cell.cellContent.text = dic[@"summary"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.cardEncyArray[indexPath.row];
    KDHtmlWebViewController * vc = [[KDHtmlWebViewController alloc]init];
    vc.content = dic[@"content"];
    vc.title = dic[@"title"];

    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.navigationController.navigationBar.hidden = YES;
}

@end
