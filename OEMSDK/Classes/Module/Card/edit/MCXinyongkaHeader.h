//
//  MCXinyongkaHeader.h
//  MCOEM
//
//  Created by wza on 2020/4/24.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBankCardModel.h"



NS_ASSUME_NONNULL_BEGIN

@interface MCXinyongkaHeader : UIView

@property(nonatomic, strong) MCBankCardModel *model;
@property (nonatomic ,strong)NSString * shimingName;
@property (nonatomic ,strong)NSString * shimingPhone;
@property (nonatomic ,strong)NSString * shimingIdCard;
-(void)setData;
@end

NS_ASSUME_NONNULL_END
