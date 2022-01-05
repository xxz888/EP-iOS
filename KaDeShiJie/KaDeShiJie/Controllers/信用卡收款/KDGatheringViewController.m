//
//  KDGatheringViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDGatheringViewController.h"
#import "KDSlotCardAisleViewController.h"
#import "KDCommonAlert.h"
#import "BRAddressPickerView.h"
#import "KDBingCardNewViewController.h"
#import "KDSlotCardAisleViewController.h"
#import "KDPayNewViewControllerQuickPass.h"
#import "KDPayNewViewController.h"
#import "KDSlotCardOrderInfoViewController.h"
#import <JFTBindFace/JFTBindFace.h>

@interface KDGatheringViewController ()<UITextFieldDelegate,JFTBindFaceManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet QMUIButton *addCreditBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *addDepositBtn;
@property (weak, nonatomic) IBOutlet UIImageView *creditImg;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property (weak, nonatomic) IBOutlet UIImageView *depositImg;
@property (weak, nonatomic) IBOutlet UILabel *depositLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *gatherBtn;
@property (weak, nonatomic) IBOutlet UIView *keyboardView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardBottomCons;
@property (weak, nonatomic) IBOutlet UITextField *moneyView;
@property(nonatomic, strong) MCBankCardModel *xinyongInfo;
@property(nonatomic, strong) MCBankCardModel *chuxuInfo;
@property(nonatomic, strong) KDCommonAlert * commonAlert;
@property(nonatomic, strong) NSString * provinceId;
    @property(nonatomic, strong) NSString * cityId;
@property(nonatomic, strong) BRAddressPickerView *addressPicker;
@property(nonatomic, strong) NSString *orderId;


@property (weak, nonatomic) IBOutlet UILabel *selectAdressTag;
@property (weak, nonatomic) IBOutlet QMUIButton *selectAdress;

@end

@implementation KDGatheringViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardVCBack:) name:@"mcNotificationWebContainnerReset" object:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    self.moneyView.text = @"";
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    //显示光标，但隐藏键盘
//    [self.moneyView becomeFirstResponder];
//    self.moneyView.inputView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.moneyView.inputAccessoryView = [[UIView alloc] initWithFrame:CGRectZero];
//    [self.moneyView reloadInputViews];
//    UITextInputAssistantItem* item = [self.moneyView inputAssistantItem];
//    item.leadingBarButtonGroups = @[];
//    item.trailingBarButtonGroups = @[];
    self.cityId = @"-1";
//    self.moneyView.delegate = self;
    // 设置按钮显示
    self.addCreditBtn.imagePosition = QMUIButtonImagePositionRight;
    self.addDepositBtn.imagePosition = QMUIButtonImagePositionRight;
    self.gatherBtn.titleLabel.numberOfLines = 0;
    self.selectAdress.imagePosition = QMUIButtonImagePositionRight;

    // 设置topView
    self.topView.layer.cornerRadius = 17;
    self.topView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.09].CGColor;
    self.topView.layer.shadowOffset = CGSizeMake(0,2.5);
    self.topView.layer.shadowOpacity = 1;
    self.topView.layer.shadowRadius = 10;
    
//    [self setNavigationBarTitle:@"快速收款" backgroundImage:[UIImage qmui_imageWithColor:[UIColor qmui_colorWithHexString:@"#FF9F58"]]];

    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"使用说明" forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.titleLabel.font = LYFont(13);
    shareBtn.frame = CGRectMake(SCREEN_WIDTH - 70, StatusBarHeightConstant + 12, 70, 22);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];

    [self requestDefaultChuXuCards];


    if (self.whereCome == 1) {
        [self setNavigationBarTitle:@"快捷收款" tintColor:nil];
        self.selectAdress.hidden = self.selectAdressTag.hidden = NO;
    }
    if (self.whereCome == 2) {
        [self setNavigationBarTitle:@"小额闪付" tintColor:nil];
        self.selectAdress.hidden = self.selectAdressTag.hidden = YES;

    }
    if (self.whereCome == 3) {
        [self setNavigationBarTitle:@"刷脸付" tintColor:nil];
        self.selectAdress.hidden = self.selectAdressTag.hidden = YES;

    }
}

