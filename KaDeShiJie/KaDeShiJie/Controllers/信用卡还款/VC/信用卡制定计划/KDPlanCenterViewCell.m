//
//  KDPlanCenterViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDPlanCenterViewCell.h"
#import "KDRefundTimeView.h"
#import "KDDirectPushChoseStatusView.h"
#import "KDPlanAlertView.h"

#import "KDCalendarView.h"
#import "MSSCalendarHeaderModel.h"
#import "KDPlanPreviewViewController.h"

#import "KDRepaymentDetailModel.h"
#import "KDTotalAmountModel.h"
#import "KDBingCardNewViewController.h"
@interface KDPlanCenterViewCell ()<KDRefundTimeViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *markView;

// 每日还款次数
@property (weak, nonatomic) IBOutlet QMUIButton *refundCountBtn;

// 默认日期按钮
@property (weak, nonatomic) IBOutlet QMUIButton *normalRefundTypeBtn;
// 定制日期
@property (weak, nonatomic) IBOutlet QMUIButton *selectRefundTypeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refundTypeCons;

// 盛可变日期的view
@property (weak, nonatomic) IBOutlet UIView *refundTimeContentView;

// 显示日历选中的view
@property (nonatomic, strong) KDRefundTimeView *refundTimeView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeContentViewHigCons;

// 实际还款金额将略大于账单金额
@property (weak, nonatomic) IBOutlet UILabel *moneyDetailLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyTypeTopCons;
// 地址按钮
@property (weak, nonatomic) IBOutlet QMUIButton *addressBtn;
// 指定计划
@property (weak, nonatomic) IBOutlet UIButton *planBtn;
// 选择地址view
@property (nonatomic, strong) BRAddressPickerView *addressPicker;

@property(nonatomic, strong) QMUIModalPresentationViewController *modalVC;
@property(nonatomic, strong) KDCalendarView *calendar;

@property (weak, nonatomic) IBOutlet UILabel *refundDateLabel;

/** 还款总金额 */
@property (weak, nonatomic) IBOutlet UITextField *refundMoneyView;
/** 卡余额 */
@property (weak, nonatomic) IBOutlet UITextField *cardBalanceView;

//启动计划,需要的两个参数
@property (nonatomic, strong) NSString * city;  //浙江省-杭州市-330000-330100
@property (nonatomic, strong) NSString * extra;//
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;

@property (nonatomic, strong) NSString * version;//通道标识
@property (nonatomic, strong) NSString * channelTag;//通道名称

@property (nonatomic, strong) BRResultModel * provinceModel;
@property (nonatomic, strong) BRResultModel * cityModel;
//还款月
@property (nonatomic, assign) NSInteger repaymentMonth;
//账单月
@property (nonatomic, assign) NSInteger billMonth;

@property (nonatomic, strong)  NSMutableArray * timeArray;//
@property (weak, nonatomic) IBOutlet QMUIButton *fouBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *shiBtn;

@property (nonatomic, strong) BRStringPickerView *pickView1;
@property (nonatomic, strong) BRStringPickerView *pickView2;


@property (nonatomic, assign) NSInteger needDay;
@property (nonatomic, strong) NSString *limitPrice;
@property(nonatomic, strong) NSString * provinceId;
    @property(nonatomic, strong) NSString * cityId;
@end

@implementation KDPlanCenterViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 10;
    self.markView.layer.cornerRadius = 3;
    self.refundCountBtn.imagePosition = QMUIButtonImagePositionRight;
    self.refundTypeCons.constant = 33.5;
    self.refundTimeContentView.layer.cornerRadius = 3;
    [self.refundTimeContentView addSubview:self.refundTimeView];
    self.moneyTypeTopCons.constant = 33.5;
    self.planBtn.layer.cornerRadius = 24.5;
    self.addressBtn.imagePosition = QMUIButtonImagePositionRight;
    self.timeArray = [[NSMutableArray alloc]init];
    //xxz
    [self clickNormalRefundTypeBtn:self.normalRefundTypeBtn];
    [self.refundMoneyView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.cardBalanceView addTarget:self action:@selector(textFieldDidChangeCardBalanceView:) forControlEvents:UIControlEventEditingChanged];
    [self.addressBtn setTitle:@"请选择消费地区" forState:UIControlStateNormal];
    self.cardBalanceView.delegate = self;
    [self changeStatesAndChannel];
