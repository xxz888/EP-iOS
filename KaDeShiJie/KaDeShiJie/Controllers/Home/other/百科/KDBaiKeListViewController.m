//
//  KDBaiKeListViewController.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/10.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDBaiKeListViewController.h"
#import "KDJFOrderTableViewCellTableViewCell.h"
#import "KDJFOrderDetailViewController.h"
#import "KDHomeCardKnowledgeTableViewCell.h"
#import "KDHtmlWebViewController.h"
@interface KDBaiKeListViewController ()<QMUITableViewDataSource, QMUITableViewDelegate,MCSegementViewDelegate>
@property (nonatomic ,strong) NSMutableArray * cardEncyArray;
@property(nonatomic, strong) MCSegementView *segement;

@property(nonatomic, strong) NSString *orderState;
@end

@implementation KDBaiKeListViewController

- (NSMutableArray *)cardEncyArray
{
    if (!_cardEncyArray) {
        _cardEncyArray = [NSMutableArray array];
    }
    return _cardEncyArray;
}

- (MCSegementView *)segement {
    if (!_segement) {
        _segement = [[MCSegementView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, 45)];
        _segement.titles = @[@"用卡百科",@"推广经验",@"百科头条",@"产品知识"];
        _segement.delegate = self;
    }
    return _segement;
}
#pragma mark - MCSegementViewDelegate
- (void)segementViewDidSeletedIndex:(NSInteger)index buttonTitle:(NSString *)title {
    [self.cardEncyArray removeAllObjects];
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
        self.orderState = @"CardEncy";
    }else  if (index == 1) {
        self.orderState = @"PromoteExperience";
    }else  if (index == 2) {
        self.orderState = @"EncyHeadline";
    }else  if (index == 3) {
        self.orderState = @"ProductInfo";
    }
//    <el-option label="用卡百科" value="CardEncy"></el-option>
//             <el-option label="推广经验" value="PromoteExperience"></el-option>
//             <el-option label="百科头条" value="EncyHeadline"></el-option>
//             <el-option label="产品知识" value="ProductInfo"></el-option>
    
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
    [self setNavigationBarTitle:@"百科学院" tintColor:nil];
    [self.mc_tableview registerNib:[UINib nibWithNibName:@"KDHomeCardKnowledgeTableViewCell" bundle:nil] forCellReuseIdentifier:@"KDHomeCardKnowledgeTableViewCell"];
    [self.mc_tableview reloadData];
    self.orderState = @"CardEncy";
    [self requestData];
}
-(void)requestData{
    kWeakSelf(self);
    

    
    NSString * url1 = [NSString stringWithFormat:@"/api/v1/player/creditArticle/list?articleType=%@",self.orderState];
    [self.cardEncyArray removeAllObjects];
    [MCLATESTCONTROLLER.sessionManager mc_GET:url1 parameters:nil ok:^(NSDictionary * _Nonnull resp) {
        [weakself.cardEncyArray addObjectsFromArray:resp];
        [weakself.mc_tableview reloadData];
        [weakself.mc_tableview.mj_header endRefreshing];

    }];

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

-(void)layoutTableView{
    self.mc_tableview.frame = CGRectMake(0, NavigationContentTop+45, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop-45);
}
@end
