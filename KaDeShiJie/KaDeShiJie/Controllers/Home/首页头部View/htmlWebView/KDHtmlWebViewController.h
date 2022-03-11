//
//  KDHtmlWebViewController.h
//  KaDeShiJie
//
//  Created by BH on 2022/3/11.
//  Copyright © 2022 SS001. All rights reserved.
//

#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDHtmlWebViewController : MCBaseViewController
@property(nonatomic, copy) NSString *content;

@property (nonatomic, strong) NSString *classifty;
@property(nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