#pragma mark - 获取默认卡
- (void)requestDefaultChuXuCards {
    
    
    __weak __typeof(self)weakSelf = self;
    NSString * url1 = @"/api/v1/player/bank/credit";
    [self.sessionManager mc_GET:url1 parameters:nil ok:^(NSDictionary * _Nonnull resp) {
        NSArray *temArr = [MCBankCardModel mj_objectArrayWithKeyValuesArray:resp];
        if ([temArr count] != 0) {
        
            MCBankCardModel * model = temArr[0];
            weakSelf.xinyongInfo = model;
        }else{
            
        }
    }];
    
    NSString * url2 = @"/api/v1/player/bank/debit";
    [self.sessionManager mc_GET:url2 parameters:nil ok:^(NSDictionary * _Nonnull resp) {
        NSArray *temArr = [MCBankCardModel mj_objectArrayWithKeyValuesArray:resp];
        if ([temArr count] != 0) {
            MCBankCardModel * model = temArr[0];
            weakSelf.chuxuInfo = model;
        }else{
            
        }
    }];
    
    
    
//    __weak __typeof(self)weakSelf = self;
//    //默认储蓄卡
//    NSDictionary *p2 = @{@"userId":SharedUserInfo.userid,
//                         @"type":@"2",
//                         @"nature":@"2",
//                         @"isDefault":@"1"};
//    [MCLATESTCONTROLLER.sessionManager mc_POST:@"/user/app/bank/query/byuseridandtype/andnature" parameters:p2 ok:^(NSDictionary * _Nonnull resp) {
//        NSArray *temp = [MCBankCardModel mj_objectArrayWithKeyValuesArray:resp[@"result"]];
//        for (MCBankCardModel *model in temp) {
//            weakSelf.chuxuInfo = model;
//            break;
//        }
//        [weakSelf setChuxuInfo:weakSelf.chuxuInfo];
//        //绑定过储蓄卡的话，就看是否绑定过信用卡
//        [weakSelf requestDefaultXinYongCards];
//    } other:^(NSDictionary * _Nonnull resp) {
//        [MCLoading hidden];
//        if ([resp[@"code"] isEqualToString:@"666666"]) {
//            [weakSelf nocardAlertShowWithMessage:@"你还未添加到账提现卡(储蓄卡)，是否前往添加？" type:MCBankCardTypeChuxuka cardModel:nil];
//            [weakSelf showChuXuGuidePage];
//        } else {
//            [MCToast showMessage:resp[@"messege"]];
//        }
//    }];

}
//- (void)requestDefaultXinYongCards {
//    __weak __typeof(self)weakSelf = self;
//    //默认信用卡
//    NSDictionary *p1 = @{@"userId":SharedUserInfo.userid,
//                         @"type":@"0",
//                         @"nature":@"0",
//                         @"isDefault":@"1"};
//    [MCLATESTCONTROLLER.sessionManager mc_POST:@"/user/app/bank/query/byuseridandtype/andnature" parameters:p1 ok:^(NSDictionary * _Nonnull resp) {
//        NSArray *temp = [MCBankCardModel mj_objectArrayWithKeyValuesArray:resp[@"result"]];
//
//        for (MCBankCardModel *model in temp) {
//            if (!model.billDay || !model.repaymentDay) {
//                [weakSelf nocardAlertShowWithMessage:@"您的信用卡信息填写不完整，请补充完整" type:MCBankCardTypeXinyongka cardModel:model];
//            } else {
//                [weakSelf showGuidePage2];
//
//            }
//            weakSelf.xinyongInfo = model;
//
//            break;
//        }
//        [weakSelf setXinyongInfo:weakSelf.xinyongInfo];
//
//    } other:^(NSDictionary * _Nonnull resp) {
//        [MCLoading hidden];
//        if ([resp[@"code"] isEqualToString:@"666666"]) {
//            [weakSelf nocardAlertShowWithMessage:@"你还未添加收款充值卡(信用卡)，是否前往添加？" type:MCBankCardTypeXinyongka cardModel:nil];
//            weakSelf.xinyongInfo = nil;
//            [weakSelf showXinYongGuidePage];
//        } else {
//            [MCToast showMessage:resp[@"messege"]];
//        }
//    }];
//}
- (void)clickRightBtnAction{
    MCWebViewController *web = [[MCWebViewController alloc] init];
  web.urlString = SharedDefaults.configDic[@"config"][@"receivePaymentInstructionLink"];
  web.title = @"快速收款使用说明";
  [self.navigationController pushViewController:web animated:YES];
}
- (IBAction)hideKeyboard:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.keyboardBottomCons.constant = -self.keyboardView.ly_height;
    }];
}
- (IBAction)clickTextView:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.keyboardBottomCons.constant = 0;
    }];
}

