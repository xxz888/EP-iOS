//
//  KDGuanFangSheQun.m
//  KaDeShiJie
//
//  Created by BH on 2021/10/19.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDGuanFangSheQun.h"

@implementation KDGuanFangSheQun


- (void)drawRect:(CGRect)rect {
    self.wxHaoMaLbl.text = SharedDefaults.wechat;
}


- (IBAction)zhidaoleAction:(id)sender {
    if (self.block) {
        self.block();
    }
}
@end
