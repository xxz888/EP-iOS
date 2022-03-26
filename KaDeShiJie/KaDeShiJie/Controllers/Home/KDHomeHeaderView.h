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
@property (weak, nonatomic) IBOutlet UIStackView *hidden1View;
@property (weak, nonatomic) IBOutlet UIImageView *hidden2View;
@property (weak, nonatomic) IBOutlet MCBannerView *hidden3View;
@property (weak, nonatomic) IBOutlet UIView *hidden4View;
@property (weak, nonatomic) IBOutlet UIView *hidden5View;
@property (weak, nonatomic) IBOutlet UIImageView *hidden6View;
@property (weak, nonatomic) IBOutlet UIView *hidden7View;
- (IBAction)moreAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
