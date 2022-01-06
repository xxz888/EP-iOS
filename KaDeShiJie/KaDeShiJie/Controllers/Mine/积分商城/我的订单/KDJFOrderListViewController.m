//
//  KDJFOrderListViewController.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/10.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJFOrderListViewController.h"
#import "KDJFOrderTableViewCellTableViewCell.h"
#import "KDJFOrderDetailViewController.h"

@interface KDJFOrderListViewController ()<QMUITableViewDataSource, QMUITableViewDelegate,MCSegementViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) MCSegementView *segement;

@property(nonatomic, strong) NSString *orderState;
@end

@implementation KDJFOrderListViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (MCSegementView *)segement {
    if (!_segement) {
        _segement = [[MCSegementView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, 45)];
        _segement.titles = @[@"全部",@"待收货",@"待发货",@"已完成",@"已取消"];
        _segement.delegate = self;
    }
    return _segement;
}
#pragma mark - MCSegementViewDelegate
- (void)segementViewDidSeletedIndex:(NSInteger)index buttonTitle:(NSString *)title {
    [self.dataArray removeAllObjects];
    [self.mc_tableview reloadData];
//    Cancel, Close, Complete, Failed, Init, Paid, Paying, Sms, Unpaid, Unreceived, Unshipped
//    Init, // 初始化
//    Sms, // 发短信验证
//    Unpaid, // 支付中
//    Paying, // 支付中
//    Paid, // 已支付
//    Unshipped, // 待发货
//    Unreceived, // 待收货
//    Complete, // 完成
//    Cancel, // 取消
//    Failed,//失败,
//    Close,
    if (index == 0) {
        self.orderState = @"0";
    }else  if (index == 1) {
        self.orderState = @"Unreceived";
    }else  if (index == 2) {
        self.orderState = @"Unshipped";
    }else  if (index == 3) {
        self.orderState = @"Complete";
    }else  if (index == 4) {
        self.orderState = @"Cancel";
    }
    
    
    [self requestData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.segement];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.mc_tableview.rowHeight = 130;
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.backgroundColor = [UIColor clearColor];
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mc_tableview.tableFooterView = [UIView new];
    self.mc_tableview.ly_emptyView = [MCEmptyView emptyView];
    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
    [self setNavigationBarTitle:@"我的订单" tintColor:nil];
    
    [self.mc_tableview reloadData];
    self.orderState = @"0";
    [self requestData];
}
-(void)requestData{
    kWeakSelf(self);
    
    NSString * url = @"";
    if ([self.orderState isEqualToString:@"0"]) {
        url =  @"/api/v1/player/shop/order";
    }else{
        url =  [NSString stringWithFormat:@"/api/v1/player/shop/order?orderState=%@",self.orderState];
    }
    [self.sessionManager mc_GET:url parameters:@{} ok:^(NSDictionary * _Nonnull respDic) {
        weakself.dataArray  = [[NSMutableArray alloc]initWithArray:respDic];
        [weakself.mc_tableview reloadData];
        [weakself.mc_tableview.mj_header endRefreshing];
    }];
//    [self.sessionManager mc_Post_QingQiuTi:@"facade/app/coin/order/list" parameters:@{@"status":@"1",
//                                                                                      @"count":@"1",
//                                                                                      @"startTime":@"2021-06-1 00:00:00",
//                                                                                      @"endTime":@"2021-12-31 00:00:00"} ok:^(NSDictionary * _Nonnull resp) {
//        [weakself.dataArray removeAllObjects];
//        [weakself.dataArray addObjectsFromArray:resp[@"result"][@"content"]];
//        [weakself.mc_tableview reloadData];
//    } other:^(NSDictionary * _Nonnull resp) {
//        [MCLoading hidden];
//    } failure:^(NSError * _Nonnull error) {
//        [MCLoading hidden];
//    }];
}
#pragma mark - QMUITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 120;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Cancel, Complete, Failed, Init, Paid, Unpaid, Unreceived, Unshipped
    KDJFOrderTableViewCellTableViewCell *cell = [KDJFOrderTableViewCellTableViewCell cellWithTableView:tableView];
    NSDictionary * dic = self.dataArray[indexPath.row];
    cell.orderTitle.text = [NSString stringWithFormat:@"订单号:%@",dic[@"orderId"]];
    cell.orderContent.text = dic[@"title"];
  /*
   Init, // 初始化
   Unpaid, // 支付中
   Paid, // 已支付
   Unshipped, // 待发货
   Unreceived, // 待收货
   Complete, // 完成
   Cancel, // 取消
   Failed,//失败,
   Close,
   
   **/
    cell.orderStatus.text =
    
    [dic[@"logisticsState"] isEqualToString:@"Cancel"] ? @"已取消" :
    [dic[@"logisticsState"] isEqualToString:@"Complete"] ? @"已完成" :
    [dic[@"logisticsState"] isEqualToString:@"Failed"] ? @"已失败" :
    [dic[@"logisticsState"] isEqualToString:@"Init"] ? @"初始" :
    [dic[@"logisticsState"] isEqualToString:@"Paid"] ? @"已支付" :
    [dic[@"logisticsState"] isEqualToString:@"Unpaid"] ? @"支付中" :
    [dic[@"logisticsState"] isEqualToString:@"Unreceived"] ? @"待收货" :
    [dic[@"logisticsState"] isEqualToString:@"Unshipped"] ? @"待发货" : @"";
    cell.orderPrice.text = [NSString stringWithFormat:@"%@元",dic[@"price"]];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    KDJFOrderDetailViewController * vc = [[KDJFOrderDetailViewController alloc]init];
//    vc.orderDic = self.dataArray[indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)layoutTableView{
    self.mc_tableview.frame = CGRectMake(0, NavigationContentTop+45, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop-45);
}
@end
