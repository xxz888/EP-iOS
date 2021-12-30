//
//  KDAisleDetailModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/14.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDAisleDetailModel : NSObject

@property (nonatomic, copy) NSString *channelTag;
@property (nonatomic, assign) CGFloat everyDayMaxLimit;
@property (nonatomic, assign) BOOL isDeleted;
@property (nonatomic, assign) CGFloat singleMaxLimit;
@property (nonatomic, assign) CGFloat singleMinLimit;
@property (nonatomic, copy) NSString *supportBankAll;
@property (nonatomic, copy) NSString *supportBankName;
@property (nonatomic, copy) NSString *supportBankType;
@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *bank;

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *channelType;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *dailyMaxAmount;
@property (nonatomic, copy) NSString *singeMaxAmount;
@property (nonatomic, copy) NSString *singeMinAmount;
@property (nonatomic, copy) NSString *createdTime;

@property (nonatomic, copy) NSString *bankName;

@end

NS_ASSUME_NONNULL_END
