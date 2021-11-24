//
//  KDTiXianViewController.m
//  KaDeShiJie
//
//  Created by BH on 2021/11/24.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDTiXianViewController.h"
#import "KDTixianjiluViewController.h"

@interface KDTiXianViewController ()

@end

@implementation KDTiXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor qmui_colorWithHexString:@"#F6F6F6"];
    
    [self setNavigationBarTitle:@"提现" backgroundImage:[UIImage qmui_imageWithColor:[UIColor mainColor]]];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    
    QMUIButton *kfBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
    [kfBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [kfBtn setTitle:@"提现记录" forState:UIControlStateNormal];
    [kfBtn addTarget:self action:@selector(clicktixianjiluAction) forControlEvents:UIControlEventTouchUpInside];
    kfBtn.spacingBetweenImageAndTitle = 5;
    kfBtn.titleLabel.font = LYFont(13);
    kfBtn.frame = CGRectMake(SCREEN_WIDTH - 84, StatusBarHeight, 64, 44);
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:kfBtn];
}
-(void)clicktixianjiluAction{
    [self.navigationController pushViewController:[KDTixianjiluViewController new] animated:YES];
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
