//
//  KDJFAdressListViewController.h
//  KaDeShiJie
//
//  Created by apple on 2021/6/15.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "MCBaseViewController.h"
typedef void (^SelectAddressBlock)(NSDictionary *);
NS_ASSUME_NONNULL_BEGIN

@interface KDJFAdressListViewController : MCBaseViewController
@property (nonatomic ,copy)SelectAddressBlock block;
@end

NS_ASSUME_NONNULL_END
