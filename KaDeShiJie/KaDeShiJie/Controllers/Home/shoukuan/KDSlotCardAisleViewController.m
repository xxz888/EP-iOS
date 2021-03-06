//
//  KDSlotCardAisleViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDSlotCardAisleViewController.h"
#import "KDSlotCardAisleHeaderView.h"
#import "KDSlotCardAisleViewCell.h"
#import "KDPayGatherViewController.h"
#import "KDCommonAlert.h"
#import "MCCustomModel.h"
#import "KDBingCardNewViewController.h"
#import "KDPayNewViewController.h"
#import "KDSlotCardOrderInfoViewController.h"
@interface KDSlotCardAisleViewController ()<QMUITableViewDelegate, QMUITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, copy) NSString *orderCode;
@end

@implementation KDSlotCardAisleViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    kWeakSelf(self)

    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F5F5F5"];
    KDSlotCardAisleHeaderView *header = [[KDSlotCardAisleHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    header.moneyView.text = [NSString stringWithFormat:@"%@元", self.money];
    self.mc_tableview.tableHeaderView = header;
    self.mc_tableview.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        self.mc_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.mc_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self getData];
    self.mc_tableview.rowHeight = 115;
    self.mc_tableview.dataSource = self;
    self.mc_tableview.delegate = self;
    self.mc_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self setNavigationBarTitle:@"选择刷卡通道" tintColor:nil];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage mc_imageNamed:@"nav_left_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, StatusBarHeightConstant, 44, 44);
    [self.view addSubview:backBtn];
    
    
    
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setImage:[UIImage mc_imageNamed:@"nav_left_white"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.frame = CGRectMake(0, StatusBarHeightConstant, 44, 44);
//    [self.view addSubview:backBtn];
    

    [self setNavigationBarHidden];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, StatusBarHeightConstant, 150, 44)];
    titleLabel.text = @"选择刷卡通道";
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];

    
}
-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDSlotCardAisleViewCell *cell = [KDSlotCardAisleViewCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

       [self payAction:self.dataArray[indexPath.row] cardModel:self.xinyongInfo];
}

