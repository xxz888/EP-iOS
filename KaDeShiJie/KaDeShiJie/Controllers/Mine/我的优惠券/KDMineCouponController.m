//
//  KDMineCouponController.m
//  KaDeShiJie
//
//  Created by BH on 2021/12/30.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDMineCouponController.h"
#import "KDMineCouponTableViewCell.h"

@interface KDMineCouponController()<QMUITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;

@end
@implementation KDMineCouponController


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle: @"我的抵扣券"  tintColor:nil];

    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.mc_tableview.rowHeight = 110;
    self.mc_tableview.dataSource = self;
    // 导航条
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof(self) weakSelf = self;
    [self.sessionManager mc_GET:@"/api/v1/player/user/coupon" parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:resp];
        [weakSelf.mc_tableview reloadData];
    }];
   
}

#pragma mark - QMUITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDMineCouponTableViewCell *cell = [KDMineCouponTableViewCell cellWithTableView:tableView];
    NSDictionary * dic = self.dataArray[indexPath.row];
    cell.titleLbl.text = [NSString stringWithFormat:@"%@元现金抵扣券",dic[@"maximumUsageAmount"]];
    cell.priceLbl.text =  [NSString stringWithFormat:@"%@",dic[@"maximumUsageAmount"]];
    cell.shouxufeiLbl.text = [NSString stringWithFormat:@"单次抵扣手续费的%.0f%%",[dic[@"discountRate"] doubleValue]];
    cell.shengyueLbl.text =  [NSString stringWithFormat:@"剩余可抵金额：%.2f",[dic[@"usageAmount"] doubleValue]];
    cell.beizhuLbl.text =   [NSString stringWithFormat:@"备注：%@",dic[@"describe"]];
    return cell;
}

- (void)layoutTableView
{
    self.mc_tableview.frame = CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop);
}
@end
