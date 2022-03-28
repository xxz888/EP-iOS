//
//  KDMineHeaderView.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/8.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDMineHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImv;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
- (void)getUserGradeName;
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UIView *kabaoView;
@property (weak, nonatomic) IBOutlet UIView *qianbaoView;
@property (weak, nonatomic) IBOutlet UIView *guanyuwomenView;
@property (weak, nonatomic) IBOutlet UIView *shezhiView;

@property (weak, nonatomic) IBOutlet UILabel *dianhua;

@property (weak, nonatomic) IBOutlet UIView *youhuiquanView;
@property (weak, nonatomic) IBOutlet UILabel *levelViwe;

@end

NS_ASSUME_NONNULL_END
