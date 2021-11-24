//
//  KDMyWallView.m
//  KaDeShiJie
//
//  Created by BH on 2021/11/24.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDMyWallView.h"

@implementation KDMyWallView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDMyWallView" owner:nil options:nil] firstObject];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTixiantView:)];
    [self.tixianView addGestureRecognizer:tap];
    
    
    UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickzhifushouyiView:)];
    [self.zhifushouyiView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickjianglishouyiView:)];
    [self.jianglishouyiView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer* tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickqianbaomingxiView:)];
    [self.qianbaomingxiView addGestureRecognizer:tap3];
}

-(void)clickTixiantView:(id)tap{
    
}
-(void)clickzhifushouyiView:(id)tap{
    
}
-(void)clickjianglishouyiView:(id)tap{
    
}
-(void)clickqianbaomingxiView:(id)tap{
    
}
@end
