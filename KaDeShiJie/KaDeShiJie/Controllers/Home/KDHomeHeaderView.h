//
//  KDHomeHeaderView.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/5.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDHomeHeaderView : UIView

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy) void (^callBack)(CGFloat viewHig);
- (IBAction)btnAction:(QMUIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bangkaView;
@property (weak, nonatomic) IBOutlet UIButton *moreCard;

@end

NS_ASSUME_NONNULL_END
