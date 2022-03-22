//
//  KDXinYongKaCollectionViewCell.h
//  KaDeShiJie
//
//  Created by apple on 2021/6/8.
//  Copyright © 2021 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDXinYongKaCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *collImv;
@property (weak, nonatomic) IBOutlet UILabel *collTitle;
@property (weak, nonatomic) IBOutlet UILabel *collPrice;
@property (weak, nonatomic) IBOutlet UILabel *cellContent;

@end

NS_ASSUME_NONNULL_END
