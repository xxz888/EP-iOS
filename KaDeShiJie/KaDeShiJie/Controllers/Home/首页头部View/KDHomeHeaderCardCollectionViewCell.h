//
//  KDHomeHeaderCardCollectionViewCell.h
//  KaDeShiJie
//
//  Created by BH on 2022/3/10.
//  Copyright © 2022 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDHomeHeaderCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *collImv;
@property (weak, nonatomic) IBOutlet UILabel *collTitle;
@property (weak, nonatomic) IBOutlet UILabel *collPrice;
@property (weak, nonatomic) IBOutlet UILabel *cellContent;
@end

NS_ASSUME_NONNULL_END
