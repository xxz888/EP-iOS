//
//  KDTixianjiluViewController.m
//  KaDeShiJie
//
//  Created by mac on 2021/11/24.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDTixianjiluViewController.h"
#import "KDTixianjiluTableViewCell.h"

@interface KDTixianjiluViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)NSMutableArray * jiluArray;
@end

@implementation KDTixianjiluViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setNavigationBarTitle:@"提现记录" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    [self.navigationController.navigationBar setShadowImage:nil];

    [self.tableView registerNib:[UINib nibWithNibName:@"KDTixianjiluTableViewCell" bundle:nil] forCellReuseIdentifier:@"KDTixianjiluTableViewCell"];
    self.tableView.backgroundColor=self.view.backgroundColor=[UIColor qmui_colorWithHexString:@"#F6F6F6"];
    self.jiluArray = [[NSMutableArray alloc]init];
    [self requestData];
}
-(void)requestData{
//    __weak __typeof(self)weakSelf = self;
//    NSString * url1 = @"/api/v1/player/wallet/history?event=Withdraw";
//    [self.sessionManager mc_GET:url1 parameters:nil ok:^(NSDictionary * _Nonnull resp) {
//        [weakSelf.jiluArray removeAllObjects];
//        [weakSelf.jiluArray addObjectsFromArray:resp];
//        [weakSelf.tableView reloadData];
//    }];
//
//
  __weak __typeof(self)weakSelf = self;
    NSString * url1 = @"/api/v1/player/wallet/withdraw";
    [self.sessionManager mc_GET:url1 parameters:nil ok:^(NSDictionary * _Nonnull resp) {
        [weakSelf.jiluArray removeAllObjects];
        [weakSelf.jiluArray addObjectsFromArray:resp];
        [weakSelf.tableView reloadData];
    }];
    
//    {
//        "bank": "ICBC",
//        "bankCardId": 0,
//        "bankCardNo": "string",
//        "createdTime": "2021-12-06T08:22:02.691Z",
//        "id": 0,
//        "memberId": 0,
//        "modifyTime": "2021-12-06T08:22:02.691Z",
//        "orderId": "string",
//        "state": "Close"
//      }
}

#pragma mark - QMUITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 127;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.jiluArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDTixianjiluTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"KDTixianjiluTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.jiluArray[indexPath.row];
    cell.eventTag.text = dic[@"orderId"];//[self inStatusOutValue:dic[@"event"]];
    cell.eventPrice.text = [NSString stringWithFormat:@"%.2f",[dic[@"amount"] doubleValue]];
    cell.eventTime.text = dic[@"createdTime"];
    cell.eventStatus.text = dic[@"state"];
    
    
    //    {
    //        "bank": "ICBC",
    //        "bankCardId": 0,
    //        "bankCardNo": "string",
    //        "createdTime": "2021-12-06T08:22:02.691Z",
    //        "id": 0,
    //        "memberId": 0,
    //        "modifyTime": "2021-12-06T08:22:02.691Z",
    //        "orderId": "string",
    //        "state": "Close"
    //      }
    return cell;
}
-(NSString *)inStatusOutValue:(NSString*)key{
//    AgentConsumptionCommission, AgentReceivePaymentCommission, ConsumptionCommission, Coupon, ReceivePaymentCommission, RepaymentSurplusFee, SameLevelCommission, Share, Team, Thanksgiving, Withdraw
    
    if ([key isEqualToString:@"ReceivePaymentCommission"]) {
        return @"刷卡佣金";
    }
    if ([key isEqualToString:@"ConsumptionCommission"]) {
        return @"还款佣金";
    }
    if ([key isEqualToString:@"Share"]) {
        return @"分享奖";
    }
    if ([key isEqualToString:@"Team"]) {
        return @"团队卓越奖";
    }
    if ([key isEqualToString:@"Thanksgiving"]) {
        return @"感恩奖";
    }
    if ([key isEqualToString:@"AgentReceivePaymentCommission"]) {
        return @"代理收款佣金";
    }
    if ([key isEqualToString:@"AgentConsumptionCommission"]) {
        return @"代理还款佣金";
    }
    if ([key isEqualToString:@"SameLevelCommission"]) {
        return @"平级分润";
    }
    if ([key isEqualToString:@"Coupon"]) {
        return @"红包";
    }
    if ([key isEqualToString:@"Withdraw"]) {
        return @"提现";
    }
    if ([key isEqualToString:@"RepaymentSurplusFee"]) {
        return @"还款剩余手续费";
    }
    return @"";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
