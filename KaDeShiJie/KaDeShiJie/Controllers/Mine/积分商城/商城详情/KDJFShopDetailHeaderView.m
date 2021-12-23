//
//  KDJFShopDetailHeaderView.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/8.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJFShopDetailHeaderView.h"
@interface KDJFShopDetailHeaderView()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cyView;
@end
@implementation KDJFShopDetailHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDJFShopDetailHeaderView"
                                              owner:nil
                                            options:nil] lastObject];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    SDCycleScrollView *cyView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 417)];
    cyView.layer.cornerRadius = 7;
    cyView.delegate = self;
    cyView.backgroundColor = [UIColor clearColor];
    cyView.showPageControl = YES;
    cyView.clipsToBounds = YES;
    [cyView disableScrollGesture];
    self.cyView.localizationImageNamesGroup = self.goodDic[@"images"];
    cyView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.luboView addSubview:cyView];
}
@end
