//
//  GVUserDefaults+MCOEM.h
//  MCOEM
//
//  Created by wza on 2020/3/6.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "GVUserDefaults.h"

NS_ASSUME_NONNULL_BEGIN

/*
 需要保存 NSUserdefault 中可以用property形式写在这里，后续可以直接使用
 .h
 @property
 
 .m
 @dynamic
 
 **/

@interface GVUserDefaults (MCOEM)
@property(nonatomic, copy) NSString *phone;
@property(nonatomic, copy) NSString *nickname;
@property(nonatomic, copy) NSString *certification;
@property(nonatomic, copy) NSString *level;
@property(nonatomic, copy) NSString *receivePaymentRate;
@property(nonatomic, copy) NSString *agentId;
@property(nonatomic, copy) NSString *repaymentRate;
@property(nonatomic, copy) NSString *servicePhone;
@property(nonatomic, copy) NSString *wechat;

@property(nonatomic, copy) NSString *extraFee;

@property(nonatomic, copy) NSString *pwd;
@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy)  NSString *startHost;
@property(nonatomic, copy)  NSString *host;

@property(nonatomic, copy)  NSString *deviceid;

@property(nonatomic, assign) BOOL not_first_launch;
@property(nonatomic, assign) BOOL not_voice_notify;//语音播报
@property(nonatomic, assign) BOOL not_auto_logonin; //自动登录
@property(nonatomic, assign) BOOL not_rember_pwd; //记住密码
@property(nonatomic, copy)  NSString *hasPayPassword;

@property(nonatomic, copy)  NSDictionary * configDic;

@property(nonatomic, copy)  NSDictionary * registerProtocolLink;

@end

NS_ASSUME_NONNULL_END
