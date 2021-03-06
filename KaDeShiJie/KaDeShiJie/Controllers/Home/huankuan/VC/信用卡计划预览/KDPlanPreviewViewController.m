//
//  KDPlanPreviewViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/23.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDPlanPreviewViewController.h"
#import "KDDirectRefundViewController.h"
#import "KDCommonAlert.h"
#import "KDDirectRefundModel.h"
#import "KDBingCardNewViewController.h"
#import "KDTrandingRecordViewController.h"
@interface KDPlanPreviewViewController ()<UITableViewDataSource, KDPlanPreviewViewDelegate, UITableViewDelegate>
@property (nonatomic, strong) NSString * getSmsUrl;
@property (nonatomic, strong) NSString * confirmSmsUrl;
@property (nonatomic, strong) NSString * channelTag;
@property (nonatomic, strong) NSString * smsCode;
@property (nonatomic, strong) MCBankCardModel * mcBankCardmodel;//储蓄卡的信息
@property (nonatomic, strong) QMUIModalPresentationViewController * presentAlert;
@property (nonatomic, strong) NSString * message;//


@end

@implementation KDPlanPreviewViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestPlanDetail];
}
#pragma mark -------------------------计划详情-------------------------
-(void)requestPlanDetail{
    kWeakSelf(self);
    
    NSString * url = [NSString stringWithFormat:@"%@%@",@"/api/v1/player/plan/",self.startDic[@"plan"][@"id"]];
    [[MCSessionManager shareManager] mc_GET:url parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
        NSDictionary * respDic = (NSDictionary *)resp;
        KDTotalAmountModel * amountModel = [[KDTotalAmountModel alloc]init];
        
        amountModel.taskCount = [respDic[@"totalRepaymentCount"] integerValue];          //还款总次数
        amountModel.repaymentedSuccessCount = [respDic[@"alreadyRepaymentCount"] integerValue]; //已还次数
//        amountModel.consumedAmount = [respDic[@"totalRepaymentAmount"] floatValue];      //还款总金额
        amountModel.taskAmount =  [respDic[@"totalRepaymentAmount"] floatValue];     //还款总金额
        amountModel.repaymentedAmount = [respDic[@"alreadyRepaymentAmount"] floatValue];//已还金额
        amountModel.totalServiceCharge = [respDic[@"totalFee"] floatValue]; //预计手续费
        amountModel.usedCharge = [respDic[@"alreadyFee"] floatValue];//已扣手续费
        
        weakself.detailModel = [KDRepaymentDetailModel mj_objectWithKeyValues:@{@"totalAmount":@[amountModel],@"totalOrder":respDic[@"tasks"]} ];
    

        //请求完数据，调用赋值的方法
        [weakself setDataWhere1];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.detailModel.totalOrder count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KDPlanPreviewViewCell *cell = [KDPlanPreviewViewCell cellWithTableView:tableView];
    cell.whereCome = self.whereCome;
    cell.balancePlanId = self.balancePlanId;
    cell.orderModel = self.detailModel.totalOrder[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //余额还款启动计划
    if (self.whereCome != 1) {
        KDConsumptionDetailView *detailView = [[KDConsumptionDetailView alloc] init];
        detailView.balancePlanId = self.balancePlanId;
        detailView.message = self.message;
        detailView.orderModel = self.detailModel.totalOrder[indexPath.row];
        [detailView showView];
    }
    
}
//-(void)checkBind{
//    __weak typeof(self) weakSelf = self;
//    NSString * url = [NSString stringWithFormat:@"/api/v1/player/channel/bind/check?channelId=%@&bankCardId=%@",self.startDic[@"plan"][@"channelId"],self.directRefundModel.id];
//    [[MCSessionManager shareManager] mc_GET:url parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
//
//        if ([resp[@"bind"] integerValue] == 0) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [MCToast showMessage:@"当前信用卡未绑定该通道,请先绑卡"];
//            });
//            KDBingCardNewViewController * vc = [[KDBingCardNewViewController alloc]init];
//            vc.cardModel = self.directRefundModel;
//
//
//            vc.channelId = self.startDic[@"plan"][@"channelId"];
//            [self.navigationController pushViewController:vc animated:YES];
//        }else{
//            [weakSelf startPlan];
//            //如果是鉴权过就开始执行计划
//            
//        }
//    }];
//}
-(void)startPlan{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString * url = [NSString stringWithFormat:@"%@%@",@"/api/v1/player/plan/start/",self.startDic[@"plan"][@"id"]];
    [self.sessionManager mc_put:url parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [MCToast showMessage:@"计划执行成功"];
        });
        
        [weakSelf.navigationController pushViewController:[KDDirectRefundViewController new] animated:YES];
    } other:^(NSDictionary * _Nonnull resp) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
-(void)stopPlan{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString * url = [NSString stringWithFormat:@"%@%@",@"/api/v1/player/plan/termination/",self.startDic[@"plan"][@"id"]];
    [self.sessionManager mc_put:url parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [MCToast showMessage:@"计划已终止"];
        });
        [weakSelf.navigationController pushViewController:[KDDirectRefundViewController new] animated:YES];
    } other:^(NSDictionary * _Nonnull resp) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
