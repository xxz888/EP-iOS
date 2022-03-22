//
//  KDPayNewViewController.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/12.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDPayNewViewController : MCBaseViewController
//@property (nonatomic, strong) MCChannelModel *channelModel;
@property (nonatomic, strong) MCBankCardModel *cardModel;
@property (nonatomic, strong) MCBankCardModel *cardchuxuModel;
@property (nonatomic ,strong)NSString * amount;
@property (nonatomic, strong) NSString *money;
- (instancetype)initWithClassification:(MCBankCardModel *)cardModel;
@property (nonatomic ,strong)NSString * channelId;

@property (weak, nonatomic) IBOutlet UILabel *change2Lbl;

@property (weak, nonatomic) IBOutlet UIButton *change2Btn;

@property (weak, nonatomic) IBOutlet UILabel *change1TagLbl;
@property (weak, nonatomic) IBOutlet UILabel *change2TagLbl;
@property (nonatomic ,strong)NSString * channelBindId;
@property (nonatomic ,strong)NSString * orderId;

@property (nonatomic ,assign)NSInteger whereCome;//1刷卡 2闪付 3刷脸

@end

NS_ASSUME_NONNULL_END