//    [self.planBtn setupDisAppearance];
    self.planBtn.userInteractionEnabled = NO;
    self.needDay = 0;
    self.cityId = @"-1";
    [self requestlimitmin];
}
-(void)requestlimitmin{
    kWeakSelf(self);
    //请求市
    [[MCSessionManager shareManager] mc_POST:@"/creditcardmanager/app/limit/min" parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
        weakself.limitPrice = [NSString stringWithFormat:@"%@",resp[@"result"]];
    }];
}
#pragma mark -------------------获取默认日期顺序还款的还款日期--------------------------
- (void)getNormalDateRefund
{
    //获取当前年
    NSString *currentYear = [MCDateStore getYear];
    //获取当前月
    NSString *currentMonth = [MCDateStore getMonth];
    //获取下个月
    NSString *nextMonth = [MCDateStore getNextMonth:currentMonth.integerValue];
    //获取前一月
    NSString *upperDay = [MCDateStore getUpperMonth:currentMonth.integerValue];
    //获取当天号
    NSInteger currentDay = [MCDateStore getCurrentDay];
    //获取后一天
    NSInteger nextDay = [MCDateStore getNextDay:currentDay];

    
    
    
    //还款日
    NSString *repaymentDay  = self.directModel.repaymentDay < 10 ?
    [NSString stringWithFormat:@"0%ld",self.directModel.repaymentDay] :
    [NSString stringWithFormat:@"%ld",self.directModel.repaymentDay];
    
    //账单月份
    NSString * jisuanBillMonth = @"";
    //还款月份
    NSString * jisuanRepaymentMonth = @"";

    if (self.directModel.repaymentDay > self.directModel.billDay) {
        if (currentDay <= self.directModel.repaymentDay) {
            jisuanBillMonth = currentMonth;
            jisuanRepaymentMonth = currentMonth;
        }else{
            jisuanBillMonth = nextMonth;
            jisuanRepaymentMonth = nextMonth;
        }
    }else if (self.directModel.repaymentDay < self.directModel.billDay){
        if (currentDay >= self.directModel.billDay) {
            jisuanBillMonth = currentMonth;
            jisuanRepaymentMonth = nextMonth;
        }else if (currentDay > self.directModel.repaymentDay && currentDay < self.directModel.billDay){
            jisuanBillMonth = currentMonth;
            jisuanRepaymentMonth = nextMonth;
        }else if (currentDay <= self.directModel.repaymentDay){
            jisuanBillMonth = upperDay;
            jisuanRepaymentMonth = currentMonth;
        }
    }else if (self.directModel.repaymentDay == self.directModel.billDay){
        if (currentDay < self.directModel.repaymentDay) {
            jisuanBillMonth = upperDay;
            jisuanRepaymentMonth = currentMonth;
        }else if (currentDay > self.directModel.repaymentDay){
            jisuanBillMonth = currentMonth;
            jisuanRepaymentMonth = nextMonth;
        }
    }
    self.repaymentMonth = [jisuanRepaymentMonth integerValue];
    self.billMonth = [jisuanBillMonth integerValue];
    
    kWeakSelf(self);
    //1.查询当天是否可以开始执行
    [[MCSessionManager shareManager] mc_POST:@"/creditcardmanager/app/plan/today/run" parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
        //结果说明：resp_message为0代表当天不执行计划，为1代表当天开始执行计划
        NSString * currentDayString = currentDay < 10 ? [NSString stringWithFormat:@"0%ld",currentDay] : [NSString stringWithFormat:@"%ld",currentDay];
        if ([resp[@"messege"] isEqualToString:@"1"]) {
            weakself.refundDateLabel.text = [NSString stringWithFormat:@"%@-%@~%@-%@",currentMonth,currentDayString,jisuanRepaymentMonth,repaymentDay];
            
        }else{
             NSString * tomorrowDate =  [MCDateStore GetTomorrowDay:[NSString stringWithFormat:@"%@-%@-%ld",currentYear,currentMonth,currentDay]];
             NSString * tomorrowDay = [tomorrowDate substringFromIndex:5];
             weakself.refundDateLabel.text = [NSString stringWithFormat:@"%@~%@-%@",tomorrowDay,jisuanRepaymentMonth,repaymentDay];
        }
    }];
}