-(void)creditcardSaveTask{
    [self startPlan];
    return;
    
    
    
    
    
    
    
//
//
//
//    if (self.balancePlanId) {
//        [params setValue:SharedUserInfo.userid forKey:@"userId"];
//        [params setValue:self.repaymentModel.creditCardNumber forKey:@"creditCardNumber"];
//        [params setValue:self.city forKey:@"city"];
////        /api/v1/player/plan/start/{planId}
//        //如果是新的余额还款，需要先查询是否鉴权
//        [self.sessionManager mc_POST:@"/creditcardmanager/app/balance/verify/band/card" parameters:params ok:^(NSDictionary * _Nonnull resp) {
//            //然后再保存计划
//            [weakSelf.sessionManager mc_POST:@"/creditcardmanager/app/balance/plan/save" parameters:params ok:^(NSDictionary * _Nonnull resp) {
//                [MCLoading hidden];
//                //查询多通道
//                [weakSelf getAllXinYongKaList];
//            } other:^(NSDictionary * _Nonnull resp) {
//                [MCLoading hidden];
//            } failure:^(NSError * _Nonnull error) {
//                [MCLoading hidden];
//            }];
//        } other:^(NSDictionary * _Nonnull resp) {
//            [MCLoading hidden];
//            //如果需要鉴权
//            if ([resp[@"code"] isEqualToString:@"999992"]) {
//                MCBankCardModel * cardModel = [[MCBankCardModel alloc]init];
//                cardModel.cardNo = resp[@"result"][@"bankCard"];
//                cardModel.bankName = resp[@"result"][@"bankName"];
//                cardModel.channelTag = resp[@"result"][@"channelTag"];
//                cardModel.expiredTime = resp[@"result"][@"expiredTime"];
//                cardModel.idcard = resp[@"result"][@"idCard"];
//
//                cardModel.phone = resp[@"result"][@"phone"];
//                cardModel.securityCode = resp[@"result"][@"securityCode"];
//                cardModel.userName = resp[@"result"][@"userName"];
//                cardModel.rate = resp[@"result"][@"rate"];
//                cardModel.extraFee = resp[@"result"][@"extraFee"];
//
//                cardModel.dbankCard = resp[@"result"][@"dbankCard"];
//                cardModel.dbankName = resp[@"result"][@"dbankName"];
//                cardModel.dphone    = resp[@"result"][@"dphone"];
//
//                //拼凑的model
//                MCCustomModel * customModel = [[MCCustomModel alloc]init];
//                customModel.bindChannelName = resp[@"result"][@"channelTag"];
//                customModel.whereCome = yuehuankuan_jianquan;
//                customModel.smsApi = [resp[@"result"][@"ipAddress"] append:resp[@"result"][@"getSmsUrlNew"]];
//                customModel.api    = [resp[@"result"][@"ipAddress"] append:resp[@"result"][@"confirmSmsUrl"]];
//                customModel.             xinYongKa_Save_Parameters = [NSDictionary dictionaryWithDictionary:params];
//                [MCPagingStore pagingURL:rt_card_jianquan withUerinfo:@{@"param":cardModel,@"extend":customModel}];
//            }else{
//                [MCToast showMessage:resp[@"messege"]];
//            }
//        } failure:^(NSError * _Nonnull error) {
//
//        }];
//
//
//    }else{
//        [params setValue:self.taskJSON forKey:@"taskJSON"];              //生成任务返回的result
//        [params setValue:self.amount forKey:@"amount"];                  // 还款金额
//        [params setValue:self.reservedAmount forKey:@"reservedAmount"];  //预留金额
//        [params setValue:self.version forKey:@"version"];                //版本
//        [params setValue:self.city forKey:@"city"];
//        [params setValue:self.extra forKey:@"extra"];
//        [params setValue:self.repaymentModel.creditCardNumber forKey:@"creditCardNumber"];
//        //这两个参数可选
//        [params setValue:@"" forKey:@"isCustom"];       //可选
//        [params setValue:@"" forKey:@"couponId"];       // 优惠券ID
//
//
//        [self.sessionManager mc_POST:@"/creditcardmanager/app/save/all/task" parameters:params ok:^(NSDictionary * _Nonnull resp) {
//            [MCLoading hidden];
//            //查询多通道
//            [weakSelf getAllXinYongKaList];
//        } other:^(NSDictionary * _Nonnull resp) {
//            [MCLoading hidden];
//            //需要鉴权
//            if ([resp[@"code"] isEqualToString:@"999992"]) {
//                MCBankCardModel * cardModel = [[MCBankCardModel alloc]init];
//                cardModel.cardNo = resp[@"result"][@"bankCard"];
//                cardModel.bankName = resp[@"result"][@"bankName"];
//                cardModel.channelTag = resp[@"result"][@"channelTag"];
//                cardModel.expiredTime = resp[@"result"][@"expiredTime"];
//                cardModel.idcard = resp[@"result"][@"idCard"];
//
//                cardModel.phone = resp[@"result"][@"phone"];
//                cardModel.securityCode = resp[@"result"][@"securityCode"];
//                cardModel.userName = resp[@"result"][@"userName"];
//                cardModel.rate = resp[@"result"][@"rate"];
//                cardModel.extraFee = resp[@"result"][@"extraFee"];
//
//                cardModel.dbankCard = resp[@"result"][@"dbankCard"];
//                cardModel.dbankName = resp[@"result"][@"dbankName"];
//                cardModel.dphone    = resp[@"result"][@"dphone"];
//
//                //拼凑的model
//                MCCustomModel * customModel = [[MCCustomModel alloc]init];
//                customModel.bindChannelName = resp[@"result"][@"channelTag"];
//                customModel.whereCome = yuehuankuan_jianquan;
//                customModel.smsApi = [resp[@"result"][@"ipAddress"] append:resp[@"result"][@"getSmsUrlNew"]];
//                customModel.api    = [resp[@"result"][@"ipAddress"] append:resp[@"result"][@"confirmSmsUrl"]];
//                customModel.xinYongKa_Save_Parameters = [NSDictionary dictionaryWithDictionary:params];
//                [MCPagingStore pagingURL:rt_card_jianquan withUerinfo:@{@"param":cardModel,@"extend":customModel}];
//            }else{
//                [MCToast showMessage:resp[@"messege"]];
//            }
//        } failure:^(NSError * _Nonnull error) {
//            [MCLoading hidden];
//        }];
//    }

}
#pragma mark -------------------------底部按钮方法-------------------------
- (IBAction)clickBottomAction:(KDFillButton *)sender {
    kWeakSelf(self)
    //余额还款启动计划
    if ([sender.titleLabel.text isEqualToString:@"启动计划"]) {
        [self creditcardSaveTask];
    }
    if ([sender.titleLabel.text isEqualToString:@"结束还款"] || [sender.titleLabel.text isEqualToString:@"终止计划"]) {
    
            QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:nil message:@"是否结束本次信用卡还款计划？" preferredStyle:QMUIAlertControllerStyleAlert];
            [alert addAction:[QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
                [weakself stopPlan];
            }]];
        [alert addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        }]];
        [alert showWithAnimated:YES];
            
        
        
        
