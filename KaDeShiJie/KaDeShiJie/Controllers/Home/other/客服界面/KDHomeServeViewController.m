//
//  KDHomeServeViewController.m
//  KaDeShiJie
//
//  Created by BH on 2022/3/24.
//  Copyright © 2022 SS001. All rights reserved.
//

#import "KDHomeServeViewController.h"
#import "MQServiceToViewInterface.h"
#import <MeiQiaSDK/MQDefinition.h>
@interface KDHomeServeViewController ()

@end

@implementation KDHomeServeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"客服" tintColor:[UIColor whiteColor]];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F8"];
    
    self.telPhone.text = [NSString stringWithFormat:@"全国服务热线：%@",SharedDefaults.configDic[@"servicePhone"]];
    MCUserInfo * info = SharedUserInfo;
    self.tuijianren.text = [NSString stringWithFormat:@"推荐人：%@",info.agentPhone];
    UITapGestureRecognizer *click1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView1:)];
    [self.view1 addGestureRecognizer:click1];
    
    UITapGestureRecognizer *click2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView2:)];
    [self.view2 addGestureRecognizer:click2];
    
    UITapGestureRecognizer *click3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView3:)];
    [self.view3 addGestureRecognizer:click3];
    

}
-(void)clickView1:(id)tap{
    MCUserInfo * info = SharedUserInfo;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",info.agentPhone]]];
}
-(void)clickView2:(id)tap{
    [MCServiceStore pushMeiqiaVC];
}
-(void)clickView3:(id)tap{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",SharedDefaults.configDic[@"servicePhone"]]]];
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
