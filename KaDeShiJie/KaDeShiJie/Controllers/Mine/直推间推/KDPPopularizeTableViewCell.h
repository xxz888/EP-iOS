//
//  KDPPopularizeTableViewCell.h
//  KaDeShiJie
//
//  Created by mac on 2021/12/18.
//  Copyright © 2021 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDPPopularizeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImv;
@property (weak, nonatomic) IBOutlet UILabel *cellStatus;
@property (weak, nonatomic) IBOutlet UILabel *cellPhone;
@property (weak, nonatomic) IBOutlet UILabel *cellTime;
@property (weak, nonatomic) IBOutlet UILabel *cellUserLlb;
@property (weak, nonatomic) IBOutlet UIImageView *cellRenSheng;

@end

NS_ASSUME_NONNULL_END
