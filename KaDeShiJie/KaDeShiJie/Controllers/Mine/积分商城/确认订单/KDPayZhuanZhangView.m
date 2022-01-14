//
//  KDPayZhuanZhangView.m
//  KaDeShiJie
//
//  Created by mac on 2022/1/8.
//  Copyright © 2022 SS001. All rights reserved.
//

#import "KDPayZhuanZhangView.h"
#import "STModal.h"
@interface KDPayZhuanZhangView ()

@property (nonatomic, strong) STModal *modal;
@property (nonatomic, strong) NSString * kahao;

@end
@implementation KDPayZhuanZhangView
- (STModal *)modal {
    if (!_modal) {
        _modal = [STModal modal];
        _modal.dimBackgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _modal;
}







































































-(void)showzhuanzhangView:(NSDictionary *)dic{
    self.kahao =dic[@"debitCard"][@"account"];
    self.zhanghuLbl.text = dic[@"debitCard"][@"name"];
    self.kahaoLbl.text = dic[@"debitCard"][@"account"];
    self.kaihuhangLbl.text = dic[@"debitCard"][@"subBank"];

    
    self.modal.hideWhenTouchOutside = NO;
    [self.modal showContentView:self animated:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)closeAction:(id)sender {
    [self.modal hide:YES];

}

- (IBAction)fuzhiAction:(id)sender {
    UIPasteboard.generalPasteboard.string = self.kahao;
    [MCToast showMessage:@"卡号已复制到剪切板"];
}
@end
