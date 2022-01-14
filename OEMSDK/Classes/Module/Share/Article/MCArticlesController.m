//
//  MCArticlesController.m
//  MCOEM
//
//  Created by wza on 2020/5/12.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCArticlesController.h"
#import "MCArticleModel.h"
#import "MCArticlesCell.h"

@interface MCArticlesController ()<QMUITableViewDelegate, QMUITableViewDataSource>
@property(nonatomic, copy) NSMutableArray<MCArticleModel *> *dataSource;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger qrCode1Count;
@property (nonatomic ,strong)NSMutableArray * arrayNew ;
@property (nonatomic ,strong)NSMutableArray * arrayNew0 ;

@end

@implementation MCArticlesController

- (NSMutableArray<MCArticleModel *> *)dataSource { 
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"分享素材" tintColor:nil];
    self.arrayNew = [[NSMutableArray alloc]init];
    self.arrayNew0 = [[NSMutableArray alloc]init];

    
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.ly_emptyView = [MCEmptyView emptyView];
    self.mc_tableview.separatorInset = UIEdgeInsetsZero;
    
    self.mc_tableview.mj_header = nil;
    self.page = 0;
    __weak __typeof(self)weakSelf = self;
//    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.page = 0;
//        [weakSelf requestData:YES];
//    }];
//    self.mc_tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        weakSelf.page += 1;
//        [weakSelf requestData:NO];
//    }];
    [self requestData:YES];
    
    [self setupHeader];;
    
}

- (void)setupHeader {
    UIView *hv = [[UIView alloc] init];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    line1.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    [hv addSubview:line1];
    
    
    
    QMUILabel *headLab = [[QMUILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 20)];
    headLab.font = UIFontMake(13);
    headLab.textColor = [UIColor qmui_colorWithHexString:@"#666666"];
    headLab.text = @"图片中的二维码都是您本人的专属二维码，保存图片，复制文字即可分享至朋友圈，坚持每天分享朋友圈素材，有利于快速吸引潜在用户。";
    headLab.contentEdgeInsets = UIEdgeInsetsMake(9, 11, 9, 11);
    headLab.qmui_lineHeight = 20;
    headLab.numberOfLines = 0;
    headLab.backgroundColor = UIColor.whiteColor;
    [headLab sizeToFit];
    [hv addSubview:headLab];
    
    
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, headLab.bottom, SCREEN_WIDTH, 10)];
    line2.backgroundColor = line1.backgroundColor;
    [hv addSubview:line2];
    hv.frame = CGRectMake(0, 0, SCREEN_WIDTH, headLab.height+20);
    
//    self.mc_tableview.tableHeaderView = hv;
    self.mc_tableview.rowHeight = UITableViewAutomaticDimension;
    
//    self.mc_tableview.qmui_cacheCellHeightByKeyAutomatically = YES;
}

- (void)requestData:(BOOL)cleanData {
    __weak __typeof(self)weakSelf = self;

    [self.sessionManager mc_GET:@"/api/v1/player/promote/materials" parameters:@{} ok:^(NSDictionary * _Nonnull respDic) {
        weakSelf.qrCode1Count = 0;
        for (NSDictionary * dic in respDic) {
            if ([dic[@"qrCode"] integerValue] == 1) {
                weakSelf.qrCode1Count += 1;
            }
        }
        
        
        
        NSMutableArray * respArr = [[NSMutableArray alloc]initWithArray:respDic];
        NSMutableArray * arr = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i < [respArr count]; i++) {
            NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithDictionary:respArr[i]];
            [dic setValue:@(i) forKey:@"cid"];
          
            
            if ([dic[@"qrCode"] integerValue] == 0) {
                [weakSelf.arrayNew0 addObject:dic];
            }
            if ([dic[@"qrCode"] integerValue] == 1) {
                [arr addObject:dic];
            }
        }
        
        
        if ([arr count] == 0) {
            [weakSelf.dataSource addObjectsFromArray:[MCArticleModel mj_objectArrayWithKeyValuesArray:respArr]];
            [weakSelf.mc_tableview reloadData];
            if ([weakSelf.mc_tableview.mj_header isRefreshing]) {
                [weakSelf.mc_tableview.mj_header endRefreshing];
            }
            if ([weakSelf.mc_tableview.mj_footer isRefreshing]) {
                [weakSelf.mc_tableview.mj_footer endRefreshing];
            }
        }else{
            [weakSelf jisuanData1:arr];
        }
        
     
    } other:^(NSDictionary * _Nonnull respDic) { }];

}
-(void)jisuanData1:(id)respDic{
    for (NSDictionary * dic in respDic) {
        if ([dic[@"qrCode"] integerValue] == 1) {
            [self jisuanData2:dic];
        }
        
       
    }


    
    
}
-(void)jisuanData2:(id)dic{

    __weak typeof(self) weakSelf = self;
    [[MCSessionManager shareManager] mc_Post_QingQiuTi:@"/api/v1/player/user/mere/images" parameters:@{@"imagePaths":dic[@"images"]} ok:^(NSDictionary * _Nonnull resp) {
        
        NSMutableDictionary * dicNew = [[NSMutableDictionary alloc]init];
        [dicNew setValue:dic[@"content"] forKey:@"content"];
        [dicNew setValue:dic[@"qrCode"] forKey:@"qrCode"];
        [dicNew setValue:resp[@"baseImages"] forKey:@"images"];
        [dicNew setValue:dic[@"cid"] forKey:@"cid"];

        [weakSelf.arrayNew addObject:dicNew];
        
        
        if ([weakSelf.arrayNew count] == weakSelf.qrCode1Count) {
            NSLog(@"arrayNew=%ld||qrCode1Count=%ld",[self.arrayNew count],self.qrCode1Count);
            
        
            
            
            [weakSelf.arrayNew addObjectsFromArray:self.arrayNew0];
            NSArray * narr = [weakSelf sortArray:weakSelf.arrayNew];
            NSArray *arr = [MCArticleModel mj_objectArrayWithKeyValuesArray:narr];
            [weakSelf.dataSource addObjectsFromArray:arr];
            [weakSelf.mc_tableview reloadData];
            if ([weakSelf.mc_tableview.mj_header isRefreshing]) {
                [weakSelf.mc_tableview.mj_header endRefreshing];
            }
            if ([weakSelf.mc_tableview.mj_footer isRefreshing]) {
                [weakSelf.mc_tableview.mj_footer endRefreshing];
            }
        }
    
    } other:^(NSDictionary * _Nonnull resp) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
    

}
- (NSArray *)sortArray:(NSArray *)array{

    NSArray *sortDesc = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"cid" ascending:YES]];

    NSArray *sortedArr = [array sortedArrayUsingDescriptors:sortDesc];

    return sortedArr;

}
#pragma mark - Tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MCArticlesCell cellWithTableview:tableView articleModel:self.dataSource[indexPath.row]];
}
//- (id<NSCopying>)qmui_tableView:(UITableView *)tableView cacheKeyForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [NSString stringWithFormat:@"%d",indexPath.row];
//}

@end
