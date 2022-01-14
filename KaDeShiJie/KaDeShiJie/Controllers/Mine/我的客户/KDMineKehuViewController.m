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
    [self setNavigationBarTitle:@"我的客户" tintColor:nil];
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
    /*
     接口：/api/v1/player/user/recommendation/v2

     字段说明 ：

     总推广人数 totalCount;

     直推人数 directCount;
     直推未实名人数 directUnCertificationCount;
     直推实名人数 directCertificationCount;
     直推vip directVipCount;
     间推vip indirectVipCount;
     团队vip人数 teamVipCount;
     **/
    __weak __typeof(self)weakSelf = self;
    NSString * url1 = @"/api/v1/player/user/recommendation/v2";
    [self.sessionManager mc_GET:url1 parameters:nil ok:^(NSDictionary * _Nonnull resp) {
        //推广总人数
        if (resp[@"totalCount"]) {
            weakSelf.tuiguangzongrenshu.text =  [NSString stringWithFormat:@"%@",resp[@"totalCount"]];
        }
        //直推人数
        if (resp[@"directCount"]) {
            weakSelf.zhituirenshu.text =  [NSString stringWithFormat:@"%@",resp[@"directCount"]];
            weakSelf.cellzhituiLbl.text =  [NSString stringWithFormat:@"%@",resp[@"directCount"]];

        }
        //直推未实名人数
        if (resp[@"directUnCertificationCount"]) {
            weakSelf.zhituiweishiming.text =  [NSString stringWithFormat:@"%@",resp[@"directUnCertificationCount"]];
        }
        //直推实名人数
        if (resp[@"directCertificationCount"]) {
            weakSelf.zhituiyishiming.text =  [NSString stringWithFormat:@"%@",resp[@"directCertificationCount"]];
        }
        
        //直推VIP
        if (resp[@"directVipCount"]) {
            weakSelf.zhituivip.text =  [NSString stringWithFormat:@"%@",resp[@"directVipCount"]];
        }
        //间推vip
        if (resp[@"indirectVipCount"]) {
            weakSelf.jiantuivip.text =  [NSString stringWithFormat:@"%@",resp[@"indirectVipCount"]];
        }
        //团队VIP
        if (resp[@"teamVipCount"]) {
            weakSelf.tuanduivip.text =  [NSString stringWithFormat:@"%@",resp[@"teamVipCount"]];
        }
        
        //间推人数
        if (resp[@"indirectCount"]) {
            weakSelf.celljiantuiLbl.text =  [NSString stringWithFormat:@"%@",resp[@"indirectCount"]];
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
