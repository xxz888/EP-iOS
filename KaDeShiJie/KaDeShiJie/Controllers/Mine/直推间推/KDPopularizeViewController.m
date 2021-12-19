//
//  KDPopularizeViewController.m
//  KaDeShiJie
//
//  Created by mac on 2021/12/18.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDPopularizeViewController.h"
#import "KDPPopularizeTableViewCell.h"

@interface KDPopularizeViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIButton *segmentBtn1;
@property (weak, nonatomic) IBOutlet UIButton *segmentBtn2;
@property (weak, nonatomic) IBOutlet UIView *segmentLine1;
@property (weak, nonatomic) IBOutlet UIView *segmentLine2;
@property (weak, nonatomic) IBOutlet UITableView *yyTableView;
@property(nonatomic,strong)NSMutableArray * normalDataArray;
@property(nonatomic,strong)NSMutableArray * diamondDataArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * phone;

@end

@implementation KDPopularizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.name = @"";
    self.phone= @"";
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F6F6F6"];
    [self setNavigationBarTitle:self.whereCome == 1 ? @"直推用户" : @"间推用户" tintColor:[UIColor whiteColor]];
    [self.yyTableView registerNib:[UINib nibWithNibName:@"KDPPopularizeTableViewCell" bundle:nil] forCellReuseIdentifier:@"KDPPopularizeTableViewCell"];
    self.normalDataArray = [[NSMutableArray alloc]init];
    self.diamondDataArray = [[NSMutableArray alloc]init];
    self.segmentBtn1.selected = YES;
    self.segmentBtn2.selected = NO;
    self.searchBar.delegate = self;
    self.segmentLine1.backgroundColor = MAINCOLOR;
    self.segmentLine2.backgroundColor = [UIColor clearColor];
    [self requestData];
}
-(void)requestData{
    __weak __typeof(self)weakSelf = self;
    NSString * url1 = self.whereCome == 1 ?   @"/api/v1/player/user/recommendation/direct" : @"/api/v1/player/user/recommendation/indirect";
    NSDictionary * dic = @{};
    if (self.name.length > 0) {
        dic = @{@"name":self.name};
    }
    if (self.phone.length > 0) {
        dic = @{@"phone":self.phone};

    }
    [self.sessionManager mc_GET:url1 parameters:dic ok:^(NSDictionary * _Nonnull resp) {
        [self.normalDataArray removeAllObjects];
        [self.diamondDataArray removeAllObjects];

        for (NSDictionary * dic in resp) {
            if ([dic[@"level"] isEqualToString:@"Normal"]) {
                [weakSelf.normalDataArray addObject:dic];
            }
            if ([dic[@"level"] isEqualToString:@"Diamond"]) {
                [weakSelf.diamondDataArray addObject:dic];
            }
        }

        [weakSelf.yyTableView reloadData];
    }];
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
    
    [self.yyTableView reloadData];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.segmentBtn1.selected ? [self.normalDataArray count] : [self.diamondDataArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KDPPopularizeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"KDPPopularizeTableViewCell" forIndexPath:indexPath];
    BOOL isNormal = self.segmentBtn1.selected;
    NSMutableArray * arr = isNormal ? self.normalDataArray : self.diamondDataArray ;
    NSDictionary * dic = arr[indexPath.row];
    cell.cellTime.text = dic[@"createdTime"];
    cell.cellPhone.text = dic[@"phone"];
    cell.cellStatus.text = [dic[@"certification"] boolValue] ? @"已认证" : @"未认证";
    
    cell.cellImv.image = isNormal ? [UIImage imageNamed:@"会员"]:[UIImage imageNamed:@"会员1"];
    cell.cellUserLlb.text = isNormal ? @"普通会员" : @"钻石会员";
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
