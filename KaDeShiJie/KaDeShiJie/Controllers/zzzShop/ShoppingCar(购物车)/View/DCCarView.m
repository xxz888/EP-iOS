//
//  DCCarView.m
//  KaDeShiJie
//
//  Created by BH on 2022/3/24.
//  Copyright © 2022 SS001. All rights reserved.
//

#import "DCCarView.h"

@implementation DCCarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"DCCarView" owner:nil options:nil] firstObject];
    }
    return self;
}

@end
