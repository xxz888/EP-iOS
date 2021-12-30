//
//  KDWenZinTiShi.m
//  KaDeShiJie
//
//  Created by mac on 2021/11/22.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDWenZinTiShi.h"

@implementation KDWenZinTiShi
+ (instancetype)renZhengView {
    KDWenZinTiShi *view = [[[NSBundle mainBundle] loadNibNamed:@"KDWenZinTiShi" owner:nil options:nil] lastObject];
    
    return view;
}
-(void)setData{
    self.title.text = self.titleString;
    self.content.text = self.contentString;
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

@end
