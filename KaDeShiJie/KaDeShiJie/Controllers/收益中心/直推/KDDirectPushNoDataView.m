//
//  KDDirectPushNoDataView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/10.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDDirectPushNoDataView.h"

@interface KDDirectPushNoDataView ()
@property (weak, nonatomic) IBOutlet UIButton *pushBtn;

@end

@implementation KDDirectPushNoDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDDirectPushNoDataView" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // gradient

}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, (SCREEN_HEIGHT - 274) * 0.6, SCREEN_WIDTH, 274);
}

/** 立即推广 */
- (IBAction)directPushAction:(UIButton *)sender {
    [MCPagingStore pagingURL:rt_share_single];
}

@end
