//
//  DCCarView.h
//  KaDeShiJie
//
//  Created by BH on 2022/3/24.
//  Copyright © 2022 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCCarView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *titleImv;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *titlePrice;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end

NS_ASSUME_NONNULL_END
