//
//  KDJFOrderListViewController.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/10.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJFAdressListViewController.h"
#import "KDJFAdressListTableViewCell.h"
#import "KDJFAdressManagerViewController.h"
@interface KDJFAdressListViewController ()<QMUITableViewDataSource, QMUITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView * footView;

@end

@implementation KDJFAdressListViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self setNavigationBarTitle:@"收货地址" backgroundImage:[UIImage qmui_imageWithColor:UIColor.mainColor]];
    [self.view addSubview:self.footView];

    [self.mc_tableview reloadData];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];

}
- (void)layoutTableView
{
    self.mc_tableview.frame = CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop - 80 );
}
-(void)requestData{
    kWeakSelf(self);
    [[MCSessionManager shareManager] mc_GET:[NSString stringWithFormat:@"/api/v1/player/shop/address"] parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
        [weakself.dataArray removeAllObjects];
        [weakself.dataArray addObjectsFromArray:resp];
        [weakself.mc_tableview reloadData];
        
        [weakself.mc_tableview.mj_header endRefreshing];
    } other:^(NSDictionary * _Nonnull resp) {
        [MCLoading hidden];
    } failure:^(NSError * _Nonnull error) {
        [MCLoading hidden];
    }];
}
#pragma mark - QMUITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 110;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDJFAdressListTableViewCell *cell = [KDJFAdressListTableViewCell cellWithTableView:tableView];
    NSDictionary * dic = self.dataArray[indexPath.row];
    cell.startDic = dic;
    cell.cAdress.text = [NSString stringWithFormat:@"%@",dic[@"address"]];
    cell.cName.text = dic[@"receiptName"];

    
    cell.refreshUIBlock = ^{
        [self requestData];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataArray[indexPath.row];

    if (self.block) {
        self.block(dic);
    };
    
    [self.navigationController popViewControllerAnimated:YES];

}
-(UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 80 , KScreenWidth, 80)];
        _footView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 10 , KScreenWidth-20, 50);
        button.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [button setTitleColor:KWhiteColor forState:0];
        [button setBackgroundColor:UIColor.mainColor];
        [button setTitle:@"添加地址" forState:0];
        ViewRadius(button, 25);
        [_footView addSubview:button];
        
        [button addTarget:self action:@selector(addAdressAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _footView;
}
-(void)addAdressAction:(id)tap{
    KDJFAdressManagerViewController * vc = [[KDJFAdressManagerViewController alloc]init];
    vc.whereCome = YES;
    [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
}
@end
