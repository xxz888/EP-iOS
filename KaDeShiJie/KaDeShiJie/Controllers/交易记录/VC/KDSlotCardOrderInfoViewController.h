//
//  KDSlotCardOrderInfoViewController.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/25.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "MCBaseViewController.h"
#import "KDSlotCardHistoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDSlotCardOrderInfoViewController : MCBaseViewController
@property (nonatomic, strong) KDSlotCardHistoryModel *slotHistoryModel;
- (instancetype)initWithClassification:(NSDictionary *)slotHistoryDic;
@property (weak, nonatomic) IBOutlet UIView *juhuaView;
@property (nonatomic, assign) BOOL isBackHomeVC;

@end

NS_ASSUME_NONNULL_END
