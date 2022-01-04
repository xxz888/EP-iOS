//
//  KDPopularizeViewController.m
//  KaDeShiJie
//
//  Created by mac on 2021/12/18.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDPopularizeViewController.h"
#import "KDPPopularizeTableViewCell.h"
#import "KDDirectPushNoDataView.h"
@interface KDPopularizeViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIButton *segmentBtn1;
@property (weak, nonatomic) IBOutlet UIButton *segmentBtn2;
@property (weak, nonatomic) IBOutlet UIView *segmentLine1;
@property (weak, nonatomic) IBOutlet UIView *segmentLine2;
@property (weak, nonatomic) IBOutlet UITableView *yyTableView;
@property (nonatomic, strong) KDDirectPushNoDataView *directPushEmptyView;

@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,assign)NSInteger page;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * phone;

@end

@implementation KDPopularizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.name = @"";
    self.phone= @"";
    self.page = 0;
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F6F6F6"];
    [self setNavigationBarTitle:self.whereCome == 1 ? @"直推用户" : @"间推用户" tintColor:nil];
    [self.yyTableView registerNib:[UINib nibWithNibName:@"KDPPopularizeTableViewCell" bundle:nil] forCellReuseIdentifier:@"KDPPopularizeTableViewCell"];
    self.dataArray = [[NSMutableArray alloc]init];
    self.segmentBtn1.selected = YES;
    self.segmentBtn2.selected = NO;
    self.searchBar.delegate = self;
    self.segmentLine1.backgroundColor = MAINCOLOR;
    self.segmentLine2.backgroundColor = [UIColor clearColor];
    [self requestData];
    self.yyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 0;
        [self requestData];
    }];
    
    self.yyTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page += 1;
        [self requestData];
    }];}
-(void)requestData{
//    diamond=true
    __weak __typeof(self)weakSelf = self;
    NSString * url1 = self.whereCome == 1 ?   @"/api/v1/player/user/recommendation/direct" : @"/api/v1/player/user/recommendation/indirect";
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    if (self.name.length > 0) {
        [dic setValue:self.name forKey:@"name"];
    }
    if (self.phone.length > 0) {
        [dic setValue:self.phone forKey:@"phone"];
    }
    
    if (self.segmentBtn1.selected) {
        [dic setValue:@"Normal" forKey:@"level"];
    }
    if (self.segmentBtn2.selected) {
        [dic setValue:@"Diamond" forKey:@"level"];
    }
    
    [dic setValue:@(self.page) forKey:@"current"];
    [dic setValue:@"20" forKey:@"size"];
    [self.sessionManager mc_GET:url1 parameters:dic ok:^(NSDictionary * _Nonnull resp) {
        
        
        
        if ([weakSelf.yyTableView.mj_header isRefreshing]) {
            [weakSelf.yyTableView.mj_header endRefreshing];
        }
        if ([weakSelf.yyTableView.mj_footer isRefreshing]) {
            [weakSelf.yyTableView.mj_footer endRefreshing];
        }
        
        if (weakSelf.page == 0) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.dataArray addObjectsFromArray:resp[@"data"]];
            
            if ([weakSelf.dataArray count] == 0) {
                [weakSelf showNoDataView];
            }else{
                [weakSelf hideNoDataView];

            }
        }else{
            [weakSelf hideNoDataView];

            if ([weakSelf.dataArray count] == [resp[@"count"] integerValue]) {
                [MCToast showMessage:@"已加载全部"];
                return;
            }else{
                [weakSelf.dataArray addObjectsFromArray:resp[@"data"]];
            }
        }
       
        
        [weakSelf.yyTableView reloadData];
    }];
}
- (void)showNoDataView
{
    self.yyTableView.hidden = YES;
    [self.view addSubview:self.directPushEmptyView];
}
- (void)hideNoDataView
{
    [_directPushEmptyView removeFromSuperview];
    _directPushEmptyView = nil;
    self.yyTableView.hidden = NO;
}
- (KDDirectPushNoDataView *)directPushEmptyView
{
    if (!_directPushEmptyView) {
        _directPushEmptyView = [[KDDirectPushNoDataView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - 242) * 0.5, SCREEN_WIDTH, 242)];
    }
    return _directPushEmptyView;
}
- (IBAction)segmentAction:(UIButton *)selectBtn{
    

    if (self.segmentBtn1 == selectBtn) {
        self.segmentBtn1.selected = YES;
        self.segmentBtn2.selected = NO;

        self.segmentLine1.backgroundColor = MAINCOLOR;
        self.segmentLine2.backgroundColor = [UIColor clearColor];
   

    }else{
        self.segmentBtn2.selected = YES;
        self.segmentBtn1.selected = NO;
    
        self.segmentLine2.backgroundColor = MAINCOLOR;
        self.segmentLine1.backgroundColor = [UIColor clearColor];
    }
    self.page = 0;
    
    [self.dataArray removeAllObjects];

    [self requestData];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KDPPopularizeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"KDPPopularizeTableViewCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataArray[indexPath.row];
    cell.cellTime.text = dic[@"createdTime"];
    cell.cellPhone.text = dic[@"phone"];
//    cell.cellStatus.text = [dic[@"certification"] integerValue] == 1 ? @"已认证" : @"未认证";

    cell.cellStatus.text = dic[@"name"] ;
    BOOL isNormal = [dic[@"level"] isEqualToString:@"Normal"];
//    cell.cellImv.image = isNormal ? [UIImage imageNamed:@"会员"]:[UIImage imageNamed:@"会员1"];
    [cell.cellImv sd_setImageWithURL:dic[@"headImg"] placeholderImage: [UIImage imageNamed:@"tuiguangmoren"]];
    if (isNormal) {
        cell.cellUserLlb.text = [dic[@"certification"] integerValue] == 0 ? @"未实名" : @"已实名";
    }else{
        cell.cellUserLlb.text =  @"VIP会员";
    }
    cell.cellRenSheng.hidden = [dic[@"certification"] integerValue] == 0;
    if ([dic[@"level"] isEqualToString:@"Diamond"]) {
        cell.cellUserLlb.text = @"VIP会员";
    }
    if ([dic[@"level"] containsString:@"1"]) {
        cell.cellUserLlb.text = @"一星";
    }
    if ([dic[@"level"] containsString:@"2"]) {
        cell.cellUserLlb.text = @"二星";
    }
    if ([dic[@"level"] containsString:@"3"]) {
        cell.cellUserLlb.text = @"三星";
    }
    if ([dic[@"level"] containsString:@"4"]) {
        cell.cellUserLlb.text = @"四星";
    }
    if ([dic[@"level"] containsString:@"5"]) {
        cell.cellUserLlb.text = @"五星";
    }
    if ([dic[@"level"] containsString:@"6"]) {
        cell.cellUserLlb.text = @"六星";
    }
    if ([dic[@"level"] containsString:@"7"]) {
        cell.cellUserLlb.text = @"七星";
    }
    if ([dic[@"level"] containsString:@"8"]) {
        cell.cellUserLlb.text = @"八星";
    }
    if ([dic[@"level"] containsString:@"9"]) {
        cell.cellUserLlb.text = @"九星";
    }
    cell.cellUserLlb.backgroundColor = isNormal ? [UIColor qmui_colorWithHexString:@"#F9AD42"] : [UIColor qmui_colorWithHexString:@"#333333"];
    return cell;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length == 11) {
        self.name = @"";
        self.phone = searchBar.text;
    }else{
        self.phone = @"";
        self.name = searchBar.text;
    }
    [self requestData];

}


@end
