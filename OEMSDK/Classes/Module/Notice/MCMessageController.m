//
//  MCMessageController.m
//  MCOEM
//
//  Created by wza on 2020/4/30.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCMessageController.h"
#import "MCSegementView.h"
#import "MCMessageModel.h"
#import "MCMessageCell.h"

@interface MCMessageController () <MCSegementViewDelegate, QMUITableViewDataSource, QMUITableViewDelegate>

@property(nonatomic, strong) MCSegementView *segement;
@property(nonatomic, strong) QMUITableView *tableview;
@property(nonatomic, strong) NSMutableArray<MCMessageModel *> *dataSource;
@property(nonatomic, assign) int page;
@property(nonatomic, copy) NSString *type;

@end

@implementation MCMessageController
- (NSMutableArray<MCMessageModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource  =[NSMutableArray new];
    }
    return _dataSource;
}
- (QMUITableView *)tableview {
    if (!_tableview) {
        _tableview = [[QMUITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak __typeof(self)weakSelf = self;
        _tableview.mj_header = nil;
    
    }
    return _tableview;
}
- (MCSegementView *)segement {
    if (!_segement) {
        _segement = [[MCSegementView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, 45)];
        _segement.titles = @[@"个人消息",@"平台消息"];
        _segement.delegate = self;
    }
    return _segement;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"消息中心" tintColor:nil];
    self.page = 0;
    self.type = @"0";
//    [self.view addSubview:self.segement];
    [self.view addSubview:self.tableview];
    self.mc_tableview.hidden = YES;
    self.mc_tableview.mj_header = nil;

    [self requestPerson];
}

#pragma mark - Actions
- (void)requestPerson {
    __weak __typeof(self)weakSelf = self;
    [MCLATESTCONTROLLER.sessionManager mc_GET:@"/api/v1/player/notice" parameters:nil ok:^(NSDictionary * _Nonnull resp) {
        NSArray *tempA = [MCMessageModel mj_objectArrayWithKeyValuesArray:resp];
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.dataSource addObjectsFromArray:tempA];
        [weakSelf.tableview reloadData];
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
    }];
    
    
    
    return;
    NSDictionary *param = @{@"page":@(self.page),@"size":@"20"};
    [[MCSessionManager shareManager] mc_GET:[NSString stringWithFormat:@"/user/app/jpush/history/%@",TOKEN] parameters:param ok:^(NSDictionary * _Nonnull resp) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        if (weakSelf.page == 0) {
            [weakSelf.dataSource removeAllObjects];
        }
        NSArray *tempA = [MCMessageModel mj_objectArrayWithKeyValuesArray:resp[@"result"][@"content"]];
        [weakSelf.dataSource addObjectsFromArray:tempA];
        [weakSelf.tableview reloadData];
    } other:^(NSDictionary * _Nonnull resp) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [MCToast showMessage:resp[@"messege"]];
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [MCToast showMessage:error.localizedFailureReason];
    }];
}
- (void)requestPlatform {
    NSDictionary *param = @{@"page":@(self.page),@"size":@"20"};
    __weak __typeof(self)weakSelf = self;
    [[MCSessionManager shareManager] mc_GET:[NSString stringWithFormat:@"/user/app/jpush/history/brand/%@",TOKEN] parameters:param ok:^(NSDictionary * _Nonnull resp) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        if (weakSelf.page == 0) {
            [weakSelf.dataSource removeAllObjects];
        }
        NSArray *tempA = [MCMessageModel mj_objectArrayWithKeyValuesArray:resp[@"result"][@"content"]];
        [weakSelf.dataSource addObjectsFromArray:tempA];
        [weakSelf.tableview reloadData];
        
    } other:^(NSDictionary * _Nonnull resp) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [MCLoading hidden];
        [MCToast showMessage:resp[@"messege"]];
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [MCLoading hidden];
        [MCToast showMessage:error.localizedFailureReason];
    }];
}

#pragma mark - MCSegementViewDelegate
- (void)segementViewDidSeletedIndex:(NSInteger)index buttonTitle:(NSString *)title {
    self.page = 0;
    if (index == 0) {
        self.type = @"0";
        [self requestPerson];
    } else {
        self.type = @"1";
        [self requestPlatform];
    }
}

#pragma mark - Tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MCMessageCell cellWithTableview:tableView messageModel:self.dataSource[indexPath.row]];
}

@end
