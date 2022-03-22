//
//  KDMyWallView.h
//  KaDeShiJie
//
//  Created by BH on 2021/11/24.
//  Copyright © 2021 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDMyWallView : UIView
- (instancetype)initWithFrame:(CGRect)frame;
@property (weak, nonatomic) IBOutlet UIView *tixianView;
@property (weak, nonatomic) IBOutlet UIView *zhifushouyiView;
@property (weak, nonatomic) IBOutlet UIView *jianglishouyiView;
@property (weak, nonatomic) IBOutlet UIView *qianbaomingxiView;
@property (weak, nonatomic) IBOutlet UILabel *dangqianshouru;
@property (weak, nonatomic) IBOutlet UILabel *lishitixian;
@property (weak, nonatomic) IBOutlet UILabel *ketixian;

-(void)setDataDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