- (void)payAction:(MCChannelModel *)channelModel cardModel:(MCBankCardModel *)cardModel
{
    
    NSDictionary *params =
    @{
        @"creditCardId":self.xinyongInfo.id,
        @"debitCardId":self.chuxuInfo.id,
        @"amount":self.money,
        @"channelId":channelModel.channelId,
     };
    __weak typeof(self) weakSelf = self;
    [MCSessionManager.shareManager mc_Post_QingQiuTi:@"/api/v1/player/receivePayment/pre" parameters:params ok:^(NSDictionary * _Nonnull respDic) {
        KDPayNewViewController * vc = [[KDPayNewViewController alloc]init];
        vc.cardModel = cardModel;
        vc.cardchuxuModel = self.chuxuInfo;
        vc.channelId = channelModel.channelId;
        vc.amount = self.money;
        vc.whereCome = 1;
        //发短信
        if ([respDic[@"channelBind"][@"bindStep"] isEqualToString:@"Sms"] ) {
            vc.channelBindId = [NSString stringWithFormat:@"%@",respDic[@"channelBind"][@"id"]];
        }else{
            vc.orderId = [NSString stringWithFormat:@"%@",respDic[@"orderId"]];
        }


 
        [self.navigationController pushViewController:vc animated:YES];
     
    } other:^(NSDictionary * _Nonnull respDic) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
 
    
//    NSString * url = [NSString stringWithFormat:@"/api/v1/player/channel/bind/check?channelId=%@&bankCardId=%@",channelModel.channelId,self.xinyongInfo.id];
//    [[MCSessionManager shareManager] mc_GET:url parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
//
//        if ([resp[@"bind"] integerValue] == 0) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [MCToast showMessage:@"当前信用卡未绑定该通道,请先绑卡"];
//            });
//            KDBingCardNewViewController * vc = [[KDBingCardNewViewController alloc]init];
//            vc.cardModel = cardModel;
//            vc.cha = channelModel.channelId;
//            [self.navigationController pushViewController:vc animated:YES];
//        }else{
//
//            KDPayNewViewController * vc = [[KDPayNewViewController alloc]init];
//            vc.cardModel = cardModel;
//            vc.cardchuxuModel = self.chuxuInfo;
//            vc.channelId = channelModel.channelId;
//            vc.amount = weakSelf.money;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }];
//
//
//
//;
//    return;
//
//    NSString *phone = SharedUserInfo.phone;
//    NSString *order_desc = [NSString stringWithFormat:@"%@%@", channelModel.name,channelModel.channelParams];
//    NSString *channe_tag = [NSString stringWithFormat:@"%@", channelModel.channelTag];
//
//    NSDictionary *param = @{
//                            @"amount":self.money,
//                            @"orderDesc":order_desc,
//                            @"phone":phone,
//                            @"channeTag":channe_tag,
//                            @"brandId":SharedConfig.brand_id,
//                            @"userId":SharedUserInfo.userid,
//                            @"bankCard":cardModel.cardNo,
//                            @"creditBankName":cardModel.bankName};
    
//
  
//    [[MCSessionManager shareManager] mc_Post_QingQiuTi:@"/api/v1/player/receivePayment" parameters:@{
//        @"amount":@"",
//        @"channelPlatform":@"1",
//        @"creditCardId":self.xinyongInfo.id,
//        @"debitCardId":self.chuxuInfo.id,
//        @"deviceId":SharedDefaults.deviceid,
//        @"merchantId":@""
//
//
//    } ok:^(NSDictionary * _Nonnull resp) {
//        NSDictionary * dic  =(NSDictionary *)resp;
//        if ([dic[@"successful"] integerValue] == 1) {
//                        [MCToast showMessage:@"操作成功"];
//            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//        }
//    } other:^(NSDictionary * _Nonnull resp) {
//
//    } failure:^(NSError * _Nonnull error) {
//
//    }];
//
//
//    kWeakSelf(self);
//    [MCSessionManager.shareManager mc_POST:@"/facade/app/topup/new" parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
//        NSString * result = resp[@"result"];
//        [weakself.xinyongInfo setMoney:weakself.money];
//        //电银的通道
//        if ([channe_tag containsString:DYPay_QUICK]) {
//            NSString * orderCode = [result componentsSeparatedByString:@"orderCode="][1];
//            if ([[orderCode componentsSeparatedByString:@"&"] count] > 0) {
//                orderCode = [orderCode componentsSeparatedByString:@"&"][0];
//                [weakself.xinyongInfo setOrderCode:orderCode];
//                [weakself.xinyongInfo setJumpWhereVC:[resp[@"messege"] containsString:@"跳转交易页面"] ? @"2" : @"1"];
//                [MCPagingStore pagingURL:rt_card_add withUerinfo:@{@"param":weakself.xinyongInfo}];
//            }
//        //其它通道
//        }else{
//            //拼凑的model
//            MCCustomModel * customModel = [[MCCustomModel alloc]init];
//            [customModel setValue:result forKey:@"api"];    //短信的api
//            [customModel setValue:shoukuan_jianquan forKey:@"whereCome"];//收款界面
//            [customModel setValue:channe_tag forKey:@"bindChannelName"];//通道
//            //在判断是鉴权还是交易
//            [MCPagingStore pagingURL:[resp[@"messege"] containsString:@"跳转交易页面"] ? rt_card_jiaoyi : rt_card_jianquan  withUerinfo:@{@"param":weakself.xinyongInfo,@"extend":customModel}];
//        }
//    } other:^(NSDictionary * _Nonnull resp) {
//        [MCLoading hidden];
//        if ([resp[@"code"] isEqualToString:@"666666"]) {
//            if (resp[@"result"] && [resp[@"result"] isKindOfClass:[NSString class]] && [resp[@"result"] containsString:@"http"]) {  //花呗身份校验
//                [MCPagingStore pagingURL:rt_web_controller withUerinfo:@{@"url":resp[@"result"]}];
//            } else {
//                [MCToast showMessage:resp[@"result"]];
//            }
//        } else {
//            [MCToast showMessage:resp[@"messege"]];
//        }
//    }];
}
- (void)getData {
//    NSDictionary *param = @{@"userId":SharedUserInfo.userid,
//                            @"bankCard":self.xinyongInfo.cardNo,
//                            @"amount":self.money,
//                            @"brandId":BCFI.brand_id,
//                            @"recommend":@(2),
//                            @"status":@"1"
//                            };
    /*
     long userId,
     Integer brandId,
     String bankCard,
     String amount,
     String channelNo, //不传时默认为2，表示只查快捷通道
     String channelTag,//可以不传，传了只查一个通道
     String status //状态1：启用，0：未启用
     
     **/
    
    NSString * url2 = @"/api/v1/player/credit/channel";
    [self.sessionManager mc_GET:url2 parameters:@{
        @"amount":self.money,
        @"creditCardId":self.xinyongInfo.id,
        @"cityId":self.cityId
    } ok:^(NSDictionary * _Nonnull resp) {
        self.dataArray = [MCChannelModel mj_objectArrayWithKeyValuesArray:resp];
        [self.mc_tableview reloadData];
        [self.mc_tableview.mj_header endRefreshing];
    }];
    
    
    
//    [self.sessionManager mc_POST:@"/user/app/channel/getchannel/bybankcard/andamount" parameters:param ok:^(NSDictionary * _Nonnull resp) {
//        self.dataArray = [MCChannelModel mj_objectArrayWithKeyValuesArray:resp[@"result"]];
//        [self.mc_tableview reloadData];
//    }];
}
#pragma mark - WBQRCodeVCDelegate
- (void)scancodeViewControllerComplete:(NSString *)str {
//    if (!str || str.length < 1) {
//        return;
//    }
//
//    NSString *msg = [NSString stringWithFormat:@"您正在发起一笔%@元的收款，确定后将从对方支付宝账户自动扣款", self.money];
//    QMUIModalPresentationViewController * alert = [[QMUIModalPresentationViewController alloc]init];
//    KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
//    [commonAlert initKDCommonAlertTitle:@"温馨提示" content:msg leftBtnTitle:@"取消" rightBtnTitle:@"确定" ];
//    alert.contentView = commonAlert;
//    commonAlert.leftActionBlock = ^{
//        [alert hideWithAnimated:YES completion:nil];
//    };
//    commonAlert.rightActionBlock = ^{
//        NSDictionary *param = @{@"authCode":str,@"orderCode":self.orderCode};
//        [MCSessionManager.shareManager mc_POST:@"/facade/topup/yxhb/trade" parameters:param ok:^(NSDictionary * _Nonnull resp) {
//            if (resp[@"result"] && [resp[@"result"] isKindOfClass:[NSString class]] && [resp[@"result"] containsString:@"http"]) {
//                [MCPagingStore pagingURL:rt_web_controller withUerinfo:@{@"url":resp[@"result"]}];
//            }
//        }];
//    };
//    [alert showWithAnimated:YES completion:nil];
    
    
//    NSString *msg = [NSString stringWithFormat:@"您正在发起一笔%@元的收款，确定后将从对方支付宝账户自动扣款", self.money];
//    QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:QMUIAlertControllerStyleAlert];
//    [alert addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
//    [alert addAction:[QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
//
//        NSDictionary *param = @{@"authCode":str,@"orderCode":self.orderCode};
//        [MCSessionManager.shareManager mc_POST:@"/facade/topup/yxhb/trade" parameters:param ok:^(NSDictionary * _Nonnull resp) {
//            if (resp[@"result"] && [resp[@"result"] isKindOfClass:[NSString class]] && [resp[@"result"] containsString:@"http"]) {
//                [MCPagingStore pagingURL:rt_web_controller withUerinfo:@{@"url":resp[@"result"]}];
//            }
//        }];
//
//    }]];
//    [alert showWithAnimated:YES];
}

@end
