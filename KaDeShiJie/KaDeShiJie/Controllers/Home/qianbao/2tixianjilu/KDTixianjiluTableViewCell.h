//
//  KDTixianjiluTableViewCell.h
//  KaDeShiJie
//
//  Created by mac on 2021/11/24.
//  Copyright © 2021 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDTixianjiluTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *eventTag;
@property (weak, nonatomic) IBOutlet UILabel *eventPrice;
@property (weak, nonatomic) IBOutlet UILabel *eventTime;
@property (weak, nonatomic) IBOutlet UILabel *eventStatus;

@end

NS_ASSUME_NONNULL_END