//        KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
//        [commonAlert initKDCommonAlertContent:@"是否结束本次信用卡还款计划？"  isShowClose:NO];
//        __weak __typeof(self)weakSelf = self;
//        commonAlert.rightActionBlock = ^{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                if (weakSelf.balancePlanId) {
//                    [weakSelf.sessionManager mc_POST:@"/creditcardmanager/app/balance/plan/stop" parameters:@{@"planId":self.balancePlanId} ok:^(NSDictionary * _Nonnull resp) {
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            [MCToast showMessage:resp[@"messege"]];
//                        });
//                        [weakSelf.navigationController popViewControllerAnimated:YES];
//                    }];
//
//                }else{
//                    NSMutableArray *arr = [NSMutableArray array];
//                    for (KDTotalOrderModel *orderModel in self.detailModel.totalOrder) {
//                        if (orderModel.taskStatus == 0) {
//                            [arr addObject:orderModel.taskId];
//                        }
//                    }
//                    NSString *repaymentTaskId = [arr componentsJoinedByString:@","];
//                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//                    [params setValue:repaymentTaskId forKey:@"repaymentTaskId"];
//                    [params setValue:@"1" forKey:@"isCloseAutoConsume"];
//                    [weakSelf.sessionManager mc_POST:@"/creditcardmanager/app/delete/repaymenttask/by/repaymenttaskid" parameters:params ok:^(NSDictionary * _Nonnull resp) {
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            [MCToast showMessage:resp[@"messege"]];
//                        });
//                        [weakSelf.navigationController popViewControllerAnimated:YES];
//                    }];
//                }
//            });
//        };
    }
}
#pragma mark - KDPlanPreviewViewDelegate
- (void)planPreviewViewWithType:(NSInteger)type{}

