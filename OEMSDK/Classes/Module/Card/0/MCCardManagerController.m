//
//  MCCardManagerController.m
//  MCOEM
//
//  Created by wza on 2020/4/24.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCCardManagerController.h"
#import "MCBankCardCell.h"
#import "MCManualRealNameController.h"
#import "KDFillButton.h"

@interface MCCardManagerController ()<MCSegementViewDelegate, QMUITableViewDelegate, QMUITableViewDataSource,UINavigationControllerBackButtonHandlerProtocol>

@property(nonatomic, strong) MCSegementView *segView;
@property(nonatomic, strong) KDFillButton *addButton;

@property(nonatomic, strong) NSMutableArray<MCBankCardModel *> *daijikas;
@property(nonatomic, strong) NSMutableArray<MCBankCardModel *> *jiejikas;

@property(nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL loginVC;
@end

@implementation MCCardManagerController
- (NSMutableArray<MCBankCardModel *> *)daijikas {
    if (!_daijikas) {
        _daijikas = [NSMutableArray new];
    }
    return _daijikas;
}
- (NSMutableArray<MCBankCardModel *> *)jiejikas {
    if (!_jiejikas) {
        _jiejikas = [NSMutableArray new];
    }
    return _jiejikas;
}

- (KDFillButton *)addButton {
    if (!_addButton) {
        CGFloat height = 55*MCSCALE;
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-height, SCREEN_WIDTH, height)];
        [_addButton setBackgroundColor:[UIColor qmui_colorWithHexString:@"#F7874E"]];
        [_addButton setTitle:@"添加信用卡" forState:UIControlStateNormal];
        [_addButton setImage:[UIImage mc_imageNamed:@"one_bankcard_add"] forState:UIControlStateNormal];
        [_addButton setTitleColor:UIColorWhite forState:UIControlStateNormal];
        _addButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_addButton addTarget:self action:@selector(addButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        _addButton.titleLabel.font = UIFontBoldMake(18);
    }
    return _addButton;
}
- (MCSegementView *)segView {
    if (!_segView) {
        _segView = [[MCSegementView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, 45)];
        _segView.titles = @[@"信用卡", @"储蓄卡"];
        _segView.delegate = self;
        _segView.backgroundColor = self.mc_tableview.backgroundColor;
    }
    return _segView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.titleString isEqualToString:@"选择储蓄卡"]) {
        self.loginVC = YES;
        [self setNavigationBarTitle:self.titleString tintColor:nil];
        if ([self.titleString containsString:@"信用卡"]) {
            [self segementViewDidSeletedIndex:0 buttonTitle:@"信用卡"];
        } else {
            [self segementViewDidSeletedIndex:1 buttonTitle:@"储蓄卡"];
        }
    } else {
        
        self.segView.userInteractionEnabled = ![self.titleString isEqualToString:@"选择信用卡"];
        [self setNavigationBarTitle:@"我的银行卡" tintColor:nil];
        [self.view addSubview:self.segView];
    }
    [self.view addSubview:self.addButton];
    
    
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.mc_tableview.ly_emptyView = [MCEmptyView emptyViewText:self.currentIndex == 0 ? @"暂无可用储蓄卡" : @"暂无可用信用卡"];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestCards];
}
- (BOOL)shouldPopViewControllerByBackButtonOrPopGesture:(BOOL)byPopGesture{
    MCBankCardModel *model;
    if (self.currentIndex == 0 && self.daijikas.count == 1) {
        model = self.daijikas[0];
        [self.navigationController qmui_popViewControllerAnimated:YES completion:^{
            if (self.selectCardBlock) {
                self.selectCardBlock(model, self.currentIndex);
            }
        }];
        return NO;
    }else{
        return YES;
    }

}

- (void)layoutTableView {
    if ([self.titleString isEqualToString:@"选择储蓄卡"]) {
        self.mc_tableview.frame = CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-self.addButton.qmui_height - NavigationContentTop);
    } else {
        self.mc_tableview.frame = CGRectMake(0, NavigationContentTop+self.segView.qmui_height, SCREEN_WIDTH, SCREEN_HEIGHT-self.segView.qmui_bottom-self.addButton.qmui_height);
    }
}
- (void)mc_tableviewRefresh {
    [self.mc_tableview.mj_header endRefreshing];
}
#pragma mark - Actions
- (void)requestCards {
    __weak __typeof(self)weakSelf = self;
    NSString * url = self.currentIndex == 0 ? @"/api/v1/player/bank/credit":@"/api/v1/player/bank/debit";
    [self.sessionManager mc_GET:url parameters:nil ok:^(NSDictionary * _Nonnull resp) {
        NSArray *temArr = [MCBankCardModel mj_objectArrayWithKeyValuesArray:resp];
        [weakSelf.daijikas removeAllObjects];
        [weakSelf.jiejikas removeAllObjects];
        for (MCBankCardModel *model in temArr) {
            if (self.currentIndex == 1) {
                [weakSelf.jiejikas addObject:model];
            }
            if (self.currentIndex == 0) {
                [weakSelf.daijikas addObject:model];
            }
        }
        [weakSelf.mc_tableview reloadData];
    }];
}
- (void)addButtonTouched:(QMUIButton *)sender {
    [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
        if ([userInfo.certification integerValue] == 1) {
            MCBankCardType type = (self.currentIndex == 0)?MCBankCardTypeXinyongka:MCBankCardTypeChuxuka;
            [MCPagingStore pagingURL:rt_card_edit withUerinfo:@{@"type":@(type), @"isLogin":@(NO)}];
        }else{
            [MCToast showMessage:@"实名认证完成才可绑定卡片"];
            [MCLATESTCONTROLLER.navigationController pushViewController:[MCManualRealNameController new] animated:YES];
        }
    }];
   
}

#pragma mark - MCSegementViewDelegate

- (void)segementViewDidSeletedIndex:(NSInteger)index buttonTitle:(NSString *)title {
   
    [self.addButton setTitle:[NSString stringWithFormat:@"添加%@",title] forState:UIControlStateNormal];
    self.currentIndex= index;
    [self requestCards];
}
#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 185;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentIndex == 0) {
        return self.daijikas.count;
    } else {
        return self.jiejikas.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MCBankCardCell *cell = [MCBankCardCell cellForTableView:tableView];
    
    if (self.currentIndex == 0) {
        cell.model = self.daijikas[indexPath.row];
    } else {
        cell.model = self.jiejikas[indexPath.row];
    }
    __weak __typeof(self)weakSelf = self;
    cell.block = ^(MCBankCardCellActionType type, MCBankCardModel * _Nonnull model) {
        if (type == MCBankCardCellActionModify) {
            MCBankCardType cardType = (weakSelf.currentIndex == 0)?MCBankCardTypeXinyongka:MCBankCardTypeChuxuka;
            NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
            [info setObject:@(cardType) forKey:@"type"];
            if (model) {
                [info setObject:model forKey:@"model"];
            }
            [MCPagingStore pagingURL:rt_card_edit withUerinfo:info];
        } else {
//            [weakSelf requestCards];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCBankCardModel *model;
    if (self.currentIndex == 0) {
        model = self.daijikas[indexPath.row];
    } else {
        model = self.jiejikas[indexPath.row];
    }
    if (!self.selectCardBlock) {
        return;
    }
    [self.navigationController qmui_popViewControllerAnimated:YES completion:^{
        if (self.selectCardBlock) {
            self.selectCardBlock(model, self.currentIndex);
        }
        
    }];
}
@end
