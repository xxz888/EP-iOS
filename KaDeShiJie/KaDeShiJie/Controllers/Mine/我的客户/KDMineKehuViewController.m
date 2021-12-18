//
//  KDMineKehuViewController.m
//  KaDeShiJie
//
//  Created by mac on 2021/12/5.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDMineKehuViewController.h"

@interface KDMineKehuViewController ()

@end

@implementation KDMineKehuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F6F6F6"];
    [self setNavigationBarTitle:@"我的客户" tintColor:[UIColor whiteColor]];
    
    [self requestData];
}
-(void)requestData{
    __weak __typeof(self)weakSelf = self;
    NSString * url1 = @"/api/v1/player/user/recommendation";
    [self.sessionManager mc_GET:url1 parameters:nil ok:^(NSDictionary * _Nonnull resp) {
        if (resp[@"directCount"]) {
            weakSelf.zhituiLbl.text = [NSString stringWithFormat:@"%@",resp[@"directCount"]];
        }
        if (resp[@"indirectCount"]) {
            weakSelf.jianquanLbl.text =  [NSString stringWithFormat:@"%@",resp[@"indirectCount"]];

        }
    }];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
