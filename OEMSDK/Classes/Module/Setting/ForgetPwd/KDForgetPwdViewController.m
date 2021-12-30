//
//  KDForgetPwdViewController.m
//  KaDeShiJie
//
//  Created by apple on 2020/11/3.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDForgetPwdViewController.h"
#import "MCToast.h"
#import "KDFillButton.h"
#import <MeiQiaSDK/MQDefinition.h>

@interface KDForgetPwdViewController ()
@property(nonatomic, strong) UIView *footView;
@end

@implementation KDForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (SharedUserInfo.phone && SharedUserInfo.phone.length == 11) {
        self.phoneTf.text = SharedUserInfo.phone;
    }
    self.pwd2Tf.font = self.pwd1Tf.font = Font_System(14);
    
    [self setNavigationBarTitle:
     [self.iscome isEqualToString:@"1"]?@"重置登录密码":
     [self.iscome isEqualToString:@"2"]?@"设置登录密码":
     [self.iscome isEqualToString:@"3"]?@"设置交易密码":@"" tintColor:nil];
    self.view.backgroundColor = [UIColor qmui_colorWithHexString:@"#f5f5f5"];
    [self.bottomView addSubview:self.footView];

    [self.phoneTf addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.codeTf addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"客服" forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.titleLabel.font = LYFont(14);
    shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);


    shareBtn.frame = CGRectMake(SCREEN_WIDTH - 70, StatusBarHeightConstant + 12, 70, 22);
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
}
-(void)clickRightBtnAction{
    [MCServiceStore pushMeiqiaVC];
}
-(void)textFiledEditChanged:(UITextField *)tf{
    if (tf == self.phoneTf && tf.text.length > 11) {
        tf.text = [tf.text substringToIndex:11];
    }
    if (tf == self.codeTf && tf.text.length > 6) {
        tf.text = [tf.text substringToIndex:6];
    }
}
- (IBAction)getCodeAction:(id)sender {
    NSString *phone = self.phoneTf.text;
    if (phone.length != 11) {
        [MCToast showMessage:@"请输入正确的手机号"];
        return;
    }

    // 发送验证码
    kWeakSelf(self);
    NSString * typpe = self.iscome == @"1" ? @"ModifyPassword" :
                       self.iscome == @"2" ? @"ModifyPassword" :
                       self.iscome == @"3" ? @"ModifyPayPassword" : @"";
    NSString * url = [NSString stringWithFormat:@"/api/v1/player/sms?smsType=%@&phone=%@",typpe,phone];
    [[MCSessionManager shareManager] mc_GET:url parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
        [MCToast showMessage:@"验证码已发送"];
        [weakself changeSendBtnText];
    }];
}




- (IBAction)finishAction:(id)sender {
    
   
}


//------ 验证码发送按钮动态改变文字 ------//
- (void)changeSendBtnText {
    
    __block NSInteger second = 60;
    // 全局队列 默认优先级
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 定时器模式 事件源
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // NSEC_PER_SEC是秒 *1是每秒
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(timer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (second >= 0) {
                
                [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds", second] forState:UIControlStateNormal];
                [self.codeBtn setUserInteractionEnabled:NO];
                second--;
            }else {
                dispatch_source_cancel(timer);
                [self.codeBtn setTitle:@"重新发送" forState:(UIControlStateNormal)];
                [self.codeBtn setUserInteractionEnabled:YES];
            }
            
        });
    });
    // 启动源
    dispatch_resume(timer);
}


- (UIView *)footView {
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        
        KDFillButton *logoutBtn = [[KDFillButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 50)];
        logoutBtn.layer.cornerRadius = logoutBtn.height / 2;
        
        logoutBtn.center = _footView.center;
        [logoutBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_footView addSubview:logoutBtn];
        [logoutBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footView;
}
-(void)next:(id)sender{
    if (self.pwd1Tf.text.length < 6) {
        [MCToast showMessage:@"新密码至少六位字符"];
        return;
    }
    if (self.pwd2Tf.text.length < 6) {
        [MCToast showMessage:@"新密码至少六位字符"];
        return;
    }
    if ([self.pwd1Tf.text isEqualToString:self.pwd2Tf.text] ) {

        __weak typeof(self) weakSelf = self;

        NSDictionary * dic = @{};
        NSString * url = @"";
        if ([self.iscome isEqualToString:@"1"] || [self.iscome isEqualToString:@"2"]) {
            dic =   @{
                @"code":self.codeTf.text,
                @"password":self.pwd1Tf.text,
                @"phone": self.phoneTf.text
            };
            
            url = @"/api/v1/player/user/modify/pwd";
        }else{
            dic = @{@"code":self.codeTf.text,
                    @"payPassword":self.pwd1Tf.text
            };
            url = @"/api/v1/player/user/modify/payPassword";

        }
        
        [self.sessionManager mc_put:url parameters:dic ok:^(NSDictionary * _Nonnull resp) {
            
            if (TOKEN) {
                [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];

                }];
            }else{
                // 2.保存登录信息
                NSDictionary *result = (NSDictionary *)resp;
                TOKEN = result[@"token"];
                MCModelStore.shared.preUserPhone = result[@"phone"];
                
                SharedDefaults.extraFee = result[@"info"][@"extraFee"];
                SharedDefaults.hasPayPassword = result[@"info"][@"hasPayPassword"];

                SharedDefaults.phone = result[@"phone"];
                SharedDefaults.nickname = result[@"info"][@"nickname"];
                SharedDefaults.certification = [NSString stringWithFormat:@"%@",result[@"info"][@"certification"]];
                SharedDefaults.level = [NSString stringWithFormat:@"%@",result[@"info"][@"level"]];
                SharedDefaults.receivePaymentRate =[NSString stringWithFormat:@"%@",result[@"info"][@"receivePaymentRate"]];
                SharedDefaults.agentId = [NSString stringWithFormat:@"%@",result[@"info"][@"agentId"]];
                SharedDefaults.repaymentRate = [NSString stringWithFormat:@"%@",result[@"info"][@"repaymentRate"]];
                SharedDefaults.token = [NSString stringWithFormat:@"%@",result[@"token"]];
                [UIApplication sharedApplication].keyWindow.rootViewController = [MGJRouter objectForURL:rt_tabbar_list];
                
                [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
              
                }];
               
            }
          
        } other:^(NSDictionary * _Nonnull resp) {
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
}
-(NSString *)convertToJsonData:(NSDictionary *)dict

{

    NSError *error;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

    NSString *jsonString;

    if (!jsonData) {

        NSLog(@"%@",error);

    }else{

        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    NSRange range = {0,jsonString.length};

    //去掉字符串中的空格

    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = {0,mutStr.length};

    //去掉字符串中的换行符

    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;

}
@end
