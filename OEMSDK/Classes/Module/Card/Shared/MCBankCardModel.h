//
//  MCBankCardModel.h
//  MCOEM
//
//  Created by wza on 2020/4/24.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCBankCardModel : NSObject

@property (nonatomic, strong) NSString *nature; // 借记卡 、 贷记卡
@property (nonatomic, strong) NSString *cardType; // 银行卡名称
@property (nonatomic, strong) NSString *state; //
@property (nonatomic, strong) NSString *type; // 2: 收款卡 0 充值卡
@property (nonatomic, strong) NSString *expiredTime; // 有效期
@property (nonatomic, strong) NSString *phone; // 手机号
@property (nonatomic, strong) NSString *securityCode; // 安全码
@property (nonatomic, strong) NSString *bankName; // 银行名称
@property (nonatomic, strong) NSString *cardNo; // 银行卡号
@property (nonatomic, strong) NSString *userName; // 用户名
@property (nonatomic, assign) BOOL idDef; // 是否是默认卡
@property (nonatomic, strong) NSString *useState;
@property (nonatomic, copy) NSString *priOrPub;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *bankBranchName;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *bankBrand;
@property (nonatomic, copy) NSString *idcard;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *userId;
/** 本地银行卡logo */
@property (nonatomic, copy) NSString *localCardLogo;

/**
 还款日
 */
@property (nonatomic, assign) NSInteger repaymentDay;

/**
 账单日
 */
@property (nonatomic, assign) NSInteger billDay;
/// 额度
@property(nonatomic, copy) NSString *creditBlance;

//记录展开
@property(nonatomic, assign) BOOL isExpand;

@property (nonatomic, strong) NSString * orderCode; // 生成的单号
@property (nonatomic, strong) NSString * jumpWhereVC; // 跳转到交易还是跳转到绑定
@property (nonatomic, strong) NSString * money;          // 收款确认金额
@property (nonatomic, strong) NSString * channelTag;   // 哪个通道
@property (nonatomic, strong) NSString * rate;
@property (nonatomic, strong) NSString * extraFee;
@property (nonatomic, strong) NSString * api;
@property (nonatomic, strong) NSString * bank;
@property (nonatomic, copy) NSString * id;

@property (nonatomic, strong) NSString * dbankbankCard;
@property (nonatomic, strong) NSString * dbankName;
@property (nonatomic, strong) NSString * dphone;
@property (nonatomic, strong) NSString * dbankCard;


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
@property (nonatomic, strong) NSString * repaymentDate;
@property (nonatomic, strong) NSString * memberId;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * billingDate;
@property (nonatomic, strong) NSString * modifyTime;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * bankCardNo;
@property (nonatomic, strong) NSString * cvc;

@property (nonatomic, strong) NSString * planId;
@property (nonatomic, strong) NSString * planStatus;
@property (nonatomic, strong) NSString * repaymentAmount;
@property (nonatomic, strong) NSString * alreadyRepaymentAmount;
@property (nonatomic, strong) NSString * createdTime;

@end

NS_ASSUME_NONNULL_END
