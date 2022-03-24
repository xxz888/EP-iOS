//
//  MCHomeServiceViewController.m
//  OEMSDK
//
//  Created by apple on 2020/11/25.
//

#import "MCHomeServiceViewController.h"
#import "MQServiceToViewInterface.h"
#import <MeiQiaSDK/MQDefinition.h>

@interface MCHomeServiceViewController ()

@end

@implementation MCHomeServiceViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
//    [self setData];
    
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


-(void)setData{
    
    if (MCModelStore.shared.preUserPhone.length == 11) {
        NSString *pre = [MCModelStore.shared.preUserPhone substringToIndex:3];
        NSString *suf = [MCModelStore.shared.preUserPhone substringFromIndex:MCModelStore.shared.preUserPhone.length - 4];
        self.zhituiPhoneLbl.text = [NSString stringWithFormat:@"手机号:%@****%@",pre,suf];
    }

}
-(void)setUI{
    [self setNavigationBarTitle:@"客服" tintColor:[UIColor whiteColor]];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.topView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.09].CGColor;
    self.topView.layer.shadowOffset = CGSizeMake(0,2.5);
    self.topView.layer.shadowOpacity = 1;
    self.topView.layer.shadowRadius = 10;
    
    self.middleView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.09].CGColor;
    self.middleView.layer.shadowOffset = CGSizeMake(0,2.5);
    self.middleView.layer.shadowOpacity = 1;
    self.middleView.layer.shadowRadius = 10;
    
    self.bottomView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.09].CGColor;
    self.bottomView.layer.shadowOffset = CGSizeMake(0,2.5);
    self.bottomView.layer.shadowOpacity = 1;
    self.bottomView.layer.shadowRadius = 10;
    
    self.liuyanbanView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.09].CGColor;
    self.liuyanbanView.layer.shadowOffset = CGSizeMake(0,2.5);
    self.liuyanbanView.layer.shadowOpacity = 1;
    self.liuyanbanView.layer.shadowRadius = 10;
    
    ViewRadius(self.liuyanbanMessageLbl, 8);
    //添加点击手势
//    self.kefuView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView:)];
//    [self.kefuView addGestureRecognizer:click];
//
//    //添加点击手势
//    self.liuyanbanView.userInteractionEnabled = YES;
//    UITapGestureRecognizer * liuyanbanClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLiuyanbanView:)];
//    [self.liuyanbanView addGestureRecognizer:liuyanbanClick];
//
//    //添加点击手势
//    self.bottomView.userInteractionEnabled = YES;
//    UITapGestureRecognizer * dianhuaClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guanfangkefuAction:)];
//    [self.bottomView addGestureRecognizer:dianhuaClick];
//
//    //添加点击手势
//    self.topView.userInteractionEnabled = YES;
//    UITapGestureRecognizer * topViewClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zhituiTelAction:)];
//    [self.topView addGestureRecognizer:topViewClick];
//
    
    self.server1Imv.userInteractionEnabled = YES;
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView:)];
    [self.server1Imv addGestureRecognizer:click];
    
        self.server2Imv.userInteractionEnabled = YES;
        UITapGestureRecognizer * dianhuaClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guanfangkefuAction:)];
        [self.server2Imv addGestureRecognizer:dianhuaClick];

}
-(void)clickView:(id)tp{
    [MCServiceStore pushMeiqiaVC];
}
-(void)clickLiuyanbanView:(id)tp{
    [MCPagingStore pagingURL:rt_card_liuyanban];

}
- (IBAction)zhituiTelAction:(id)sender {
    if (MCModelStore.shared.preUserPhone) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",MCModelStore.shared.preUserPhone]]];
    } else {
        [MCToast showMessage:@"没有上级！"];
    }
}
- (IBAction)guanfangkefuAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",SharedDefaults.configDic[@"servicePhone"]]]];
}

- (IBAction)kefuAction:(id)sender {
    [MCServiceStore pushMeiqiaVC];
}
#pragma mark === 永久闪烁的动画 ======

-(CABasicAnimation *)opacityForever_Animation:(float)time{

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。

    animation.fromValue = [NSNumber numberWithFloat:1.0f];

    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。

    animation.autoreverses = YES;

    animation.duration = time;

    animation.repeatCount = MAXFLOAT;

    animation.removedOnCompletion = NO;

    animation.fillMode = kCAFillModeForwards;

     animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。

    return animation;

}




// 监听收到美洽聊天消息的广播
- (void)didReceiveNewMQMessages:(NSNotification *)notification {
    //请求未读消息
//    [self requestGetUnreadMessages];
}

-(void)requestGetUnreadMessages{
    kWeakSelf(self);
    [MQServiceToViewInterface getUnreadMessagesWithCompletion:^(NSArray *messages, NSError *error) {
    if ([messages count] == 0) {
        [weakself.kefuImv.layer removeAllAnimations];
        
    }else{
        [weakself.kefuImv.layer addAnimation:[weakself opacityForever_Animation:0.4] forKey:nil];
    }

}];
}


@end
