//
//  KDTiXianViewController.h
//  KaDeShiJie
//
//  Created by BH on 2021/11/24.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "MCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDTiXianViewController : MCBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *zhanghuyue;
@property (weak, nonatomic) IBOutlet UILabel *ketixianjine;
@property (weak, nonatomic) IBOutlet UITextField *inputPrice;
@property (weak, nonatomic) IBOutlet UILabel *bankLbl;
- (IBAction)tixianAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bankLogo;
@property (nonatomic ,strong)NSDictionary * startDic;
@end

NS_ASSUME_NONNULL_END