- (IBAction)keyboardBtnAction:(UIButton *)sender {
    NSString *title = sender.titleLabel.text;
    NSString *moneyText = self.moneyView.text;
    if ([title isEqualToString:@"删除"]) {
        if (moneyText.length != 0) {
            self.moneyView.text = [moneyText substringToIndex:moneyText.length - 1];
        }
    } else {
        if ([moneyText rangeOfString:@"."].location != NSNotFound) { // 有小数
            if (moneyText.length >= 14 && sender.tag != 5011) {
                return;
            }
        } else { // 不含小数
            if (moneyText.length >= 11 && sender.tag != 5011) {
                return;
            }
        }
        // 判断小数
        if ([moneyText containsString:@"."] && sender.tag != 5011) {
            NSRange range = [moneyText rangeOfString:@"."];
            if ((moneyText.length-(range.location+1))==2) {
                return;
            }
        }
        // 拼接数字
        // 一位数
        if (moneyText.length == 0) {
            // 输入 0 或者 .
            if (sender.tag == 5010 || sender.tag == 5011) {
                self.moneyView.text = [NSString stringWithFormat:@"0."];
            }
            // 1~9
            if (sender.tag >= 5001 && sender.tag <= 5009) {
                self.moneyView.text = title;
            }
        } else {
            // 拼接0~9
            if (sender.tag >= 5001 && sender.tag <= 5010) {
                self.moneyView.text = [moneyText stringByAppendingString:title];
            }
            // 拼接小数点
            if (sender.tag == 5011) {
                // 判断是否已经有小数点
                if ([moneyText rangeOfString:@"."].location != NSNotFound) {
                    self.moneyView.text = [moneyText stringByAppendingString:@""];
                }else {
                    self.moneyView.text = [moneyText stringByAppendingString:@"."];
                }
            }
        }
        // 4. 判断是否有小数点
        if (sender.tag == 5011) {
            // 判断是否已经有小数点
            if ([moneyText rangeOfString:@"."].location != NSNotFound) {
                self.moneyView.text = [moneyText stringByAppendingString:@""];
            }else {
                self.moneyView.text = [moneyText stringByAppendingString:@"."];
            }
        }
    }
}
//获取某个字符串或者汉字的首字母.

