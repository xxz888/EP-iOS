//
//  KDMember1ViewController.m
//  KaDeShiJie
//
//  Created by mac on 2021/12/16.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDMember1ViewController.h"
#import "KDMember2ViewController.h"

@interface KDMember1ViewController ()

@end

@implementation KDMember1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"支付" tintColor:UIColor.whiteColor];

    [self.payBtn setBackgroundColor:[UIColor qmui_colorWithHexString:@"##E5E5E5"]];
    self.payBtn.userInteractionEnabled = NO;
}
- (IBAction)selectAction:(id)sender {
    self.selectBtn.selected = !self.selectBtn.selected;
    
    if (self.selectBtn.selected) {
        [self.payBtn setBackgroundColor:[UIColor qmui_colorWithHexString:@"#F07E1B"]];
        self.payBtn.userInteractionEnabled = YES;
    }else{
        [self.payBtn setBackgroundColor:[UIColor qmui_colorWithHexString:@"##E5E5E5"]];
        self.payBtn.userInteractionEnabled = NO;
    }
}
- (IBAction)payAction:(id)sender {
    [self.navigationController pushViewController:[KDMember2ViewController new] animated:YES];
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
