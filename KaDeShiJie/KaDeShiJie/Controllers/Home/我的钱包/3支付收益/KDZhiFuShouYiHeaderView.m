//
//  KDZhiFuShouYiHeaderView.m
//  KaDeShiJie
//
//  Created by mac on 2021/11/25.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDZhiFuShouYiHeaderView.h"

@implementation KDZhiFuShouYiHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDZhiFuShouYiHeaderView" owner:nil options:nil] firstObject];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
