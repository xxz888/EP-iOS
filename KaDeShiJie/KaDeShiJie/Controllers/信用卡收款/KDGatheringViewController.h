//
//  KDGatheringViewController.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/11.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDGatheringViewController : MCBaseViewController
@property (nonatomic ,assign)NSInteger whereCome;//1刷卡 2闪付 3刷脸

@property (weak, nonatomic) IBOutlet UILabel *lbl1Tag;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2Tag;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *lbl3Tag;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UILabel *lbl4Tag;
@property (weak, nonatomic) IBOutlet UILabel *lbl4;



@end

NS_ASSUME_NONNULL_END
