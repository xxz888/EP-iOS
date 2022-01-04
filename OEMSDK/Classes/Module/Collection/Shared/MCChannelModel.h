//
//  MCChannelModel.h
//  MCOEM
//
//  Created by wza on 2020/5/5.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCChannelModel : NSObject

@property (nonatomic, copy) NSString *singleMaxLimit;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *withdrawFee;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSString *subName;
@property (nonatomic, copy) NSString *channelParams;
@property (nonatomic, copy) NSString *channelNo;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *everyDayMaxLimit;
@property (nonatomic, copy) NSString *singleMinLimit;
@property (nonatomic, copy) NSString *channelType;
@property (nonatomic, copy) NSString *log;
@property (nonatomic, copy) NSString *costRate;
@property (nonatomic, copy) NSString *extraFee;
@property (nonatomic, copy) NSString *paymentStatus;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *channelTag;
@property (nonatomic, copy) NSString *autoclearing;
@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *tradeRate;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *tradeStartTime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *dailyMaxAmount;
@property (nonatomic, copy) NSString *tradeEndTime;
@property (nonatomic, copy) NSString *extraRate;

@property (nonatomic, copy) NSString *singeMinAmount;
@property (nonatomic, copy) NSString *singeMaxAmount;



//channelType = JiaFuTong,
//channelId = 4,
//tradeStartTime = 06:00,
//rate = 0.62,
//title = 佳付通,
//dailyMaxAmount = 50000,
//bind = 0,
//tradeEndTime = 22:00,
//fee = 6.2
@end

NS_ASSUME_NONNULL_END
