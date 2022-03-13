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
@property (weak, nonatomic) IBOutlet UIButton *persionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *banner2Imv;
@property (weak, nonatomic) IBOutlet UIView *four1View;
@property (weak, nonatomic) IBOutlet UIView *four2View;
@property (weak, nonatomic) IBOutlet UIView *four3View;
@property (weak, nonatomic) IBOutlet UIView *four4View;
@property (nonatomic, strong) SDCycleScrollView *cyView;

@end

NS_ASSUME_NONNULL_END
