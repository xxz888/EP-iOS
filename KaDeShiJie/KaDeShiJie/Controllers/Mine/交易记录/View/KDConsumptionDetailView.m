//
//  KDConsumptionDetailView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/25.
//  Copyright © 2020 SS001. All rights reserved.
//
// 消费明细

#import "KDConsumptionDetailView.h"

@interface KDConsumptionDetailView ()
@property (weak, nonatomic) IBOutlet UILabel *orderNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UILabel *lab5;
@property (weak, nonatomic) IBOutlet UILabel *lab6;
@property (weak, nonatomic) IBOutlet UILabel *lab7;
@property (weak, nonatomic) IBOutlet UILabel *lab8;
@end

@interface KDConsumptionDetailView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, strong) QMUIModalPresentationViewController *modalVC;
@end

@implementation KDConsumptionDetailView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDConsumptionDetailView" owner:nil options:nil] firstObject];
    }
    return self;
}

- (QMUIModalPresentationViewController *)modalVC
{
    if (!_modalVC) {
        _modalVC = [[QMUIModalPresentationViewController alloc] init];
        _modalVC.contentViewMargins = UIEdgeInsetsMake(0, 37, 0, 37);
    }
    return _modalVC;
}

- (void)showView
{
    self.modalVC.contentView = self;
    [self.modalVC showWithAnimated:YES completion:nil];
}
- (IBAction)hideView:(id)sender {
    [self.modalVC hideWithAnimated:YES completion:nil];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 16;
}

- (void)setOrderModel:(KDTotalOrderModel *)orderModel
{
    _orderModel = orderModel;
/*
 //状态
 self.statusLabel.text = [orderModel.status isEqualToString:@"Padding"]  ? @"待执行" :
                             [orderModel.status isEqualToString:@"Running"]  ? @"还款中" :
                             [orderModel.status isEqualToString:@"Successful"] ? @"已成功" :
                             [orderModel.status isEqualToString:@"Close"] ? @"已关闭" :
                             [orderModel.status isEqualToString:@"Termination"] ? @"已终止" : @"";

 
 //还款前面有一个小蓝点,消费前面没有
 self.pointView.hidden =  ![orderModel.planTaskType isEqualToString:@"Repayment"];
 //下单返回的数据返回的四个字,消费计划和还款计划四个字,与ui图不一致,要切割
     self.taskStatusLabel.text = [orderModel.planTaskType isEqualToString:@"Consumption"] ? @"消费" : @"还款";
 //金额的label,消费计划取realAmount,还款计划取amount
 self.moneyLabel.text = [NSString stringWithFormat:@"%.3f", orderModel.amount];
 self.moneyLabel.text = [orderModel.planTaskType isEqualToString:@"Repayment"] ? [@"+" append:self.moneyLabel.text] : [@"-" append:self.moneyLabel.text];
 self.timeLabel.text = orderModel.executeTime;
 //记录和还款点击进来,需要显示状态一列
 self.statusLabel.hidden = NO;
 self.statusLabelWidth.constant = 60;
 //设置状态颜色
 if ([self.statusLabel.text isEqualToString:@"已成功"]) {
     self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#87dc5b"];
 } else if ([self.statusLabel.text isEqualToString:@"待执行"] || [self.statusLabel.text isEqualToString:@"待完成"] ) {
     self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#ffc107"];
 } else if ([self.statusLabel.text isEqualToString:@"已失败"]) {
     self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#ff5722"];
 } else if ([self.statusLabel.text isEqualToString:@"还款中"] || [self.statusLabel.text isEqualToString:@"已取消"]) {
     self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#ffc107"];
 }

 **/
    self.orderNumLbl.text = orderModel.planTaskId;
    self.lab1.text = [NSString stringWithFormat:@"%.3f", orderModel.amount];
    self.lab4.text = [NSString stringWithFormat:@"%.3f%%", orderModel.rate];
    //扣款金额
    self.lab2.text = [NSString stringWithFormat:@"%.3f", orderModel.amount];
    //计划手续费
    self.lab3.text = [NSString stringWithFormat:@"%@",orderModel.fee];
    //计划类型
    self.lab5.text = [orderModel.planTaskType isEqualToString:@"Consumption"] ? @"消费" : @"还款";
    //计划执行时间
    self.lab8.text = orderModel.executeTime;
    //计划状态
    self.lab6.text = [orderModel.status isEqualToString:@"Padding"]  ? @"待执行" :
    [orderModel.status isEqualToString:@"Running"]  ? @"执行中" :
    [orderModel.status isEqualToString:@"Successful"] ? @"已成功" :
    [orderModel.status isEqualToString:@"Close"] ? @"已关闭" :
    [orderModel.status isEqualToString:@"Termination"] ? @"已终止" : @"";
   //失败原因或者计划描述
    self.lab7.text = @"-";
    
//    if (self.balancePlanId) {
//        //扣款金额
//        self.lab2.text = [NSString stringWithFormat:@"%.3f", orderModel.amount];
//        //计划手续费
//        self.lab3.text = [NSString stringWithFormat:@"%.3f",orderModel.serviceCharge];
//        //计划类型
//        self.lab5.text = orderModel.des;
//        //计划执行时间
//        self.lab8.text = orderModel.executeTime;
//        //计划状态
//        self.lab6.text = [orderModel.status integerValue] == 1 ? @"待执行" :
//                                    [orderModel.status integerValue] == 2 ? @"还款中" :
//                                    [orderModel.status integerValue] == 3 ? @"已成功" :
//                                    [orderModel.status integerValue] == 4 ? @"已失败" :
//                                    [orderModel.status integerValue] == 5 ? @"已取消" : @"";
//            //失败原因或者计划描述
//        self.lab7.text = [self.lab6.text isEqualToString:@"已失败"] ?
//        [NSString stringWithFormat:@"失败原因:%@",orderModel.message] :
//        [NSString stringWithFormat:@"计划描述:%@",orderModel.city];
//    }else{
//        self.lab2.text = [NSString stringWithFormat:@"%.3f", orderModel.realAmount];
//        self.lab3.text = [NSString stringWithFormat:@"%.3f", orderModel.totalServiceCharge];
//        self.lab5.text = orderModel.typeName;
//        self.lab6.text = orderModel.taskStatusName;
//        self.lab8.text = orderModel.executeDateTime;
//        if ([self.lab6.text isEqualToString:@"已失败"]) {
//            self.lab7.text = [NSString stringWithFormat:@"失败原因:%@", orderModel.returnMessage];
//        } else {
//            self.lab7.text = [NSString stringWithFormat:@"计划描述:%@", orderModel.des];
//        }
//    }
//
//
//
    

    
    if ([self.lab6.text isEqualToString:@"已成功"]) {
        self.lab6.textColor = [UIColor qmui_colorWithHexString:@"#87dc5b"];
    } else if ([self.lab6.text isEqualToString:@"待执行"] || [self.lab6.text isEqualToString:@"待完成"]|| [self.lab6.text isEqualToString:@"执行中"] ) {
        self.lab6.textColor = [UIColor qmui_colorWithHexString:@"#ffc107"];
    } else if ([self.lab6.text isEqualToString:@"已失败"]) {
        self.lab6.textColor = [UIColor qmui_colorWithHexString:@"#ff5722"];
    } else if ([self.lab6.text isEqualToString:@"还款中"]) {
        self.lab6.textColor = [UIColor qmui_colorWithHexString:@"#ffc107"];
    }

}
@end