- (NSString *)firstCharactorWithString:(NSString *)string{
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str capitalizedString];
    return [pinYin substringToIndex:1];

}
- (IBAction)shoukuanAction:(id)sender {
    [self clickGatherBtnAction:self.gatherBtn];
}
// 立即收款
- (IBAction)clickGatherBtnAction:(QMUIButton *)sender {
        __weak typeof(self) weakSelf = self;
        if (self.moneyView.text.floatValue <= 0 || [[self firstCharactorWithString:self.moneyView.text] isEqualToString:@"."]) {
            [MCToast showMessage:@"请输入正确的金额" position:MCToastPositionCenter];
            return;
        }
    #ifndef __OPTIMIZE__
        
    #else
        if (self.moneyView.text.floatValue < 100) {
            [MCToast showMessage:@"收款金额不能低于100元" position:MCToastPositionCenter];
            return;
        }
    #endif
       
        if (!self.xinyongInfo) {
            [MCToast showMessage:@"请选择支付的信用卡" position:MCToastPositionCenter];
            return;
        }
        if (!self.chuxuInfo) {
            [MCToast showMessage:@"请选择到账的储蓄卡" position:MCToastPositionCenter];
            return;
        }
    
    
    if (self.whereCome == 1) {
        if ([self.cityId isEqualToString:@"-1"]) {
            [MCToast showMessage:@"请选择地区" position:MCToastPositionCenter];
            return;
        }
        KDSlotCardAisleViewController *vc = [[KDSlotCardAisleViewController alloc] init];
        vc.money = self.moneyView.text;
        vc.xinyongInfo = self.xinyongInfo;
        vc.chuxuInfo = self.chuxuInfo;
        vc.cityId = self.cityId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (self.whereCome == 2) {
        NSString * url = @"/api/v1/player/quickPay/pre";
        NSDictionary *params = @{
            @"amount":self.moneyView.text,
            @"creditCardId":self.xinyongInfo.id,
            @"debitCardId":self.chuxuInfo.id,
         };
        
        [MCSessionManager.shareManager mc_Post_QingQiuTi:url parameters:params ok:^(NSDictionary * _Nonnull respDic) {
            KDPayNewViewController * vc = [[KDPayNewViewController alloc]init];
            vc.cardModel = weakSelf.xinyongInfo;
            vc.cardchuxuModel = weakSelf.chuxuInfo;
            vc.channelId = [NSString stringWithFormat:@"%@",respDic[@"channelBind"][@"channelId"]];
            vc.amount = weakSelf.moneyView.text;
            vc.whereCome = weakSelf.whereCome;
            //发短信
            if ([respDic[@"channelBind"][@"bindStep"] isEqualToString:@"Sms"] ) {
                vc.channelBindId = [NSString stringWithFormat:@"%@",respDic[@"channelBind"][@"id"]];
            }else{
                vc.orderId = [NSString stringWithFormat:@"%@",respDic[@"orderId"]];
            }
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } other:^(NSDictionary * _Nonnull respDic) {
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
    
    if (self.whereCome == 3) {

        NSString * url = @"/api/v1/player/facePay/pre";
        NSDictionary *params = @{
            @"amount":self.moneyView.text,
            @"creditCardId":self.xinyongInfo.id,
            @"debitCardId":self.chuxuInfo.id,
         };
        
        [MCSessionManager.shareManager mc_Post_QingQiuTi:url parameters:params ok:^(NSDictionary * _Nonnull respDic) {
            if ([respDic[@"facePayParam"][@"faceAuthable"] integerValue] == 0) {
                MCWebViewController *web = [[MCWebViewController alloc] init];
                web.urlString = respDic[@"facePayParam"][@"url"];
                web.title = @"";
                [weakSelf.navigationController pushViewController:web animated:YES];
            }else{
                weakSelf.orderId = respDic[@"orderId"];
                
                //加入到主线程当中
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    JFTBindFaceManager *mgr = [[JFTBindFaceManager alloc] init];
                    mgr.delegate = self;
                    //通知主线程刷新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [mgr bindFaceAuthPresentController:self];
                    });
                });
        
                  
                
        
             
                

            }
        } other:^(NSDictionary * _Nonnull respDic) {
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }

    

}
/****************************** == delegate == ********************************/
- (void)bindFaceMgrDidFinishWithToken:(NSString *)token{
    [self facePayConfirm:self.orderId code:token];
}
- (void)bindFaceMgrDidFinishWithError:(NSString *)errCode sequence_id:(NSString *)sequenceId{
    NSLog(@"FaceAuth errCode: %@ === sequenceId: %@",errCode,sequenceId);
}



/****************************** == delegate == ********************************/
-(void)facePayConfirm:(NSString *)orderId code:(NSString *)code{
    
    if (orderId.length == 0) {
        [MCToast showMessage:@"获取orderId失败"];
        return;
    }
    if (code.length == 0) {
        [MCToast showMessage:@"获取code失败"];
        return;
    }
     NSString * url = @"/api/v1/player/facePay/confirm";
    NSDictionary *params =
    @{
        @"orderId":orderId,
        @"code":code,
     };
    __weak typeof(self) weakSelf = self;

    
    [MCSessionManager.shareManager mc_Post_QingQiuTi:url parameters:params ok:^(NSDictionary * _Nonnull respDic) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MCToast showMessage:@"操作成功"];
        });
        
        NSString * url = [NSString stringWithFormat:@"/api/v1/player/order"];
        [self.sessionManager mc_GET:url parameters:@{} ok:^(NSDictionary * _Nonnull respDic) {
            
            if ([respDic[@"data"] count] == 0) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];

            }else{
                KDSlotCardOrderInfoViewController *vc1 = [[KDSlotCardOrderInfoViewController alloc] init];
                vc1.slotHistoryModel = [KDSlotCardHistoryModel mj_objectArrayWithKeyValuesArray:respDic[@"data"]][0];
                [self.navigationController pushViewController:vc1 animated:YES];
               
            }
        }] ;
        
    } other:^(NSDictionary * _Nonnull respDic) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
