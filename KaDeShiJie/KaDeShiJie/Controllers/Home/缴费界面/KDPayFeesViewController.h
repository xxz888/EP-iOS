//
//  KDPayFeesViewController.h
//  KaDeShiJie
//
//  Created by BH on 2022/3/17.
//  Copyright © 2022 SS001. All rights reserved.
//

#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDPayFeesViewController : MCBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *danweiLbl;
@property (weak, nonatomic) IBOutlet UILabel *xiangmuLbl;
@property (weak, nonatomic) IBOutlet UIButton *fenzuBtn;
@property (weak, nonatomic) IBOutlet UITextField *bianhaoTf;
@property (nonatomic ,assign)NSInteger tag;
@end

NS_ASSUME_NONNULL_END
