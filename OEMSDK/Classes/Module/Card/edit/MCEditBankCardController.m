//
//  MCEditBankCardController.m
//  MCOEM
//
//  Created by wza on 2020/4/24.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCEditBankCardController.h"
#import "MCManualRealNameController.h"
#import "MCXinyongkaHeader.h"
#import "MCChuxukaHeader.h"
@interface MCEditBankCardController ()

@property(nonatomic, strong) MCBankCardModel *model;
@property(nonatomic, assign) MCBankCardType type;
@property (nonatomic ,strong)MCXinyongkaHeader *header;
@property (nonatomic ,strong) MCChuxukaHeader *chuxuheader;
@end

@implementation MCEditBankCardController

- (instancetype)initWithType:(MCBankCardType)type cardModel:(MCBankCardModel *)model {
    self = [super init];
    if (self) {
        self.type = type;
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == MCBankCardTypeXinyongka) {
        self.header = [MCXinyongkaHeader newFromNib];
        if (self.model) {
            self.header.model = self.model;
            [self setNavigationBarTitle:@"修改信用卡" tintColor:[UIColor whiteColor]];
        } else {
            [self setNavigationBarTitle:@"添加信用卡" tintColor:[UIColor whiteColor]];
        }
        self.mc_tableview.tableHeaderView = self.header;
    } else {
        self.chuxuheader = [MCChuxukaHeader newFromNib];
        self.chuxuheader.loginVC = self.loginVC;
        self.chuxuheader.whereCome = self.whereCome;
        if (self.model) {
            self.chuxuheader.model = self.model;
            [self setNavigationBarTitle:@"修改储蓄卡" tintColor:[UIColor whiteColor]];
        } else {
            [self setNavigationBarTitle:@"添加储蓄卡" tintColor:[UIColor whiteColor]];
            
            
//            UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [shareBtn setTitle:@"客服" forState:UIControlStateNormal];
//            [shareBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
//            [shareBtn addTarget:self action:@selector(clickRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
//            shareBtn.titleLabel.font = LYFont(14);
//            shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//            shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//
//
//            shareBtn.frame = CGRectMake(SCREEN_WIDTH - 70, StatusBarHeightConstant + 12, 70, 22);
//            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
        }
        self.mc_tableview.tableHeaderView = self.chuxuheader;
    }
    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    __weak typeof(self) weakSelf = self;
//    [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
//        if ([userInfo.certification integerValue] == 1) {
//            weakSelf.chuxuheader.shimingName = userInfo.name;
//            weakSelf.chuxuheader.shimingIdCard = userInfo.idCardNo;
//            weakSelf.chuxuheader.shimingPhone = userInfo.phone;
//            [weakSelf.chuxuheader setData];
//
//
//            weakSelf.header.shimingName = userInfo.name;
//            weakSelf.header.shimingIdCard = userInfo.idCardNo;
//            weakSelf.header.shimingPhone = userInfo.phone;
//            [weakSelf.header setData];
//        }else{
//            [MCToast showMessage:@"实名认证完成才可绑定卡片"];
//            [MCLATESTCONTROLLER.navigationController pushViewController:[MCManualRealNameController new] animated:YES];
//        }
//    }];
}

-(void)clickRightBtnAction{
[MCServiceStore pushMeiqiaVC];
}

@end
