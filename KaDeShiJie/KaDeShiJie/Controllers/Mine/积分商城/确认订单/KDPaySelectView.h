//
//  KDPaySelectView.h
//  KaDeShiJie
//
//  Created by mac on 2022/1/8.
//  Copyright © 2022 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickPayBlock)(NSInteger);

NS_ASSUME_NONNULL_BEGIN

@interface KDPaySelectView : UIView
@property (weak, nonatomic) IBOutlet UIView *xinyongView;
@property (weak, nonatomic) IBOutlet UIView *zhuanzhangView;
-(void)showSelectView;

@property(nonatomic,copy)ClickPayBlock block;
@end

NS_ASSUME_NONNULL_END
