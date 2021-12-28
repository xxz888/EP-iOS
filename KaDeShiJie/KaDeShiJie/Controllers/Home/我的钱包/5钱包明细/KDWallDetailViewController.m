//
//  KDWallDetailViewController.m
//  KaDeShiJie
//
//  Created by mac on 2021/11/25.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDWallDetailViewController.h"
#import "KDWallDetailTableViewCell.h"

@interface KDWallDetailViewController ()< QMUITableViewDataSource, QMUITableViewDelegate>
@property (nonatomic ,strong)NSMutableArray * dataArray;
@end

@implementation KDWallDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:@"钱包明细" tintColor:nil];
//    [self.navigationController.navigationBar setShadowImage:nil];

    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.mc_tableview.delegate = self;
    self.mc_tableview.dataSource = self;
    [self.mc_tableview registerNib:[UINib nibWithNibName:@"KDWallDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"KDWallDetailTableViewCell"];
    self.view.backgroundColor = self.mc_tableview.backgroundColor = [UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
    self.mc_tableview.mj_header =  nil;
    self.dataArray = [[NSMutableArray alloc]init];
    NSString * url1 = @"/api/v1/player/wallet/history";
    [self.sessionManager mc_GET:url1 parameters:nil ok:^(NSDictionary * _Nonnull resp) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:resp];
        [self.mc_tableview reloadData];
        [weakSelf.mc_tableview.mj_header endRefreshing];
    }];
    
}
#pragma mark - QMUITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     "afterBalance": 0,
       "amount": 0,
       "beforeBalance": 0,
       "contributorId": 0,
       "createdTime": "2021-12-17T09:36:01.562Z",
       "event": "AgentConsumptionCommission",
       "eventId": "string",
       "id": 0,
       "memberId": 0
     **/
    KDWallDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"KDWallDetailTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataArray[indexPath.row];
 
    NSString * eventTag = @"";
    if ([dic[@"event"] isEqualToString:@"ReceivePaymentCommission"]) {
        eventTag = @"刷卡佣金";
    }else if([dic[@"event"] isEqualToString:@"ConsumptionCommission"]) {
        eventTag = @"还款佣金";
    }else if([dic[@"event"] isEqualToString:@"Share"]) {
        eventTag = @"分享奖";
    }else if([dic[@"event"] isEqualToString:@"Team"]) {
        eventTag = @"团队卓越奖";
    }else if([dic[@"event"] isEqualToString:@"Thanksgiving"]) {
        eventTag = @"感恩奖";
    }else if([dic[@"event"] isEqualToString:@"AgentReceivePaymentCommission"]) {
        eventTag = @"代理收款佣金";
    }else if([dic[@"event"] isEqualToString:@"AgentConsumptionCommission"]) {
        eventTag = @"代理还款佣金";
    }else if([dic[@"event"] isEqualToString:@"Coupon"]) {
        eventTag = @"红包";
    }else if([dic[@"event"] isEqualToString:@"Withdraw"]) {
        eventTag = @"提现";
    }else if([dic[@"event"] isEqualToString:@"RepaymentSurplusFee"]) {
        eventTag = @"还款剩余手续费";
    }
    
    
    cell.eventTag.text = eventTag;
    
    cell.eventTime.text = dic[@"createdTime"];
    if([dic[@"event"] isEqualToString:@"Withdraw"]) {
        cell.eventPrice.text = [NSString stringWithFormat:@"-%@元",dic[@"amount"]];
    }else{
        cell.eventPrice.text = [NSString stringWithFormat:@"+%@元",dic[@"amount"]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
