//
//  KDSlotCardAisleViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDSlotCardAisleViewCell.h"
#import "KDAisleDetailViewController.h"

@interface KDSlotCardAisleViewCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab4;

@end

@implementation KDSlotCardAisleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 12;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SlotCardAisleViewCell";
    KDSlotCardAisleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDSlotCardAisleViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
// 查看限额
- (IBAction)clickCheckLimit:(id)sender {
    KDAisleDetailViewController *vc = [KDAisleDetailViewController new];
    vc.model = self.model;
    [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
}

- (void)setModel:(MCChannelModel *)model
{
    _model = model;
    
    self.nameLabel.text = model.title;//[NSString stringWithFormat:@"%@%@",model.name,model.channelParams];
    
    self.lab1.text = [NSString stringWithFormat:@"单笔限额：%@-%d", @"1", model.dailyMaxAmount.intValue];
    
//    NSString *startTime = [model.startTime substringWithRange:NSMakeRange(0, 5)];
//    NSString *endTime = [model.endTime substringWithRange:NSMakeRange(0, 5)];
    self.lab3.text = [NSString stringWithFormat:@"交易时间：%@-%@", model.tradeStartTime, model.tradeEndTime];
    
//    int maxLimit = model.everyDayMaxLimit.intValue;
    self.lab2.text = [NSString stringWithFormat:@"单日限额：¥%d", model.dailyMaxAmount.intValue];
    
    self.lab4.text = [NSString stringWithFormat:@"交易费率：%.2f%%+%@元/笔", model.tradeRate.floatValue / 100, @"2"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 115);
}
@end
