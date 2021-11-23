//
//  KDRenZhengView.m
//  KaDeShiJie
//
//  Created by mac on 2021/11/22.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDRenZhengView.h"

@implementation KDRenZhengView
+ (instancetype)renZhengView {
    KDRenZhengView *view = [[[NSBundle mainBundle] loadNibNamed:@"KDRenZhengView" owner:nil options:nil] lastObject];
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)closeAction:(id)sender {
    self.closeActionBlock();
}
- (IBAction)querenAction:(id)sender {
    self.quedingBtnActionBlock();
}
- (IBAction)cancelAction:(id)sender {
    self.closeActionBlock1();
}

@end
