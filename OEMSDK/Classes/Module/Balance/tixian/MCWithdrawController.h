//
//  MCWithdrawController.h
//  MCOEM
//
//  Created by wza on 2020/5/8.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface MCWithdrawController : MCBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *zhanghuyue;
@property (weak, nonatomic) IBOutlet UILabel *ketixianjine;
@property (weak, nonatomic) IBOutlet UITextField *inputPrice;
@property (weak, nonatomic) IBOutlet UILabel *bankLbl;
- (IBAction)tixianAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bankLogo;
@property (nonatomic ,strong)NSDictionary * startDic;

@end

NS_ASSUME_NONNULL_END
