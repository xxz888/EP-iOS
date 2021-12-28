//
//  KDJFShopDetailHeaderView.h
//  KaDeShiJie
//
//  Created by apple on 2021/6/8.
//  Copyright © 2021 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDJFShopDetailHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *detailImv;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UILabel *detailPrice;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle1;
@property (weak, nonatomic) IBOutlet UILabel *detailDaiJin;
@property (weak, nonatomic) IBOutlet UILabel *detailKuCun;
@property (weak, nonatomic) IBOutlet UIView *luboView;
@property(nonatomic,strong)NSDictionary * goodDic;
-(void)setData;

@end

NS_ASSUME_NONNULL_END
