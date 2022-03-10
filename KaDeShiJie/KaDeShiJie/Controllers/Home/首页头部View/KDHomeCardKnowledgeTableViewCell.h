//
//  KDHomeCardKnowledgeTableViewCell.h
//  KaDeShiJie
//
//  Created by BH on 2022/3/10.
//  Copyright © 2022 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDHomeCardKnowledgeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImv;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellContent;
@property (weak, nonatomic) IBOutlet UILabel *cellTime;

@end

NS_ASSUME_NONNULL_END