/** 添加信用卡 */
- (IBAction)clickAddCreditCardBtn:(QMUIButton *)sender {
    __weak __typeof(self)weakSelf = self;
    [weakSelf pushCardVCWithType:MCBankCardTypeXinyongka];

//    [[KDGuidePageManager shareManager] requestShiMing:^{
//        //默认信用卡
//        NSDictionary *p1 = @{@"userId":SharedUserInfo.userid,
//                             @"type":@"0",
//                             @"nature":@"0",
//                             @"isDefault":@"1"};
//        [MCLATESTCONTROLLER.sessionManager mc_POST:@"/user/app/bank/query/byuseridandtype/andnature" parameters:p1 ok:^(NSDictionary * _Nonnull resp) {
//            [weakSelf pushCardVCWithType:MCBankCardTypeXinyongka];
//        } other:^(NSDictionary * _Nonnull resp) {
//            [MCLoading hidden];
//            if ([resp[@"code"] isEqualToString:@"666666"]) {
//                [MCPagingStore pagingURL:rt_card_edit withUerinfo:@{@"type":@(MCBankCardTypeXinyongka), @"isLogin":@(NO),@"whereCome":@"1"}];
//            } else {
//                [MCToast showMessage:resp[@"messege"]];
//            }
//        }];
//    }];


    
    

    
    
    
    
    
   
}
/** 添加储蓄卡 */
- (IBAction)clickAddDepositCardBtn:(QMUIButton *)sender {
    [self pushCardVCWithType:MCBankCardTypeChuxuka];
    
}
- (IBAction)chooseAddressAction:(id)sender {
    [self.view endEditing:YES];
    [self.addressPicker show];
}
- (BRAddressPickerView *)addressPicker {
    if (!_addressPicker) {
        _addressPicker = [[BRAddressPickerView alloc] initWithPickerMode:BRAddressPickerModeCity];
        _addressPicker.title = @"请选择消费地区";
        _addressPicker.selectValues = @[@"上海市", @"上海市"];
        __weak __typeof(self)weakSelf = self;
        _addressPicker.resultBlock = ^(BRProvinceModel * _Nullable province, BRCityModel * _Nullable city, BRAreaModel * _Nullable area) {
            [MCLATESTCONTROLLER.sessionManager mc_GET:@"/api/v1/player/province" parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
                NSArray * respArry = [NSArray arrayWithArray:resp];
                for (NSDictionary * dic1 in respArry) {
                    if ([dic1[@"name"] containsString:province.name] || [province.name containsString:dic1[@"name"]]) {
                        for (NSDictionary * dic2 in dic1[@"cities"]) {
                            if ([dic2[@"name"] containsString:city.name] || [city.name containsString:dic2[@"name"]]) {
//                                weakSelf.provinceId = [NSString stringWithFormat:@"%@",dic2[@"provinceId"]];
                                weakSelf.cityId = [NSString stringWithFormat:@"%@",dic2[@"id"]];
                                [weakSelf.selectAdress setTitle:[NSString stringWithFormat:@"%@-%@",dic1[@"name"],dic2[@"name"]] forState:0];
                            }
                        }
                    }
                }
            }];
        };
    }
    return _addressPicker;
}
#pragma mark - 数据请求

