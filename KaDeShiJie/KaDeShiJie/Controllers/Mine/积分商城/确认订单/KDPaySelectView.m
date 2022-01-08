//
//  KDPaySelectView.m
//  KaDeShiJie
//
//  Created by mac on 2022/1/8.
//  Copyright © 2022 SS001. All rights reserved.
//

#import "KDPaySelectView.h"
#import "STModal.h"
@interface KDPaySelectView ()

@property (nonatomic, strong) STModal *modal;


@end
@implementation KDPaySelectView
- (STModal *)modal {
    if (!_modal) {
        _modal = [STModal modal];
        _modal.dimBackgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _modal;
}
- (IBAction)closeActon:(id)sender {
    [self.modal hide:YES];
}
-(void)showSelectView{
    
    
    self.modal.hideWhenTouchOutside = NO;
    [self.modal showContentView:self animated:YES];
}
- (void)drawRect:(CGRect)rect {

    
    //添加手势
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickXinyongView:)];
    [self.xinyongView addGestureRecognizer:tap];
    
    UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickzhuanzhangView:)];
    [self.zhuanzhangView addGestureRecognizer:tap1];
}
-(void)clickXinyongView:(id)tap{
    [self.modal hide:YES];

    if (self.block) {
        self.block(1);
    }
}
-(void)clickzhuanzhangView:(id)tap{
    [self.modal hide:YES];

    if (self.block) {
        self.block(2);
    }
}

@end
