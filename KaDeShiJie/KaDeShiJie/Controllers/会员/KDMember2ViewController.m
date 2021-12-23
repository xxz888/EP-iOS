//
//  KDMember2ViewController.m
//  KaDeShiJie
//
//  Created by mac on 2021/12/16.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDMember2ViewController.h"

@interface KDMember2ViewController ()

@end

@implementation KDMember2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"支付订单" tintColor:nil];
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F6F6F6"];
    [self.payBtn setBackgroundColor:[UIColor qmui_colorWithHexString:@"#F07E1B"]];
    
}
- (IBAction)zhifubaoAction:(id)sender {
    if (!self.zhifubaoBtn.selected) {
        self.zhifubaoBtn.selected = YES;
        self.weixinBtn.selected = self.chuxukaBtn.selected = self.xinyongkaBtn.selected = NO;
    }
}
- (IBAction)weixinAction:(id)sender {
    if (!self.weixinBtn.selected) {
        self.weixinBtn.selected = YES;
        self.zhifubaoBtn.selected = self.chuxukaBtn.selected = self.xinyongkaBtn.selected = NO;
    }
}
- (IBAction)chuxukaAction:(id)sender {
    if (!self.chuxukaBtn.selected) {
        self.chuxukaBtn.selected = YES;
        self.weixinBtn.selected = self.zhifubaoBtn.selected = self.xinyongkaBtn.selected = NO;
    }
}
- (IBAction)xinyongkaAction:(id)sender {
    if (!self.xinyongkaBtn.selected) {
        self.xinyongkaBtn.selected = YES;
        self.weixinBtn.selected = self.chuxukaBtn.selected = self.zhifubaoBtn.selected = NO;
    }
}

- (IBAction)zhifuAction:(id)sender {
    
    
    
    __weak typeof(self) weakSelf = self;
    [[MCSessionManager shareManager] mc_Post_QingQiuTi:@"/api/v1/player/user/diamond" parameters:@{@"payType":@"Alipay"} ok:^(NSDictionary * _Nonnull resp) {
        NSString * orderId = resp[@"orderId"];
        NSString *  link = resp[@"link"];
        
        
        NSString * url1 = [NSString stringWithFormat:@"https://wukatest.flyaworld.com:443/api/v1/player/third/pay?orderId=%@",orderId];
        [self.sessionManager mc_GET:url1 parameters:nil ok:^(NSDictionary * _Nonnull resp) {
            [MCToast showMessage:@"支付成功，你已经成为钻石会员"];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }];
        
//
//        MCWebViewController *web = [[MCWebViewController alloc] init];
//        web.urlString = link;
//        web.title = @"支付宝支付";
//        [weakSelf.navigationController pushViewController:web animated:YES];
        
        
        
        
    } other:^(NSDictionary * _Nonnull resp) {
        
    } failure:^(NSError * _Nonnull error) {
        
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
