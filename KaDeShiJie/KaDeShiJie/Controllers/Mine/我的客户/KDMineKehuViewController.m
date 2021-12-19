//
//  KDMineKehuViewController.m
//  KaDeShiJie
//
//  Created by mac on 2021/12/5.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDMineKehuViewController.h"
#import "KDPopularizeViewController.h"
#import "UIView+Extension.h"
@interface KDMineKehuViewController ()
@property (weak, nonatomic) IBOutlet UIView *zhituiView;
@property (weak, nonatomic) IBOutlet UIView *jiantuiView;

@end

@implementation KDMineKehuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F6F6F6"];
    [self setNavigationBarTitle:@"我的客户" tintColor:[UIColor whiteColor]];
    [self.zhituiView rf_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
        KDPopularizeViewController * vc = [[KDPopularizeViewController alloc]init];
        vc.whereCome = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.jiantuiView rf_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
        KDPopularizeViewController * vc = [[KDPopularizeViewController alloc]init];
        vc.whereCome = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self requestData];
}
-(void)requestData{
    __weak __typeof(self)weakSelf = self;
    NSString * url1 = @"/api/v1/player/user/recommendation";
    [self.sessionManager mc_GET:url1 parameters:nil ok:^(NSDictionary * _Nonnull resp) {
        if (resp[@"directCount"]) {
            weakSelf.jianquanLbl.text = [NSString stringWithFormat:@"%@",resp[@"directCount"]];
        }
        if (resp[@"indirectCount"]) {
            weakSelf.zhituiLbl.text =  [NSString stringWithFormat:@"%@",resp[@"indirectCount"]];
        }
        if (resp[@"totalIndirectCount"]) {
            weakSelf.tuiguangzongrenshu.text =  [NSString stringWithFormat:@"%@",resp[@"totalIndirectCount"]];
        }
        if (resp[@"todayIndirectCount"]) {
            weakSelf.jinrituiguang.text =  [NSString stringWithFormat:@"%@",resp[@"todayIndirectCount"]];
        }
        if (resp[@"weekIndirectCount"]) {
            weakSelf.benzhoutuiguang.text =  [NSString stringWithFormat:@"%@",resp[@"weekIndirectCount"]];
        }
        if (resp[@"monthIndirectCount"]) {
            weakSelf.benyuetuiguang.text =  [NSString stringWithFormat:@"%@",resp[@"monthIndirectCount"]];
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