#pragma mark -------------------点击默认日期顺序还款--------------------------
- (IBAction)clickNormalRefundTypeBtn:(QMUIButton *)sender {
    [self.addressBtn setTitle:@"请选择消费地区" forState:0];
    [self.cardBalanceView endEditing:NO];
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    self.selectRefundTypeBtn.selected = NO;
    // 隐藏日历选中的view
    for (UIView *view in self.refundTimeView.subviews) {
        view.hidden = YES;
    }
    self.refundTimeView.hidden = YES;
    
    // 默认日期显示
    for (UIView *view in self.refundTimeContentView.subviews) {
        view.hidden = NO;
    }

    [UIView animateWithDuration:0.5 animations:^{
        self.refundTypeCons.constant = 60;
        self.refundTimeContentView.hidden = NO;
        self.timeContentViewHigCons.constant = 32;
        
    }];
    CGFloat cellHeight = 600 - 14 + self.refundTypeCons.constant - 14 + self.moneyTypeTopCons.constant;
    if ([self.delegate respondsToSelector:@selector(centerCellChoseRefundType:changeCenterCellHeight:)]) {
        [self.delegate centerCellChoseRefundType:@"1" changeCenterCellHeight:cellHeight];
    }
}
#pragma mark -------------------点击定制日期还款--------------------------
- (IBAction)clickSelectRefundTypeBtn:(QMUIButton *)sender {
//    [self.addressBtn setTitle:@"请选择消费地区" forState:0];
//    //检查界面参数
//    if (![self checkParameters]) { return;}
    self.selectRefundTypeBtn.selected = YES;
    self.normalRefundTypeBtn.selected = NO;
    [self.modalVC showWithAnimated:YES completion:nil];

//    [self needDayAction1];
}
#pragma mark ------------------弹出日历------------------------
- (void)showCalendarDateWithChose:(NSArray *)timeArray {
    [self.cardBalanceView endEditing:NO];
    self.selectRefundTypeBtn.selected = YES;
    self.normalRefundTypeBtn.selected = NO;
    for (UIView *view in self.refundTimeContentView.subviews) {
        view.hidden = YES;
    }
    self.refundTimeContentView.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.5 animations:^{
        self.refundTimeContentView.hidden = NO;
        if (timeArray.count <= 5) {
            self.timeContentViewHigCons.constant = 18;
        } else if (timeArray.count <= 10) {
            self.timeContentViewHigCons.constant = 46;
        } else if (timeArray.count <= 15) {
            self.timeContentViewHigCons.constant = 70;
        } else if (timeArray.count <= 20) {
            self.timeContentViewHigCons.constant = 100;
        } else if (timeArray.count <= 30) {
            self.timeContentViewHigCons.constant = 130;
        } else if (timeArray.count <= 40) {
            self.timeContentViewHigCons.constant = 160;
        }else if (timeArray.count <= 50) {
            self.timeContentViewHigCons.constant = 190;
        }
        self.refundTypeCons.constant = self.timeContentViewHigCons.constant ;//+ 28;
        
        self.refundTimeView.timeArray = timeArray;
        self.refundTimeView.hidden = NO;
        
    }];
    CGFloat cellHeight = 600 - 14 + self.refundTypeCons.constant - 14 + self.moneyTypeTopCons.constant;
    if ([self.delegate respondsToSelector:@selector(centerCellChoseRefundType:changeCenterCellHeight:)]) {
        [self.delegate centerCellChoseRefundType:@"1" changeCenterCellHeight:cellHeight];
    }
}
#pragma mark - KDRefundTimeViewDelegate
- (void)refundTimeViewDelegateChangeTimeViewHig:(CGFloat)hig
{
    [UIView animateWithDuration:0.5 animations:^{
        self.refundTypeCons.constant = 60 + hig - 32;
        self.timeContentViewHigCons.constant = hig;
        
        CGFloat cellHeight = 600 - 14 + self.refundTypeCons.constant - 14 + self.moneyTypeTopCons.constant;
        if ([self.delegate respondsToSelector:@selector(centerCellChoseRefundType:changeCenterCellHeight:)]) {
            [self.delegate centerCellChoseRefundType:@"1" changeCenterCellHeight:cellHeight];
        }
    }];
}
#pragma mark ------------------还款消费是否取消小数点------------------------
- (IBAction)choseMoneyTypeView:(UIButton *)sender {

}
- (IBAction)shiAction:(id)sender {

}
#pragma mark ------------------选择地址------------------------
- (IBAction)clickAddressBtn:(QMUIButton *)sender {

    //检查界面参数
    if (![self checkParameters]) { return;}
    [self.cardBalanceView endEditing:NO];
    [self getRepayMentChannel];
}
#pragma mark ------------------选择还款次数------------------------
- (IBAction)clickRefundCountBtn:(QMUIButton *)sender {
    [self changeStatesAndChannel];
    [self.cardBalanceView endEditing:NO];
    QMUIModalPresentationViewController *diaVC = [[QMUIModalPresentationViewController alloc] init];
    KDDirectPushChoseStatusView *typeView = [[KDDirectPushChoseStatusView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    diaVC.contentView = typeView;
    typeView.titleArray = @[@"1次/日", @"2次/日", @"3次/日", @"4次/日"];
    diaVC.contentViewMargins = UIEdgeInsetsZero;
    [diaVC showWithAnimated:YES completion:nil];
    typeView.choseStatus = ^(NSString * _Nonnull status) {
        if ([status isEqualToString:@"取消"]) {
            [diaVC hideWithAnimated:YES completion:nil];
            return;
        }
        [self.refundCountBtn setTitle:[status componentsSeparatedByString:@"/日"][0] forState:UIControlStateNormal];
        [diaVC hideWithAnimated:YES completion:nil];
        
        
    };
}
#pragma mark ------------------检查界面参数------------------------
-(BOOL)checkParameters{
    //检查还款总金额参数
    if ([self inRefundMoneyToNewMoney] == 0) {
        [MCToast showMessage:@"请填写还款总金额"];
        return NO;
        //检查卡余额参数
    }else if ([self.cardBalanceView.text doubleValue] == 0 || [self.cardBalanceView.text doubleValue] < [self.limitPrice doubleValue]) {
        [MCToast showMessage:[NSString stringWithFormat:@"卡余额需要大于%@元才能制定计划,请确认卡余额",self.limitPrice]];
        self.cardBalanceView.text = self.limitPrice;
        [self changeStatesAndChannel];
        return NO;
        //检查消费地区参数
    }
    return YES;
}
#pragma mark ------------------根据各种参数,计算至少需要的天数------------------------
-(void)needDayAction1{
    [self.cardBalanceView endEditing:NO];
//    if (![self checkParameters]) {return;}
    //先请求通道
    kWeakSelf(self);
    static NSTimeInterval time = 0;
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    //限制用户点击按钮的时间间隔大于1秒钟
        if (currentTime - time > 1) {
        //处理逻辑
            //请求通道
            [[MCSessionManager shareManager] mc_POST:@"/creditcardmanager/app/chooes/repayment/channel" parameters:[self getParameters] ok:^(NSDictionary * _Nonnull resp) {
                if ([resp[@"result"] isKindOfClass:[NSArray class]] && [resp[@"result"] count] > 0) {
                    NSString * version = resp[@"result"][0][@"version"];
                    weakself.version = version;
                    weakself.channelTag = resp[@"result"][0][@"channelTag"];
                   
                    
                    //如果选择日期选框，就直接要请求次数
                    if (weakself.selectRefundTypeBtn.selected) {
                        [weakself needDayAction2];
                    }else{
                        //否则直接需要请求省市
                        [weakself requestProvice];
                    }
                    
                    
                }else{
                    [MCToast showMessage:@"暂无通道"];
                }
            }];
        }
    time = currentTime;

}
-(void)needDayAction2{

    NSDictionary * parDic = @{

        @"amount":self.refundMoneyView.text,
        @"reservedAmount":self.cardBalanceView.text,
        @"dayRepaymentCount":[self.refundCountBtn.titleLabel.text replaceAll:@"次" target:@""],
        @"version":self.version,

        @"userId":SharedUserInfo.userid,
        @"creditCardNumber":self.directModel.cardNo,
        @"brandId":SharedConfig.brand_id,
        
    };
    kWeakSelf(self);
    //1.查询当天是否可以开始执行
    [[MCSessionManager shareManager] mc_POST:@"/creditcardmanager/app/balance/plan/budget/day" parameters:parDic ok:^(NSDictionary * _Nonnull resp) {
        weakself.needDay = [resp[@"result"] integerValue];
        [weakself.modalVC showWithAnimated:YES completion:nil];
    }];
}
#pragma mark ------------------提取公共的参数------------------------
-(NSMutableDictionary *)getParameters{
    //检查界面参数
    if (![self checkParameters]) { return nil;}
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:SharedUserInfo.userid forKey:@"userId"];
    [params setValue:SharedConfig.brand_id forKey:@"brandId"];
    
    [params setValue:self.directModel.cardNo forKey:@"creditCardNumber"];//卡号
    
    [params setValue:[NSString stringWithFormat:@"%.2f",[self inRefundMoneyToNewMoney]] forKey:@"amount"];// 还款金额
    [params setValue:self.cardBalanceView.text forKey:@"reservedAmount"];//预留金额
    
    [params setValue:@"" forKey:@"executeDate"];//执行任务的日期
    
    NSString * dayRepaymentCount = [self.refundCountBtn.titleLabel.text replaceAll:@"次" target:@""];
    [params setValue:dayRepaymentCount forKey:@"dayRepaymentCount"];//单日还款笔数
    return params;
}
#pragma mark ------------------第一步请求通道------------------------
- (void)getRepayMentChannel{
    if (![self getParameters]) {return;}
    //直接请求省
    [self.addressPicker show];
}
- (BRAddressPickerView *)addressPicker {
    if (!_addressPicker) {
        _addressPicker = [[BRAddressPickerView alloc] initWithPickerMode:BRAddressPickerModeCity];
        _addressPicker.title = @"请选择开户省市";
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
                                [weakSelf.addressBtn setTitle:[NSString stringWithFormat:@"%@-%@",dic1[@"name"],dic2[@"name"]] forState:0];
                            }
                        }
                    }
                }
            }];
        };
    }
    return _addressPicker;
}
#pragma mark ------------------第二步请求省------------------------
-(void)requestProvice{
    kWeakSelf(self);
    //请求省市
    NSDictionary * dic = @{@"type":@"1",@"channelTag":self.channelTag};
    [[MCSessionManager shareManager] mc_POST:@"/paymentgateway/verification/getcitycode" parameters:dic ok:^(NSDictionary * _Nonnull resp) {
        NSArray * result = resp[@"result"];
        NSMutableArray * modelArray = [[NSMutableArray alloc]init];
        for (NSDictionary * dic in result) {
            BRResultModel * model = [[BRResultModel alloc]init];
            model.key =   dic[@"cityCode"];
            model.value = dic[@"cityName"];
            [modelArray addObject:model];
        }
        if (!self.pickView1) {
            self.pickView1 = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
        }
       
        
        self.pickView1.title = @"请选择省份";
        self.pickView1.dataSourceArr = modelArray;
        [self.pickView1 show];
        self.pickView1.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            weakself.provinceModel = resultModel;
            [weakself requestCity:resultModel.key];
        };
        self.pickView1.cancelBlock = ^{[UIView animateWithDuration:0.5 animations:^{}]; };
    }];
}
-(void)requestCity:(NSString *)cityKey{
    kWeakSelf(self);
    //请求市
    NSDictionary * dic = @{@"type":@"2",@"channelTag":self.channelTag,@"provinceCode":cityKey};
    [[MCSessionManager shareManager] mc_POST:@"/paymentgateway/verification/getcitycode" parameters:dic ok:^(NSDictionary * _Nonnull resp) {
        NSArray * result = resp[@"result"];
        NSMutableArray * modelArray = [[NSMutableArray alloc]init];
        for (NSDictionary * dic in result) {
            BRResultModel * model = [[BRResultModel alloc]init];
            model.key = dic[@"cityCode"];
            model.value = dic[@"cityName"];
            [modelArray addObject:model];
        }
        if (!self.pickView2) {
            self.pickView2 = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
        }

        self.pickView2.title = @"请选择城市";
        self.pickView2.dataSourceArr = modelArray;
        [self.pickView2 show];
        self.pickView2.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            weakself.cityModel = resultModel;
            [weakself.addressBtn setTitle:[NSString stringWithFormat:@"%@-%@",weakself.provinceModel.value,weakself.cityModel.value] forState:UIControlStateNormal];
        };
        self.pickView2.cancelBlock = ^{[UIView animateWithDuration:0.5 animations:^{}];};
    }];
}
#pragma mark ------------------第三步制定计划,按钮点击方法------------------------
- (IBAction)clickPlanBtn:(KDFillButton *)sender {
    [self requestCreatePlan];
}
-(void)requestCreatePlan{
    //First, Fourth, Second, Third
    NSString * period;
    if ([self.refundCountBtn.titleLabel.text isEqualToString:@"1次"]) {
        period = @"First";
    }
    if ([self.refundCountBtn.titleLabel.text isEqualToString:@"2次"]) {
        period = @"Second";
    }
    if ([self.refundCountBtn.titleLabel.text isEqualToString:@"3次"]) {
        period = @"Third";
    }
    if ([self.refundCountBtn.titleLabel.text isEqualToString:@"4次"]) {
        period = @"Fourth";
    }
    


      NSDate *date = [NSDate date];
      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
      [formatter setDateFormat:@"yyyy-MM-dd"];
      //获取当前时间日期展示字符串 如：2019-05-23-13:58:59
      NSString *planStartDate = [formatter stringFromDate:date];
    if ([self inRefundMoneyToNewMoney] <= 0) {
        [MCToast showMessage:@"请填写还款总金额"];
        return;
    }
    if ([self.cardBalanceView.text doubleValue] <= 0) {
        [MCToast showMessage:@"请填写卡余额"];
        return;
    }
    if ([self.cityId isEqualToString:@"-1"]) {
        [MCToast showMessage:@"请选择地区"];
        return;
    }
   
    // "planDates": "2021-12-16,2021-12-17,2021-12-18,2021-12-19"
      NSDictionary * dic = @{
        @"cardBalance":self.cardBalanceView.text,
        @"creditCardId":[NSString stringWithFormat:@"%@",self.directModel.id],
        @"period":period,
        @"repaymentAmount":[NSString stringWithFormat:@"%.0f",[self inRefundMoneyToNewMoney]],
        @"cityId":self.cityId,
    };
    
    NSMutableDictionary * mdic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    
 
    
    //默认日期
    if (self.normalRefundTypeBtn.selected) {
        [mdic setValue:planStartDate forKey:@"planStartDate"];
    }else{
        NSString *executeDateString = [self.timeArray componentsJoinedByString:@","];
        [mdic setValue:executeDateString forKey:@"planDates"];
    }
    
    __weak typeof(self) weakSelf = self;
    [[MCSessionManager shareManager] mc_Post_QingQiuTi:@"/api/v1/player/plan" parameters:mdic ok:^(NSDictionary * _Nonnull resp) {
        [weakSelf respCode000000:resp];
    } other:^(NSDictionary * _Nonnull resp) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
//① 第三步制定计划
- (void)requestZhiDingJiHua{
    if (![self getParameters]) {return;}
    if ([self.addressBtn.titleLabel.text isEqualToString:@"请选择消费地区"] || !self.provinceModel || !self.cityModel){
            [MCToast showMessage:@"请选择消费地区"];
            return;
    }
    //中间需要的天数
    NSString *executeDateString = [self.timeArray componentsJoinedByString:@","];
    //通道的版本号
    NSString * version = self.version;
    //拼凑起最后制定计划接口所需的参数
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self getParameters]];
    //执行任务的日期
    [params setValue:self.normalRefundTypeBtn.selected ? @"" : executeDateString forKey:@"executeDate"];
    //通道的版本号
    [params setValue:version forKey:@"version"];
    //小数点
    [params setValue:self.shiBtn.selected?@"1":@"0" forKey:@"isNotPoint"];
    //创建新的余额任务
    [self requestCreateRepaymentTask:@"/creditcardmanager/app/create/repayment/task/new" params:params];
}
//② 第三步制定计划
-(void)requestCreateRepaymentTask:(NSString *)url params:(NSDictionary *)params{
    kWeakSelf(self);
    [[MCSessionManager shareManager] mc_POST:url parameters:params ok:^(NSDictionary * _Nonnull resp) {
        [weakself respCode000000:resp];
    }other:^(NSDictionary * _Nonnull resp) {
        [MCToast showMessage:resp[@"messege"]];
    }];
}
//③ 第三步制定计划
-(void)respCode000000:(NSDictionary *_Nonnull)resp{
    
    if ([resp[@"channelBind"][@"bindStep"] isEqualToString:@"Sms"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MCToast showMessage:@"当前信用卡未绑定该通道,请先绑卡"];
        });
        KDBingCardNewViewController * vc = [[KDBingCardNewViewController alloc]init];
        vc.cardModel = self.directModel;
        vc.channelBindId = [NSString stringWithFormat:@"%@",resp[@"channelBind"][@"id"]];
        [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];

    }else{
        //拼凑
        KDRepaymentModel *repaymentModel = [[KDRepaymentModel alloc]init];
        
        
        KDPlanPreviewViewController *vc = [[KDPlanPreviewViewController alloc] init];
        vc.repaymentModel = repaymentModel;
        vc.directRefundModel  = self.directModel;
        vc.whereCome = 1;// 1 下单 2 历史记录 3 信用卡还款进来
        vc.startDic = resp;
        [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
    }
    
    
  
}
//获取总金额
-(CGFloat)inRefundMoneyToNewMoney{
    CGFloat money = [self.refundMoneyView.text doubleValue];
    return money;
}
//设置选择地址的可点击状态
-(void)changeStatesAndChannel{
    if ([self inRefundMoneyToNewMoney] != 0 && [self.cardBalanceView.text doubleValue] != 0) {
//        self.addressView.userInteractionEnabled = YES;
        self.addressView.backgroundColor = KWhiteColor;
        self.line1.hidden = self.line2.hidden = NO;
        
    }else{
//        self.addressView.userInteractionEnabled = NO;
        self.addressView.backgroundColor = KWhiteColor;
        self.line1.hidden = self.line2.hidden = NO;
//        self.addressView.backgroundColor = [UIColor qmui_colorWithHexString:@"#f5f5f5"];
//        self.line1.hidden = self.line2.hidden = YES;
    }
    [self.addressBtn setTitle:@"请选择消费地区" forState:0];
}
//还款总金额
- (void)textFieldDidChange:(UITextField *)textView{
//    if ([textView.text rangeOfString:@"¥"].location == NSNotFound) {
//        self.refundMoneyView.text = [NSString stringWithFormat:@"¥%@", textView.text];
//    }
    [self changeStatesAndChannel];
    [self changeBtnStatus];
}
//卡余额
-(void)textFieldDidChangeCardBalanceView:(UITextField *)textView{
    [self changeStatesAndChannel];
}

