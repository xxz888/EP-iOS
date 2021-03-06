//
//  KDTrandingRecordViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/23.
//  Copyright © 2020 SS001. All rights reserved.
//
// 交易记录

#import "KDTrandingRecordViewController.h"
#import "KDTrandingRecordHeaderView.h"
#import "KDTrandingRecordViewCell.h"
#import "KDSlotCardHistoryModel.h"
#import "KDRepaymentModel.h"
#import "KDSlotCardHistoryViewCell.h"
#import "KDSlotCardOrderInfoViewController.h"
#import "KDPlanPreviewViewController.h"
#import "MCBankCardModel.h"
@interface KDTrandingRecordViewController ()<KDTrandingRecordHeaderViewDelegate, QMUITableViewDataSource, QMUITableViewDelegate>
@property (nonatomic, strong) KDTrandingRecordHeaderView *headerView;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;


@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *repaymentArray;
@end

@implementation KDTrandingRecordViewController

- (NSMutableArray *)repaymentArray
{
    if (!_repaymentArray) {
        _repaymentArray = [NSMutableArray array];
    }
    return _repaymentArray;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (KDTrandingRecordHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[KDTrandingRecordHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 202)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#f5f5f5"];
    
    self.year = [MCDateStore getYear];
    self.month = [MCDateStore getMonth];
    self.mc_tableview.tableHeaderView = self.headerView;
    self.mc_tableview.rowHeight = 130;
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.backgroundColor = [UIColor clearColor];
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mc_tableview.tableFooterView = [UIView new];
    self.mc_tableview.ly_emptyView = [MCEmptyView emptyView];

    self.mc_tableview.mj_header = nil;
    self.type = 1;
    
    [self customBackButton];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBarTitle:@"交易记录" tintColor:nil];


    [self getHistory];
}
// 自定义返回按钮
- (void)customBackButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage mc_imageNamed:@"nav_left_black"] forState:0];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(-8, 0, 22, 22);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
}
// 返回按钮按下
- (void)backBtnClicked:(UIButton *)sender{
    
        [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - KDTrandingRecordHeaderViewDelegate
- (void)headerViewDelegateWithTime:(NSString *)time
{
    self.year = [time substringWithRange:NSMakeRange(0, 4)];
    self.month = [time substringWithRange:NSMakeRange(4, 2)];
    
    [self getHistory];
}
- (void)headerViewDelegateWithType:(NSInteger)type
{
    self.type = type;
    [self getHistory];
}

#pragma mark - QMUITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 1) {
        return 110;
    } else {
        return 130;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == 1) {
        return self.dataArray.count;
    } else {
        return self.repaymentArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 1) {
        KDSlotCardHistoryViewCell *cell = [KDSlotCardHistoryViewCell cellWithTableView:tableView];
        NSDictionary * dic = self.dataArray[indexPath.row];
//        model.orderType = 1;

        cell.slotHistoryModel = self.dataArray[indexPath.row];

        return cell;
    } else {
        KDTrandingRecordViewCell *cell = [KDTrandingRecordViewCell cellWithTableView:tableView];
        NSDictionary * dic = self.repaymentArray[indexPath.row];
//        model.orderType = self.type;
        cell.startDic = dic;;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.type == 1) {
        KDSlotCardOrderInfoViewController *vc = [[KDSlotCardOrderInfoViewController alloc] init];
        vc.slotHistoryModel = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    //余额还款
    if (self.type == 2) {
//        KDRepaymentModel *repaymentModel = self.repaymentArray[indexPath.row];
//        //新的余额还款
//        KDPlanPreviewViewController *vc = [[KDPlanPreviewViewController alloc] init];
//        vc.repaymentModel = repaymentModel;
//        vc.orderType = self.type;
//        vc.isCanDelete = YES;
//        vc.whereCome = 2;// 1 下单 2 历史记录 3 信用卡还款进来
//        if (repaymentModel.balance) {
//            vc.balancePlanId = repaymentModel.itemId;
//        }
//        [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
        
        
        KDPlanPreviewViewController *vc = [[KDPlanPreviewViewController alloc] init];
        vc.directRefundModel  = [MCBankCardModel mj_objectArrayWithKeyValuesArray:@[self.repaymentArray[indexPath.row][@"creditCard"]]][0];
        vc.whereCome = 2;// 1 下单 2 历史记录 3 信用卡还款进来
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.repaymentArray[indexPath.row]];
//        NSDictionary * planDic = @[@"task":self.repaymentArray[indexPath.row][@"planId"]];
        [dic setValue:@{@"id":[NSString stringWithFormat:@"%@",self.repaymentArray[indexPath.row][@"planId"]]} forKey:@"plan"];
        vc.startDic = dic;
        [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
    }
    
    
    //空卡还款
    if (self.type == 3) {

        
    }
}

- (NSArray *)getMonthFirstAndLastDayWith:(NSString *)dateStr{
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *newDate=[format dateFromString:dateStr];
    double interval = 0;
    NSDate *firstDate = nil;
    NSDate *lastDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];

    BOOL OK = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:& firstDate interval:&interval forDate:newDate];
    
    if (OK) {
        lastDate = [firstDate dateByAddingTimeInterval:interval - 1];
    }else {
        return @[@"",@""];
    }

    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *firstString = [myDateFormatter stringFromDate: firstDate];
    NSString *lastString = [myDateFormatter stringFromDate: lastDate];
    return @[firstString, lastString];
}

