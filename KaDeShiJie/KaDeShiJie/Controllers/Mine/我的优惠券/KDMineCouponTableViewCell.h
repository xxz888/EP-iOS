//
//  KDMineCouponTableViewCell.h
//  KaDeShiJie
//
//  Created by BH on 2021/12/30.
//  Copyright © 2021 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDMineCouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *yinyingView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *beizhuLbl;

@property (weak, nonatomic) IBOutlet UILabel *shouxufeiLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UILabel *shengyueLbl;

@end

NS_ASSUME_NONNULL_END
