//
//  KDShareHeaderView.h
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/8.
//  Copyright © 2020 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDShareHeaderView : UIView

@property (nonatomic, strong) NSDictionary *content;

@property (weak, nonatomic) IBOutlet UIView *tuiguangwuliaoView;
@property (weak, nonatomic) IBOutlet UIView *pingtaijieshaoView;
@property (weak, nonatomic) IBOutlet UIView *caozuoshuomingView;
@property (weak, nonatomic) IBOutlet UIView *weixinView;


@property (weak, nonatomic) IBOutlet UIImageView *fenxiangImv;
@property (weak, nonatomic) IBOutlet UIImageView *fatuImv;
@property (weak, nonatomic) IBOutlet UIImageView *shenghuobaikeImv;


@end

NS_ASSUME_NONNULL_END