- (void)nocardAlertShowWithMessage:(NSString *)msg type:(MCBankCardType)cardType cardModel:(MCBankCardModel *)cardModel {
    __weak __typeof(self)weakSelf = self;
    self.commonAlert = [KDCommonAlert newFromNib];
    [self.commonAlert initKDCommonAlertContent:msg  isShowClose:NO];
    self.commonAlert.rightActionBlock = ^{
        [MCPagingStore pagingURL:rt_card_edit withUerinfo:@{@"type":cardType==MCBankCardTypeXinyongka?@(MCBankCardTypeXinyongka):@(MCBankCardTypeChuxuka), @"isLogin":@(NO),@"whereCome":@"1"}];

//[weakSelf pushCardVCWithType:cardType];
        
    };
}
- (void)pushCardVCWithType:(MCBankCardType)cardType
{
    MCCardManagerController *vc = [[MCCardManagerController alloc] init];
    if (cardType == MCBankCardTypeXinyongka) {
        vc.titleString = @"选择信用卡";
    } else {
        vc.titleString = @"选择储蓄卡";
    }
    [self.navigationController pushViewController:vc animated:YES];
    vc.selectCardBlock = ^(MCBankCardModel * _Nonnull cardModel, NSInteger type) {
        if (type == 0) {
            self.xinyongInfo = cardModel;
        } else {
            self.chuxuInfo = cardModel;
        }
    };
}

// 设置储蓄卡按钮信息
- (void)setChuxuInfo:(MCBankCardModel *)chuxuInfo
{
    _chuxuInfo = chuxuInfo;
    if (!chuxuInfo) {
        self.depositImg.hidden = YES;
        self.depositLabel.hidden = YES;
        return;
    }
    MCBankCardInfo *ii = [MCBankStore getBankCellInfoWithName:chuxuInfo.bankName];
    self.depositImg.image = ii.logo;
    self.depositImg.hidden = NO;
    NSString *cardNo = chuxuInfo.bankCardNo;
    if (cardNo && cardNo.length > 4) {
        NSString *bank = [NSString stringWithFormat:@"%@ (%@)",@"",[cardNo substringFromIndex:cardNo.length-4]];
        self.depositLabel.text = bank;
    }
    self.depositLabel.hidden = NO;
    [self.addDepositBtn setTitle:@"更换" forState:UIControlStateNormal];
}
// 设置信用卡按钮信息
- (void)setXinyongInfo:(MCBankCardModel *)xinyongInfo
{
    _xinyongInfo = xinyongInfo;
    if (!xinyongInfo) {
        self.creditImg.hidden = YES;
        self.creditLabel.hidden = YES;
        return;
    }
    MCBankCardInfo *ii = [MCBankStore getBankCellInfoWithName:xinyongInfo.bankName];
    self.creditImg.image = ii.logo;
    self.creditImg.hidden = NO;
    NSString *cardNo = xinyongInfo.bankCardNo;
    if (cardNo && cardNo.length > 4) {
        NSString *bank = [NSString stringWithFormat:@"%@ (%@)",@"",[cardNo substringFromIndex:cardNo.length-4]];
        self.creditLabel.text = bank;
    }
    self.creditLabel.hidden = NO;
    [self.addCreditBtn setTitle:@"更换" forState:UIControlStateNormal];
}


//时时获取输入框输入的新内容   return NO：输入内容清空   return YES：输入内容不清空， string 输入内容 ，range输入的范围
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //限制只能输入数字
    BOOL isHaveDian = YES;
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {
            //数据格式正确
            if([textField.text length] == 0){
                if(single == '.') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian) {
                    //text中还没有小数点
                    isHaveDian = YES;
                    return YES;
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                //存在小数点
                if (isHaveDian) {
                    //判断小数点的位数，2 代表位数，可以
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{
            //输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    return YES;
}

-(void)cardVCBack:(NSNotification *)notification{
    [self requestDefaultChuXuCards];
}

@end
