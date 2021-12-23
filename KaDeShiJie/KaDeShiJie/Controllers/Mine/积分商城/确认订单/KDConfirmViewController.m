//
//  KDConfirmViewController.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/8.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDConfirmViewController.h"
#import "KDJFPayViewController.h"
#import "KDJFAdressManagerViewController.h"
#import "KDJFAdressListViewController.h"
@interface KDConfirmViewController ()

@end

@implementation KDConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"确认订单" backgroundImage:[UIImage qmui_imageWithColor:UIColor.mainColor]];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.noAddressView.backgroundColor = KWhiteColor;
    ViewRadius(self.noAddressView, 3);
    ViewRadius(self.goodImv, 3);

    [self.goodImv sd_setImageWithURL:[NSURL URLWithString:self.goodDic[@"logo"]] placeholderImage:[UIImage imageNamed:@"logo"]];
    self.goodPrice.text =
    [NSString stringWithFormat:@"¥%@元",self.goodDic[@"price"]];
    
    
    //添加没有地址view的手势
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickNoAdressAction:)];
    [self.noAddressView addGestureRecognizer:tap];
    
    //添加有地址view的手势
    UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHaveAdressAction:)];
    [self.haveAddressView addGestureRecognizer:tap1];


    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    kWeakSelf(self);
    [[MCSessionManager shareManager] mc_GET:[NSString stringWithFormat:@"/api/v1/player/shop/address"] parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
        if ([resp count] != 0) {
            weakself.noAddressView.hidden = YES;
            weakself.haveAddressView.hidden = NO;
            NSArray * arr = [NSArray arrayWithArray:resp];
            weakself.cPhone.text = @"";
            weakself.cAdress.text = [NSString stringWithFormat:@"%@",arr[0][@"completeAddress"]];
            weakself.cName.text = arr[0][@"receiptName"];
//            weakself.cDetailAdress.text = resp[@"completeAddress"];

        }else{
            weakself.noAddressView.hidden = NO;
            weakself.haveAddressView.hidden = YES;

        }

    }];
}
-(void)clickNoAdressAction:(id)tap{
    KDJFAdressManagerViewController * vc = [[KDJFAdressManagerViewController alloc]init];
    vc.whereCome = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)clickHaveAdressAction:(id)tap{
    KDJFAdressManagerViewController * vc = [[KDJFAdressManagerViewController alloc]init];
    vc.whereCome = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)confirmAction:(id)sender {
    KDJFAdressListViewController * vc = [[KDJFAdressListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