//设置选择地址的可点击状态
-(void)changeBtnStatus{
    if ([self inRefundMoneyToNewMoney] <= 0) {
//        [self.planBtn setupDisAppearance];
        self.planBtn.userInteractionEnabled = NO;
    }else{
//        [self.planBtn setupAppearance];
        self.planBtn.userInteractionEnabled = YES;

    }
}






#pragma mark -------------------日历view1--------------------------
- (QMUIModalPresentationViewController *)modalVC {
    if (!_modalVC) {
        _modalVC = [[QMUIModalPresentationViewController alloc] init];
        _modalVC.contentView = self.calendar;
        _modalVC.animationStyle = QMUIModalPresentationAnimationStyleFade;
        self.calendar.modalVC = _modalVC;
        __weak __typeof(self)weakSelf = self;
        _modalVC.layoutBlock = ^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
            weakSelf.calendar.frame = CGRectMake(0, SCREEN_HEIGHT-473, SCREEN_WIDTH, 473);
        };
    }
    return _modalVC;
}
#pragma mark -------------------日历view2--------------------------
- (KDCalendarView *)calendar {
    if (!_calendar) {
        _calendar = [[[NSBundle mainBundle] loadNibNamed:@"KDCalendarView" owner:nil options:nil] lastObject];
        _calendar.billDay =      1;//self.directModel.billDay;         //账单日
        _calendar.repaymentDay = 10;//self.directModel.repaymentDay;    //还款日
        _calendar.billMonth = self.billMonth;//账单月
        _calendar.repaymentMonth = self.repaymentMonth;//还款月
        
        __weak __typeof(self)weakSelf = self;
        _calendar.confirmBlock = ^(NSMutableArray<MSSCalendarModel *> * _Nonnull models) {
            if (models.count < [self needDay]) {
                [MCToast showMessage:[NSString stringWithFormat:@"至少需要选择%ld天",[weakSelf needDay]]];
                return;
            }
            [weakSelf.modalVC hideWithAnimated:YES completion:nil];
            NSMutableArray *dateArray = [NSMutableArray array];
            [weakSelf.timeArray removeAllObjects];
            for (MSSCalendarModel *model in models) {
                [dateArray addObject:[NSString stringWithFormat:@"%02ld/%02ld",(long)model.month, model.day]];
                [weakSelf.timeArray addObject:[NSString stringWithFormat:@"%ld-%02ld-%0l2d",model.year ,model.month, model.day]];
            }
            [weakSelf showCalendarDateWithChose:dateArray];
        };
    }
//    _calendar.needDayCount = [self needDay];    //
    
//    _calendar.needDayLbl.text = [NSString stringWithFormat:@"(至少选择 %ld 天)", [self needDay]];
    
    return _calendar;
}

#pragma mark -------------------选择日期的数组的大view--------------------------
- (KDRefundTimeView *)refundTimeView{
    if (!_refundTimeView) {
        _refundTimeView = [[[NSBundle mainBundle] loadNibNamed:@"KDRefundTimeView" owner:nil options:nil] lastObject];
        _refundTimeView.frame = CGRectMake(0, 0, self.refundTimeContentView.ly_width, 70);
        _refundTimeView.hidden = YES;
        _refundTimeView.delegate = self;
    }
    return _refundTimeView;
}





- (void)setDirectModel:(KDDirectRefundModel *)directModel{
    _directModel = directModel;
    [self getNormalDateRefund];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"planCenterCell";
    KDPlanCenterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDPlanCenterViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
- (IBAction)huankuanzongjineAction:(id)sender {
    [self.refundMoneyView becomeFirstResponder];
}
- (IBAction)kayueAction:(id)sender {
    [self.cardBalanceView becomeFirstResponder];

}

@end
