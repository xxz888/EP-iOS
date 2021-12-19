//
//  KDPPopularizeTableViewCell.m
//  KaDeShiJie
//
//  Created by mac on 2021/12/18.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDPPopularizeTableViewCell.h"

@implementation KDPPopularizeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setCustomCorners:self.cellUserLlb];
}
-(void)setCustomCorners:(UIView *)view{

UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10,10)];

CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];

maskLayer.frame = view.bounds;

maskLayer.path = maskPath.CGPath;

view.layer.mask = maskLayer;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
