//
//  KDShareViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/5.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDShareViewController.h"
#import "KDShareHeaderView.h"
#import "KDShareViewCell.h"
#import "KDWXViewController.h"

@interface KDShareViewController ()<QMUITableViewDelegate, QMUITableViewDataSource>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) KDShareHeaderView *header;
@end

@implementation KDShareViewController

- (KDShareHeaderView *)header
{
    if (!_header) {
        _header = [[KDShareHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TabBarHeight)];
    }
    return _header;
}

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[];

    }
    return _dataArray;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"发现" tintColor:UIColor.mainColor];
//    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#f5f5f5"];
    
    self.mc_tableview.tableHeaderView = self.header;
    self.mc_tableview.mj_header = nil;
//    self.mc_tableview.backgroundColor = [UIColor clearColor];
    self.mc_tableview.delegate = self;
    self.mc_tableview.dataSource = self;
    self.mc_tableview.rowHeight = 60;
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mc_tableview.tableFooterView = [UIView new];
//    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self getPlatformData];
//    }];
    [self getPlatformData];
    
    [self.sessionManager mc_GET:@"/api/v1/player/user/propaganda/link" parameters:nil ok:^(NSDictionary * _Nonnull resp) {
        if (resp[@"link"]) {
            MCModelStore.shared.shareLink = resp[@"link"];
        }
      
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDShareViewCell *cell = [KDShareViewCell cellWithTableView:tableView];
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.iconView.image = [UIImage imageNamed:dict[@"icon"]];
    cell.titleView.text = dict[@"title"];
    NSString *des = dict[@"des"];
    if (des.length == 0) {
        cell.desView.hidden = YES;
    } else {
        cell.desView.hidden = NO;
        cell.desView.text = des;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [MCPagingStore pagingURL:rt_news_list withUerinfo:@{@"classification":@"推广物料"}];
            break;
        case 1:
            [self.navigationController pushViewController:[KDWXViewController new] animated:YES];
            break;
        case 2:
            [MCPagingStore pushWebWithTitle:@"新代理育龙特训营" classification:@"功能跳转"];
            break;
        case 3:
            [MCPagingStore pushWebWithTitle:@"卡德中国" classification:@"功能跳转"];
//            [self.navigationController pushViewController:[KDUseExplainViewController new] animated:YES];
            break;
        case 4:
            [MCPagingStore pushWebWithTitle:@"机构政策" classification:@"功能跳转"];
//            [self.navigationController pushViewController:[KDUseExplainViewController new] animated:YES];
            break;
        case 5:
            [MCPagingStore pushWebWithTitle:@"平台介绍" classification:@"功能跳转"];
            break;
            
        default:
            break;
    }
}

- (void)getPlatformData
{
    [[MCSessionManager shareManager] mc_POST:@"/user/app/PlatformData/user/query" parameters:@{@"brandId":SharedConfig.brand_id} ok:^(NSDictionary * _Nonnull resp) {
        [self.mc_tableview.mj_header endRefreshing];
        NSDictionary *content = [resp[@"result"][@"content"] firstObject];
        self.header.content = content;
    }];
}
-(void)layoutTableView{
    self.mc_tableview.frame = CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop-TabBarHeight);
}

@end
