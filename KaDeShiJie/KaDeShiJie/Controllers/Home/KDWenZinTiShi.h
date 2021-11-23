//
//  KDWenZinTiShi.h
//  KaDeShiJie
//
//  Created by mac on 2021/11/22.
//  Copyright © 2021 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CloseActionBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface KDWenZinTiShi : UIView
@property(nonatomic,copy)CloseActionBlock closeActionBlock;
+ (instancetype)renZhengView;
@end

NS_ASSUME_NONNULL_END
