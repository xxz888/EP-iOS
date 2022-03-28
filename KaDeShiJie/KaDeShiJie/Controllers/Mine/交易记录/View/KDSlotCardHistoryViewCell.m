//
//  KDSlotCardHistoryViewCell.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/25.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDSlotCardHistoryViewCell.h"

@interface KDSlotCardHistoryViewCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end


@implementation KDSlotCardHistoryViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 10;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"slotcardhistory";
    KDSlotCardHistoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDSlotCardHistoryViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSlotHistoryModel:(KDSlotCardHistoryModel *)slotHistoryModel
{
    _slotHistoryModel = slotHistoryModel;
    
    
    MCBankCardInfo *info = [MCBankStore getBankCellInfoWithName:slotHistoryModel.creditCard[@"bankName"]];
    self.iconView.image = info.logo;
    NSString * no  = slotHistoryModel.creditCard[@"bankCardNo"];
    self.nameLabel.text = slotHistoryModel.creditCard[@"bankName"];
    self.cardNoLabel.text = [NSString stringWithFormat:@"(%@)", [no substringFromIndex:no.length - 4]];
    
    NSString *desStr = [NSString stringWithFormat:@"费率%.3f%%", slotHistoryModel.rate ];
    NSMutableAttributedString *attsDes = [[NSMutableAttributedString alloc] initWithString:desStr];
    NSRange range = [desStr rangeOfString:[NSString stringWithFormat:@"%.3f%%", slotHistoryModel.rate ]];
    [attsDes addAttribute:NSForegroundColorAttributeName value:[UIColor qmui_colorWithHexString:@"#F63802"] range:range];
    self.desLabel.attributedText = attsDes;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%.3f", slotHistoryModel.amount];
    self.timeLabel.text = slotHistoryModel.createdTime;

    
    //Close, Failed, Process, Successful, Unpaid
    if ([slotHistoryModel.state isEqualToString:@"Successful"]) {
        self.statusLabel.text = @"已成功";
        self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#87dc5b"];
    } else if ([slotHistoryModel.state isEqualToString:@"Failed"]) {
        self.statusLabel.text = @"已失败";
        self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#ff5722"];
    }  else if ([slotHistoryModel.state isEqualToString:@"Close"]) {
        self.statusLabel.text = @"已关闭";
        self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#ff5722"];
    } else if ([slotHistoryModel.state isEqualToString:@"Process"]) {
        self.statusLabel.text = @"待结算";
        self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#ffc107"];
    } else if ([slotHistoryModel.state isEqualToString:@"Unpaid"]) {
        self.statusLabel.text = @"支付中";
        self.statusLabel.textColor = [UIColor qmui_colorWithHexString:@"#ffc107"];
    }
    
}

@end