#pragma mark -------------------------where=1,下单进来直接带过来数据-------------------------
- (void)setDataWhere1{
    KDTotalAmountModel *amountModel = self.detailModel.totalAmount.firstObject;
    self.lab1.text = [NSString stringWithFormat:@"%ld次", amountModel.taskCount];
    self.lab2.text = [NSString stringWithFormat:@"%ld次", amountModel.repaymentedSuccessCount];
    self.lab3.text = [NSString stringWithFormat:@"%.3f元", amountModel.taskAmount];
    self.lab4.text = [NSString stringWithFormat:@"%.3f元", amountModel.repaymentedAmount];
    self.lab5.text = [NSString stringWithFormat:@"%.3f元", amountModel.totalServiceCharge];
    self.lab6.text = [NSString stringWithFormat:@"%.3f元", amountModel.usedCharge];
    //如果是下单进来，底部按钮就为终止计划按钮，次数颜色为红色
    if (self.whereCome == 1) {
        self.bottomBtn.hidden = NO;
        [self.bottomBtn setTitle:@"启动计划" forState:UIControlStateNormal];
        self.bottomHeight.constant = 50;
    }else{
   
        
    if ([self.startDic[@"planStatus"] isEqualToString:@"Padding"] ||
        [self.startDic[@"planStatus"] isEqualToString:@"Running"]) {
        self.bottomBtn.hidden = NO;
        [self.bottomBtn setTitle:@"终止计划" forState:UIControlStateNormal];
        self.bottomHeight.constant = 50;
    }else{
        self.bottomBtn.hidden = YES;
        [self.bottomBtn setTitle:@"终止计划" forState:UIControlStateNormal];
        self.bottomHeight.constant = 0;
    }
//        return;
//        if (self.balancePlanId) {
//            NSString * btnString = @"";
//            if (self.repaymentModel.status == 5) {
//                btnString = @"取消中";
//                self.bottomBtn.hidden = NO;
//                self.bottomBtn.userInteractionEnabled = NO;
//                [self.bottomBtn setupDisAppearance];
//            }else if (self.repaymentModel.status == 1 ||
//                      self.repaymentModel.status == 2 ||
//                      self.repaymentModel.status == 4 ||
//                      self.repaymentModel.status == 7){
//                btnString = @"终止计划";
//                self.bottomBtn.hidden = NO;
//                self.bottomBtn.userInteractionEnabled = YES;
//
//            }
//            [self.bottomBtn setTitle:btnString forState:UIControlStateNormal];
//            self.bottomHeight.constant = self.bottomBtn.hidden ? 0 : 50;
//
//        }else{
//            [self.bottomBtn setTitle:@"终止计划" forState:UIControlStateNormal];
//            self.bottomBtn.hidden = self.repaymentModel.taskStatus == 1 || self.repaymentModel.taskStatus == 4 || self.repaymentModel.taskStatus == 3;
//            self.bottomHeight.constant = self.bottomBtn.hidden ? 0 : 50;
//        }

    }
    [self.tableView reloadData];
    
    //获取信用卡的信息
//    [self getDirectCardData];
}


