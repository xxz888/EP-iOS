//
//  MCChuxukaHeader.h
//  MCOEM
//
//  Created by wza on 2020/4/24.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBankCardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MCChuxukaHeader : UIView

@property(nonatomic, strong) MCBankCardModel *model;
@property (nonatomic, assign) BOOL loginVC;
@property (nonatomic, strong) NSString * whereCome;
@property (nonatomic ,strong)NSString * shimingName;
@property (nonatomic ,strong)NSString * shimingPhone;
@property (nonatomic ,strong)NSString * shimingIdCard;
-(void)setData;

@end

NS_ASSUME_NONNULL_END