#pragma mark - 数据请求
- (void)getHistory
{
    [self.dataArray removeAllObjects];
    [self.repaymentArray removeAllObjects];
    [self.mc_tableview reloadData];
//    /api/v1/player/plan/order
    kWeakSelf(self);
    self.startDate = [NSString stringWithFormat:@"%@-%@-%@",self.year,self.month,@"01"];
    self.endDate = [self getMonthFirstAndLastDayWith:self.startDate][1];

    //刷卡
    NSString * url = @"";
    if (self.type == 1) {
        url = [NSString stringWithFormat:@"/api/v1/player/order?current=%@&size=%@&startDate=%@&endDate=%@",@"0",@"50",self.startDate,self.endDate];
        
    }
    if (self.type == 2) {
        url = [NSString stringWithFormat:@"/api/v1/player/plan/order?current=%@&size=%@&startDate=%@&endDate=%@",@"0",@"50",self.startDate,self.endDate];
    }
    [self.sessionManager mc_GET:url parameters:@{} ok:^(NSDictionary * _Nonnull respDic) {
        [weakself.mc_tableview.mj_header endRefreshing];
        if ([respDic[@"data"] count] == 0) {
     
        }else{
            if (weakself.type == 1) {
                weakself.dataArray = [KDSlotCardHistoryModel mj_objectArrayWithKeyValuesArray:respDic[@"data"]];

            }else if (weakself.type == 2){
                [weakself.repaymentArray addObjectsFromArray:respDic[@"data"]];
            }

           [weakself.mc_tableview reloadData];
        }
    }] ;
    
//
//    if (self.type == 1) {
//        [self.sessionManager mc_POST:@"/api/v1/player/order" parameters:params ok:^(NSDictionary * _Nonnull resp) {
//            self.dataArray = [KDSlotCardHistoryModel mj_objectArrayWithKeyValuesArray:resp[@"result"][@"content"]];
//            [self.mc_tableview reloadData];
//        }];
//    }else{
//
//        NSMutableDictionary * kongkaParams = [NSMutableDictionary dictionary];
//        [kongkaParams setValue:@"0" forKey:@"page"];
//        [kongkaParams setValue:@"100" forKey:@"size"];
//        [kongkaParams setValue:SharedUserInfo.userid forKey:@"userId"];
//        NSString * minDateTime = [NSString stringWithFormat:@"%@-%@-01 00:00:00",self.year,self.month];
//        [kongkaParams setValue:minDateTime forKey:@"minDateTime"];
//        [kongkaParams setValue:[self getMaxDateTime] forKey:@"maxDateTime"];
//        //余额还款和刷卡
//
//
//
//        __weak __typeof(self)weakself = self;
//        NSString * url1 = @"/api/v1/player/plan";
//        [self.sessionManager mc_GET:url1 parameters:nil ok:^(NSDictionary * _Nonnull resp) {
//            self.repaymentArray = [NSArray arrayWithArray:resp];
//            [self.mc_tableview reloadData];
//        }];
//
//
        
        
//        NSString * url = self.type == 2 ? @"/creditcardmanager/app/balance/plan/list" : @"/creditcardmanager/app/empty/card/plan/list";
//        [self.sessionManager mc_Post_QingQiuTi:url parameters:kongkaParams ok:^(NSDictionary * _Nonnull resp) {
//            NSMutableArray * newArray = [[NSMutableArray alloc]initWithArray:resp[@"result"][@"content"]];
//            //如果是type=2是余额还款，要兼容老的，所以要再请求一下老的,拼接在一起
//            if (weakself.type == 2) {
//                [params setValue:@(self.type) forKey:@"orderType"];
//                [weakself.sessionManager mc_POST:@"/creditcardmanager/app/add/queryrepayment/make/informationn" parameters:params ok:^(NSDictionary * _Nonnull resp) {
//
//                    if ([resp[@"result"][@"content"] count] > 0) {
//                        [newArray addObjectsFromArray:resp[@"result"][@"content"]];
//                    }
//                    weakself.repaymentArray = [KDRepaymentModel mj_objectArrayWithKeyValuesArray:newArray];
//                    [weakself.mc_tableview reloadData];
//                }];
//
//            }else{
//                weakself.repaymentArray = [KDRepaymentModel mj_objectArrayWithKeyValuesArray:resp[@"result"][@"content"]];
//                [weakself.mc_tableview reloadData];
//            }
//
//        } other:^(NSDictionary * _Nonnull resp) {
//            [MCLoading hidden];
//        } failure:^(NSError * _Nonnull error) {
//            [MCLoading hidden];
//        }];
//    }
    
//    [self.mc_tableview.mj_header endRefreshing];
}

-(NSString *)getMaxDateTime{
    NSString * maxMonth = @"";
    NSString * maxYear = [MCDateStore getYear];
    //如果12月
    if ([self.month isEqualToString:@"12"]) {
        maxMonth = @"1";
        maxYear  = NSUIntegerToNSString([maxYear integerValue] + 1);
    }else{
        maxMonth = NSIntegerToNSString([self.month integerValue] + 1);
    }
    return [NSString stringWithFormat:@"%@-%@-01 00:00:00",maxYear,maxMonth];
}

@end
