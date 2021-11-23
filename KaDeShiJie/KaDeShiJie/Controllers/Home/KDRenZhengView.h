//
//  KDRenZhengView.h
//  KaDeShiJie
//
//  Created by mac on 2021/11/22.
//  Copyright © 2021 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CloseActionBlock)(void);
typedef void(^QuedingBtnActionBlock)(void);
typedef void(^QvxiaoBtnActionBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface KDRenZhengView : UIView
+ (instancetype)renZhengView;
@property(nonatomic,copy)CloseActionBlock closeActionBlock;
@property(nonatomic,copy)QuedingBtnActionBlock quedingBtnActionBlock;
@property(nonatomic,copy)QvxiaoBtnActionBlock closeActionBlock1;
@end

NS_ASSUME_NONNULL_END
