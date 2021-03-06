//
//  KDRepaymentModel.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/25.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDRepaymentModel : NSObject

/** eg. 0 */
@property (nonatomic, assign) NSInteger isClosed;
/** eg. userId */
@property (nonatomic, copy) NSString *userId;
/** eg. 23.25 */
@property (nonatomic, assign) CGFloat totalServiceCharge;
/** eg. 0 */
@property (nonatomic, assign) NSInteger taskStatus;

@property (nonatomic, assign) NSInteger status;

/** <#泛型#> */
@property (nonatomic, strong) NSString *channelName;
/** eg. creditCardNumber */
@property (nonatomic, copy) NSString *creditCardNumber;
/** eg. 99-7 */
@property (nonatomic, copy) NSString *version;
/** eg. selectCity */
@property (nonatomic, copy) NSString *selectCity;
/** eg. 0 */
@property (nonatomic, assign) NSInteger repaymentedCount;
/** eg. 0 */
@property (nonatomic, assign) CGFloat repaymentedAmount;
/** eg. 0 */
@property (nonatomic, assign) NSInteger type;
/** eg. 18520149705 */
@property (nonatomic, copy) NSString *bankPhone;
/** eg. 6 */
@property (nonatomic, assign) NSInteger taskCount;
/** eg. 0 */
@property (nonatomic, assign) CGFloat consumedAmount;
/** eg. 1 */
@property (nonatomic, assign) NSInteger isCanDelete;
/** eg. 0 */
@property (nonatomic, assign) NSInteger isAutoConsume;
/** eg. 18520149705 */
@property (nonatomic, copy) NSString *phone;
/** <#泛型#> */
@property (nonatomic, strong) NSString *startDate;
/** eg. 0 */
@property (nonatomic, assign) NSInteger difference;
/** eg.  */
@property (nonatomic, copy) NSString *couponId;
/** eg. 罗勇 */
@property (nonatomic, copy) NSString *userName;
/** eg. 广发银行 */
@property (nonatomic, copy) NSString *bankName;
/** eg. lastExecuteDateTime */
@property (nonatomic, copy) NSString *lastExecuteDateTime;
/** eg. 100 */
@property (nonatomic, copy) NSString *brandId;
/** eg. 0 */
@property (nonatomic, assign) NSInteger autoRepayment;
/** eg. rate */
@property (nonatomic, assign) CGFloat rate;
/** eg. 396 */
@property (nonatomic, assign) CGFloat reservedAmount;
/** eg. 0 */
@property (nonatomic, assign) CGFloat usedCharge;
/** eg. 1 */
@property (nonatomic, assign) CGFloat serviceCharge;
/** eg. 2000 */
@property (nonatomic, assign) CGFloat taskAmount;
/** <#泛型#> */
@property (nonatomic, strong) NSString *repaymentDate;
/** eg. 0 */
@property (nonatomic, assign) CGFloat taskConsumeAmount;
/** <#泛型#> */
@property (nonatomic, strong) NSString *executeDates;
/** eg. 0 */
@property (nonatomic, assign) NSInteger repaymentedSuccessCount;
/** <#泛型#> */
@property (nonatomic, strong) NSString *orderCode;
/** eg. 3778966 */
@property (nonatomic, strong) NSString * itemId;
/** eg. createTime */
@property (nonatomic, copy) NSString *createTime;
/** eg. 2000 */
@property (nonatomic, assign) CGFloat oldTaskAmount;

@property (nonatomic, copy) NSString *statusName;
@property (nonatomic, copy) NSString *statuskongkaName;
@property (nonatomic, copy) NSString *statuskongkaColor;



@property (nonatomic, assign) NSInteger orderType;
@property (nonatomic, copy) NSString * balance;




//id = 15,
//cityId = 6040,
//validPeriod = 09/22,
//phone = 13383773802,
//repaymentDate = 2,
//bankName = 中国建设银行,
//createdTime = 2021-12-10T13:26:37,
//province = 广东省,
//cvc = 333,
//memberId = 24,
//cardType = CreditCard,
//city = 潮州市,
//billingDate = 2,
//modifyTime = 2021-12-10T13:26:37,
//provinceId = 5800,
//bankId = 3,
//name = Wangpei1,
//bankCardNo = 222222222222222
@property (nonatomic, strong) NSString * validPeriod;
@property (nonatomic, strong) NSString * memberId;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * billingDate;
@property (nonatomic, strong) NSString * modifyTime;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * bankCardNo;
@property (nonatomic, strong) NSString * cvc;

@end

NS_ASSUME_NONNULL_END
