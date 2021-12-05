//
//  KDDirectRefundModel.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDDirectRefundModel.h"

@implementation KDDirectRefundModel

+ (NSDictionary *)mj_objectClassInArray
{
     return @{
              @"repaymentBill" : KDRepaymentBillModel.class,
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
     return @{
              @"itemId" : @"id",
              @"bankName":@"bank",
              @"repaymentDay":@"repaymentDate",
              @"billDay":@"billingDate",
              @"cardNo":@"bankCardNo"
             };
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    if([key isEqualToString:@"bank"])
        self.bankName = value;
    
    if([key isEqualToString:@"bankCardNo"])
        self.cardNo = value;
    
    if([key isEqualToString:@"repaymentDate"])
        self.repaymentDay = [value integerValue];
    
    if([key isEqualToString:@"billingDate"])
        self.billDay = [value integerValue];
}


@end
