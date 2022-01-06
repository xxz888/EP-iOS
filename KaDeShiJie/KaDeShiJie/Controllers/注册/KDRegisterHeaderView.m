//
//  KDRegisterHeaderView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/5.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDRegisterHeaderView.h"
#import <MeiQiaSDK/MQDefinition.h>
#import "KDRegisterViewController.h"
@interface KDRegisterHeaderView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneView;
@property (weak, nonatomic) IBOutlet UITextField *codeView;

@property (weak, nonatomic) IBOutlet UIImageView *topImg;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerBtnHigCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerBtnWidCons;

@property (weak, nonatomic) IBOutlet UITextField *tuijianTf;
@property (weak, nonatomic) IBOutlet UILabel *tuijianLbl;
@property (weak, nonatomic) IBOutlet UIImageView *tuijianImv;
@property (weak, nonatomic) IBOutlet UIView *tuijianLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tujianBottomHeight;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UITextField *tuijianrenIdTf;

@end

@implementation KDRegisterHeaderView
- (IBAction)agreeActino:(id)sender {
    self.agreeBtn.selected = !self.agreeBtn.selected;
}
// 注册
- (IBAction)registerAction:(id)sender {
  
}
- (IBAction)kefuAction:(id)sender {
    [MCServiceStore pushMeiqiaVC];

}
- (IBAction)loginV:(id)sender {
    [MCLATESTCONTROLLER.navigationController popViewControllerAnimated:YES];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (StatusBarHeight == 20) {
        [self.registerBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [self.registerBtn setBackgroundColor:[UIColor mainColor]];
        [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.registerBtn.titleLabel.font = LYFont(20);
        self.registerBtnHigCons.constant = 50;
        self.registerBtnWidCons.constant = 274;
    } else {
        
        [self.registerBtn setBackgroundColor:[UIColor mainColor]];
        [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.registerBtn.titleLabel.font = LYFont(20);
        self.registerBtnHigCons.constant = 50;
        self.registerBtnWidCons.constant = 324;
    }
    
//    [self showTuiJianView:NO];
    [self.codeView addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.phoneView addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.tuijianTf addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    self.phoneView.delegate = self;
}
-(void)showTuiJianView:(BOOL)isShow{
//    self.tuijianLbl.hidden = self.tuijianTf.hidden = self.tuijianImv.hidden = self.tuijianLine.hidden = self.tuijianTf.hidden = !isShow;
//    self.tujianBottomHeight.constant = isShow ? 50 : 0;
}

-(void)textFiledEditChanged:(UITextField *)tf{
    if (tf == self.phoneView && tf.text.length > 11) {
        tf.text = [tf.text substringToIndex:11];
    }
    if (tf == self.codeView && tf.text.length > 6) {
        tf.text = [tf.text substringToIndex:6];
    }
    if (tf == self.tuijianTf && tf.text.length > 11) {
        tf.text = [tf.text substringToIndex:11];
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDRegisterHeaderView" owner:nil options:nil] firstObject];
    }
    return self;
}

// 获取验证码
- (IBAction)getCodeAction:(UIButton *)sender {
    NSString *phone = self.phoneView.text;
    if (phone.length != 11) {
        [MCToast showMessage:@"请输入正确的手机号"];
        return;
    }
    kWeakSelf(self);
    NSString * url = [NSString stringWithFormat:@"/api/v1/player/sms?smsType=Register&phone=%@",self.phoneView.text];
    [[MCSessionManager shareManager] mc_GET:url parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
        [MCToast showMessage:@"验证码已发送"];
        [weakself changeSendBtnText];
    }];
//    [[MCSessionManager shareManager] mc_Post_QingQiuTi:@"/api/v1/player/sms" parameters:@{@"phone":self.phoneView.text,@"smsType":@"Register"} ok:^(NSDictionary * _Nonnull resp) {
//        //已注册
//        if ([resp[@"messege"] containsString:@"已注册"]) {
//            [MCToast showMessage:@"您已注册,请直接登录"];
//            [MCLATESTCONTROLLER.navigationController popViewControllerAnimated:YES];
//        }
//        //未注册
//        if ([resp[@"messege"] containsString:@"未注册"]) {
//            [weakself showTuiJianView:YES];
//            [weakself changeSendBtnText];
//            // 发送验证码
//            [LoginAndRegistHTTPTools getSMS:phone];
//        }
//    }];

}

// 注册
- (IBAction)registerBtnAction:(UIButton *)sender {
    NSString *phone = self.phoneView.text;
    NSString *code = self.codeView.text;
    if (!self.agreeBtn.selected) {
        [MCToast showMessage:@"请同意登陆服务协议"];
        return;
    }

    
    if (phone.length != 11) {
        [MCToast showMessage:@"请输入正确的手机号"];
        return;
    }
    if (self.tuijianTf.text.length == 0) {
        [MCToast showMessage:@"请输入密码"];
        return;
    }
    if (![self isSafePassword:self.tuijianTf.text]) {
        [MCToast showMessage:@"请输入8-16位数字+字母组合密码"];
        return;
    }
    if (code.length == 0) {
        [MCToast showMessage:@"请输入验证码"];
        return;
    }

    if (self.tuijianrenIdTf.text.length == 0) {
        [MCToast showMessage:@"请输入推荐人ID号"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:phone forKey:@"phone"];
    [params setValue:self.tuijianrenIdTf.text forKey:@"agentId"];
    [params setValue:self.tuijianTf.text forKey:@"password"];
    [params setValue:code forKey:@"code"];

    
    [[MCSessionManager shareManager] mc_Post_QingQiuTi:@"/api/v1/player/user" parameters:params ok:^(NSDictionary * _Nonnull resp) {
 
        [MCLATESTCONTROLLER.navigationController popViewControllerAnimated:YES];

    } other:^(NSDictionary * _Nonnull resp) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
//    [[MCSessionManager shareManager] mc_POST:@"/api/v1/player/user" parameters:params ok:^(NSDictionary * _Nonnull resp) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [MCToast showMessage:resp[@"messege"]];
//        });
//        [MCLATESTCONTROLLER.navigationController popViewControllerAnimated:YES];
//    }];

}
- (BOOL) isSafePassword:(NSString *)strPwd{
    NSString *passWordRegex = @"^((?![0-9]+$)(?![a-zA-Z]+$)(?![~!@#$^&|*-_+=.?,]+$))[0-9A-Za-z~!@#$^&|*-_+=.?,]{6,20}$";   // 数字，字符或符号至少两种
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
    
    if ([regextestcm evaluateWithObject:strPwd] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+100);
}

- (IBAction)zhucexieyi:(id)sender {
    MCWebViewController *web = [[MCWebViewController alloc] init];
  web.urlString = SharedDefaults.configDic[@"registerProtocolLink"];
  web.title = @"注册服务协议";
  [MCLATESTCONTROLLER.navigationController pushViewController:web animated:YES];
}
@end
