//
//  KDTotalOrderModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/25.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDTotalOrderModel : NSObject

/** eg. 2020-09-30 */
@property (nonatomic, copy) NSString *executeDate;
@property (nonatomic, copy) NSString *executeTime;
@property (nonatomic, copy) NSString *status;

/** eg. 0 */
@property (nonatomic, copy) NSString *orderCode;
/** eg. taskId */
@property (nonatomic, copy) NSString *taskId;
/** eg. description */
@property (nonatomic, copy) NSString *des;

/** eg. 334.12 */
@property (nonatomic, assign) CGFloat amount;
/** eg. 0 */
@property (nonatomic, assign) CGFloat totalServiceCharge;
/** eg. executeDateTime */
@property (nonatomic, copy) NSString *executeDateTime;
/** eg. 3.88 */
@property (nonatomic, assign) CGFloat serviceCharge;
/** eg. creditCardNumber */
@property (nonatomic, copy) NSString *creditCardNumber;
/** eg. createTime */
@property (nonatomic, copy) NSString *createTime;
/** eg. 0 */
@property (nonatomic, assign) NSInteger orderStatus;
/** eg. 338 */
@property (nonatomic, assign) CGFloat realAmount;
/** eg.  */
@property (nonatomic, copy) NSString *channelName;
/** eg. 0 */
@property (nonatomic, assign) NSInteger taskStatus;
/** eg. 99-7 */
@property (nonatomic, copy) NSString *version;
/** eg.  */
@property (nonatomic, copy) NSString *returnMessage;
/** eg. 2 */
@property (nonatomic, assign) NSInteger taskType;
/** eg. 0 */
@property (nonatomic, assign) CGFloat rate;
/** eg. 100 */
@property (nonatomic, copy) NSString *brandId;
/** eg. userId */
@property (nonatomic, copy) NSString *userId;
/** eg. 10 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *taskStatusName;
@property (nonatomic, copy) NSString *typeName;
/** 是否显示小点 */
@property (nonatomic, assign) BOOL isShowPoint;

@property (nonatomic, strong) NSString * balancePlanId;//新的和老的区别
@property (nonatomic, strong) NSString * city;
@property (nonatomic, copy) NSString *message;



@property (nonatomic, strong) NSString * planTaskType;


//planId = 82,
//actualFee = 30.55,
//status = Padding,
//creditCardId = 15,
//amount = 3867,
//cardBalance = 5021,
//surplusFee = 0.45,
//planTaskId = 2021121115083773103204,
//creditCardNo = 222222222222222,
//executeTime = 2021-12-11T13:30:00,
//channelCityId = 0,
//name = Wangpei1,
//channelType = JiaFuTong,
//createdTime = 2021-12-11T15:08:37,
//id = 689,
//cityId = 2900,
//executeFailCount = 0,
//fee = 31,
//reservedPhone = 13383773802,
//memberId = 24,
//planTaskType = Consumption,
//channelId = 4
@property (nonatomic, strong) NSString * planId;
@property (nonatomic, strong) NSString * actualFee;
@property (nonatomic, strong) NSString * surplusFee;
@property (nonatomic, strong) NSString * creditCardId;
@property (nonatomic, strong) NSString * planTaskId;
@property (nonatomic, strong) NSString * creditCardNo;
@property (nonatomic, strong) NSString * channelCityId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * channelType;
@property (nonatomic, strong) NSString * createdTime;
@property (nonatomic, strong) NSString * cityId;
@property (nonatomic, strong) NSString * executeFailCount;
@property (nonatomic, strong) NSString * fee;
@property (nonatomic, strong) NSString * reservedPhone;
@property (nonatomic, strong) NSString * memberId;
@property (nonatomic, strong) NSString * channelId;

@end

NS_ASSUME_NONNULL_END
