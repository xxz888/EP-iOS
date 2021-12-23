//
//  KDMemberViewController.m
//  KaDeShiJie
//
//  Created by mac on 2021/12/16.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDMemberViewController.h"
#import "KDMember1ViewController.h"
#import "UIView+Extension.h"
@interface KDMemberViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *huiyuanImg;
@property (weak, nonatomic) IBOutlet UILabel *huiyuanLbl;
@property (weak, nonatomic) IBOutlet UIView *memberView;

@end

@implementation KDMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"会员" tintColor:nil];
    
 
    self.memberView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.memberView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.06].CGColor;
    self.memberView.layer.shadowOffset = CGSizeMake(0,0);
    self.memberView.layer.shadowOpacity = 1;
    self.memberView.layer.shadowRadius = 10;
    self.memberView.layer.cornerRadius = 21;
    
    [self.huiyuanImg rf_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
        
        
        // 头部数据
        [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
  
            if (userInfo.level) {
                if ([userInfo.level isEqualToString:@"Normal"]) {
                    [self.navigationController pushViewController:[KDMember1ViewController new] animated:YES];
                }else{
                    [MCToast showMessage:@"你已开通会员"];
                }
            }else{
                [self.navigationController pushViewController:[KDMember1ViewController new] animated:YES];
            }
        }];
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
