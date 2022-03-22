//
//  KDPlanTopViewCell.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/24.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBankCardModel.h"

@protocol KDPlanTopViewCellDelegate <NSObject>

- (void)topCellDelegateWithEditCard;

@end

NS_ASSUME_NONNULL_BEGIN

@interface KDPlanTopViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) MCBankCardModel *directModel;
@property (nonatomic, weak) id<KDPlanTopViewCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