#pragma mark -----------------------多通道设置，获取所有信用卡信息---------------------
-(void)getAllXinYongKaList{
    kWeakSelf(self);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:SharedUserInfo.userid forKey:@"userId"];
    [[MCSessionManager manager] mc_POST:@"/creditcardmanager/app/get/creditcard/by/userid/new" parameters:params ok:^(NSDictionary * _Nonnull resp) {
        [MCLoading hidden];
            NSArray * directModelArray = [KDDirectRefundModel mj_objectArrayWithKeyValuesArray:resp[@"result"]];
            for (KDDirectRefundModel * model in directModelArray) {
                if ([model.cardNo isEqualToString:weakself.repaymentModel.creditCardNumber]) {
                    weakself.directRefundModel = model;
                    break;
                }
            }
            [weakself requestAllChuXuKaList];
    }];
}
#pragma mark -----------------------多通道设置，获取所有储蓄卡信息---------------------
- (void)requestAllChuXuKaList {
    kWeakSelf(self);
    [self.sessionManager mc_GET:[NSString stringWithFormat:@"/user/app/bank/query/userid/%@",TOKEN] parameters:nil ok:^(NSDictionary * _Nonnull resp) {
        NSArray *temArr = [MCBankCardModel mj_objectArrayWithKeyValuesArray:resp[@"result"]];
        for (MCBankCardModel *model in temArr) {
            if ([model.nature containsString:@"借"]) {
                if (model.idDef) {
                    weakself.mcBankCardmodel = model;
                    break;
                }
            }
        }
        [weakself isChannelBind];
    }];
}
#pragma mark -----------------------多通道设置，查询是否有可绑定的通道---------------------
-(void)isChannelBind{
    if (self.directRefundModel && self.mcBankCardmodel) {
        NSDictionary * dic = @{
                               @"bankCard":self.directRefundModel.cardNo,
                               @"idCard":SharedUserInfo.idcard,
                               @"phone":self.directRefundModel.phone,
                               @"userName":self.directRefundModel.userName,
                               @"bankName":self.directRefundModel.bankName,
                               @"expiredTime":self.directRefundModel.expiredTime,
                               @"securityCode":self.directRefundModel.securityCode,
                               
                               @"dbankCard":self.mcBankCardmodel.cardNo,
                               @"dphone":self.mcBankCardmodel.phone,
                               @"dbankName":self.mcBankCardmodel.bankName,
                               
                               @"userId":SharedUserInfo.userid,
                               @"loginPhone":SharedUserInfo.phone
                            };
        kWeakSelf(self);
        [self.sessionManager mc_POST:@"/paymentgateway/isChannelBind" parameters:dic ok:^(NSDictionary * _Nonnull resp) {
            //查询是否有多通道
            if (resp[@"result"] && [resp[@"result"] allKeys] != 0) {
                weakself.getSmsUrl = resp[@"result"][@"getSmsUrl"];
                weakself.confirmSmsUrl = resp[@"result"][@"confirmSmsUrl"];
                weakself.channelTag = resp[@"result"][@"channelTag"];
                //如果下单进来，就直接弹出
                if (weakself.whereCome == 1) {
                 
                }else{
                    UIBarButtonItem *rightItem = [UIBarButtonItem qmui_itemWithTitle:@"多通道设置" target:self action:@selector(channelAction:)];
                    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
                    weakself.navigationItem.rightBarButtonItem = rightItem;
                }
            }else{
                if (weakself.whereCome == 1) {
                    //如果绑定完所有卡，就跳转列表界面
                    [weakself jumpXinYongKaList:nil];
                }else{
                    weakself.navigationItem.rightBarButtonItem = nil;
                }
      
            }
        }other:^(NSDictionary * _Nonnull resp) {
         
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }

}

#pragma mark -----------------------多通道设置，公用参数方法---------------------
-(NSMutableDictionary *)getSameParamers{
    NSDictionary * dic = @{@"bankCard":self.directRefundModel.cardNo,
                           @"idCard":SharedUserInfo.idcard,
                           @"phone":self.directRefundModel.phone,
                           @"userName":self.directRefundModel.userName,
                           @"bankName":self.directRefundModel.bankName,
                           @"expiredTime":self.directRefundModel.expiredTime,
                           @"securityCode":self.directRefundModel.securityCode,
                           @"channelTag":self.channelTag,
                           @"userId":SharedUserInfo.userid,
                           };
    return [NSMutableDictionary dictionaryWithDictionary:dic];
}
#pragma mark -----------------------多通道设置，发送按钮方法---------------------
-(void)sendSms{
    kWeakSelf(self);
    if (self.getSmsUrl.length == 0) {
        [MCToast showMessage: @"此卡已绑定该通道"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //如果绑定完所有卡，就跳转列表界面
            [weakself jumpXinYongKaList:nil];
        });
        return;;
    }
    [self.sessionManager mc_POST:self.getSmsUrl parameters:[self getSameParamers] ok:^(NSDictionary * _Nonnull resp) {
        if ([resp[@"messege"] isEqualToString:@"绑卡成功"]) {
            [MCToast showMessage:@"此卡已绑定该通道"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weakself.whereCome == 1) {
                    //如果绑定完所有卡，就跳转列表界面
                    [weakself jumpXinYongKaList:nil];
                }else{
                   
                    [weakself.presentAlert hideWithAnimated:YES completion:nil];
                }

            });
        }
    }];
}


