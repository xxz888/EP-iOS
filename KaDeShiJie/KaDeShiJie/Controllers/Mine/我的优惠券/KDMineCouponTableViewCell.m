//
//  KDMineCouponTableViewCell.m
//  KaDeShiJie
//
//  Created by BH on 2021/12/30.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDMineCouponTableViewCell.h"

@implementation KDMineCouponTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"KDMineCouponTableViewCell";
    KDMineCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KDMineCouponTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
//    [self shadowViewWithCorner];
}
-(void)shadowViewWithCorner{

    self.yinyingView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.yinyingView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.06].CGColor;
    self.yinyingView.layer.shadowOffset = CGSizeMake(0,0);
    self.yinyingView.layer.shadowOpacity = 1;
    self.yinyingView.layer.shadowRadius = 3;
    self.yinyingView.layer.cornerRadius = 6.7;
    
    
    
    
    
    
    
    
    
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
