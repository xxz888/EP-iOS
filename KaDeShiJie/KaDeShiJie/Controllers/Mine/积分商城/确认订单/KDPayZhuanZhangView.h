//
//  KDPayZhuanZhangView.h
//  KaDeShiJie
//
//  Created by mac on 2022/1/8.
//  Copyright © 2022 SS001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDPayZhuanZhangView : UIView
@property (weak, nonatomic) IBOutlet UILabel *zhanghuLbl;
@property (weak, nonatomic) IBOutlet UILabel *kahaoLbl;
@property (weak, nonatomic) IBOutlet UILabel *kaihuhangLbl;
- (IBAction)fuzhiAction:(id)sender;
-(void)showzhuanzhangView:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