-(void)jumpXinYongKaList:(MCNetResponse *)resp{
    if (self.presentAlert ) {
        [self.presentAlert hideWithAnimated:YES completion:nil];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [MCToast showMessage:resp ? resp[@"messege"] : @"计划设置成功"];
    });
    KDDirectRefundViewController * directRefundVC = nil;
    for (UIViewController * vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[KDDirectRefundViewController class]]) {
            directRefundVC = (KDDirectRefundViewController *)vc;
        }
    }
    //返回
    if (directRefundVC) {
        [self.navigationController popToViewController:directRefundVC animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
#pragma mark - 获取银行卡数据
- (void)getDirectCardData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:SharedUserInfo.userid forKey:@"userId"];
    [self.sessionManager mc_POST:@"/creditcardmanager/app/get/creditcard/by/userid/new" parameters:params ok:^(NSDictionary * _Nonnull resp) {
        NSArray *dataArray = [KDDirectRefundModel mj_objectArrayWithKeyValuesArray:resp[@"result"]];
        for (KDDirectRefundModel *model in dataArray) {
            if ([model.cardNo isEqualToString:self.repaymentModel.creditCardNumber]) {
                self.desLabel.text = [NSString stringWithFormat:@"账单日 每月%ld日｜还款日 每月%ld日", model.billDay, model.repaymentDay];
            }
        }
    }];
}

-(void)setUI{
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,SCREEN_WIDTH - 20,90);
    gl.startPoint = CGPointMake(1, 0.5);
    gl.endPoint = CGPointMake(0, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:254/255.0 green:69/255.0 blue:87/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:253/255.0 green:109/255.0 blue:92/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    self.topView.layer.cornerRadius = 12;
    self.topView.layer.masksToBounds = YES;
    self.topView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08].CGColor;
    self.topView.layer.shadowOffset = CGSizeMake(0,2);
    self.topView.layer.shadowOpacity = 1;
    self.topView.layer.shadowRadius = 8;
    [self.topView.layer insertSublayer:gl atIndex:0];
    // 1 下单 2 历史记录 3 信用卡还款进来
    [self setNavigationBarTitle:self.whereCome == 1 ? @"设置还款计划" :
                                self.whereCome == 2 ? @"计划详情": @"计划详情" tintColor:nil];
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#f5f5f5"];
    self.topBgView.layer.cornerRadius = 12;
    self.bottomBtn.titleLabel.font = [UIFont qmui_systemFontOfSize:16 weight:QMUIFontWeightBold italic:NO];
    self.bottomBtn.layer.cornerRadius = 25;
    self.bottomBtn.layer.masksToBounds = YES;
    self.centerView.layer.cornerRadius = 12;
    
    
    
    MCBankCardInfo *info = [MCBankStore getBankCellInfoWithName:self.directRefundModel.bankName];
    self.iconView.image = info.logo;
    self.topView.backgroundColor = [info.cardCellBackgroundColor qmui_colorWithAlphaAddedToWhite:0.6];

    NSString *cardNo = [NSString stringWithFormat:@"(%@)", [self.directRefundModel.bankCardNo substringFromIndex:self.directRefundModel.bankCardNo.length - 4]];
    NSString *desStr = [NSString stringWithFormat:@"%@%@", self.directRefundModel.bankName, cardNo];
    NSRange range = [desStr rangeOfString:cardNo];
    NSMutableAttributedString *atts = [[NSMutableAttributedString alloc] initWithString:desStr];
    [atts addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range];
    self.nameLabel.attributedText = atts;
    
    self.desLabel.text = [NSString stringWithFormat:@"账单日 每月%@日｜还款日 每月%@日", self.directRefundModel.billingDate, self.directRefundModel.repaymentDate];
    //如果是下单进来，隐藏状态的label
    if (self.whereCome == 1) {
        self.statusLabelWidth.constant = 15;
        self.titleStatusLblTag.hidden =   YES;
    }else{
        self.statusLabelWidth.constant = 60;
        self.titleStatusLblTag.hidden =   NO;
    }
}
@end
