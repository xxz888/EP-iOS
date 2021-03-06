//
//  KDNewsViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/5.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDNewsViewController.h"
#import "KDNewsViewCell.h"

@interface KDNewsViewController ()<QMUITableViewDelegate, QMUITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation KDNewsViewController

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:@"行业资讯" tintColor:nil];
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.rowHeight = 300;
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mc_tableview.mj_header = nil;
    [self getData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDNewsViewCell *cell = [KDNewsViewCell cellWithTableView:tableView];
    MCNewsModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MCNewsModel *model = self.dataArray[indexPath.row];
    if (model.title.length != 0) {
        [MCPagingStore pushWebWithTitle:model.title classification:@"资讯"];
    }
}
- (void)getData {
    /*
     title = 我是标题,
     content = 我是内容,
     cover = cover,
     describe = 我是描述**/
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_GET:@"/api/v1/player/promote/news" parameters:@{} ok:^(NSDictionary * _Nonnull respDic) {
        weakSelf.dataArray = [MCNewsModel mj_objectArrayWithKeyValuesArray:respDic];
        [weakSelf.mc_tableview reloadData];
        
    }];
    
//    NSDictionary *param = @{@"brandId":SharedConfig.brand_id,@"size":@"999",@"classifiCation":@"资讯"};
//    __weak __typeof(self)weakSelf = self;
//    [self.sessionManager mc_POST:@"/user/app/news/getnewsby/brandidandclassification/andpage" parameters:param ok:^(NSDictionary * _Nonnull resp) {
//        weakSelf.dataArray = [MCNewsModel mj_objectArrayWithKeyValuesArray:resp[@"result"][@"content"]];
//        [weakSelf.mc_tableview reloadData];
//    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
}
@end
