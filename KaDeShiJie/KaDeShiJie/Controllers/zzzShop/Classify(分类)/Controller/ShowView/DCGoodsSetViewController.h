//
//  DCGoodsSetViewController.h
//  CDDMall
//
//  Created by apple on 2017/6/12.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCCalssSubItem.h"
@interface DCGoodsSetViewController : UIViewController

/* plist数据 */
@property (strong , nonatomic)NSString *goodPlisName;

@property (nonatomic ,strong)DCCalssSubItem * calssSubItem;
@end
