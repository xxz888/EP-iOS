//
//  KDLoginHeaderView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/5.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDLoginHeaderView.h"
#import "KDRegisterViewController.h"
#import <MCProtocolViewController.h>
#import "KDWebContainer.h"
#import "KDForgetPwdViewController.h"
#import "KDCommonAlert.h"
#import "NSString+QMUI.h"
#import <CommonCrypto/CommonCrypto.h>

#define SegmentUnLine_COLOR [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]
#define SegmentBtn_COLOR    [UIColor colorWithRed:255/255.0 green:159/255.0 blue:88/255.0 alpha:1]
#define SegmentSelet_FontSize 19
#define SegmentUnSelet_FontSize 14


@interface KDLoginHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *segmentBtn1;
@property (weak, nonatomic) IBOutlet UIButton *segmentBtn2;
@property (weak, nonatomic) IBOutlet UIView *segmentLine1;
@property (weak, nonatomic) IBOutlet UIView *segmentLine2;


@property (weak, nonatomic) IBOutlet UIImageView *img1Tag;
@property (weak, nonatomic) IBOutlet UIImageView *img2Tag;


@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet QMUITextField *phoneView;
@property (weak, nonatomic) IBOutlet QMUITextField *codeView;

@property (weak, nonatomic) IBOutlet UIImageView *topImg;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnHigCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnWidCons;
@property (weak, nonatomic) IBOutlet UIView *phoneBottomView;
@property (weak, nonatomic) IBOutlet UIView *pwdBottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pwdBottomViewRight;
@property (weak, nonatomic) IBOutlet UIImageView *pwdHeadImv;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneIconTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeIconTopCons;
@end

@implementation KDLoginHeaderView
- (IBAction)agreeActino:(id)sender {
    self.agreeBtn.selected = !self.agreeBtn.selected;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (StatusBarHeight == 20) {
        self.topImg.image = [UIImage imageNamed:@"login_top_bg_nor"];
        [self.loginBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [self.loginBtn setBackgroundColor:[UIColor mainColor]];
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.loginBtn.titleLabel.font = LYFont(20);
        self.loginBtnHigCons.constant = 50;
        self.phoneIconTopCons.constant = 0;
        self.codeIconTopCons.constant = 29;
        self.loginBtnWidCons.constant = 274;
    } else {
        
        [self.loginBtn setBackgroundColor:[UIColor mainColor]];
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.loginBtn.titleLabel.font = LYFont(20);
        self.loginBtnHigCons.constant = 50;
//        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"kd_login_btn"] forState:UIControlStateNormal];
        self.loginBtnWidCons.constant = 324;
        self.phoneIconTopCons.constant = 28.5;
        self.codeIconTopCons.constant = 34;
        self.topImg.image = [UIImage imageNamed:@"login_top_bg"];
    }
    
    if (SharedDefaults.phone.length != 0) {
        self.phoneView.text = SharedDefaults.phone;
    }
    
    self.segmentBtn1.selected = YES;
    self.segmentBtn2.selected = NO;
    self.codeView.secureTextEntry = YES;
    
   
    self.segmentLine2.backgroundColor = [UIColor clearColor];
    self.segmentLine1.backgroundColor = SegmentBtn_COLOR;
    
    self.pwdBottomViewRight.constant = 0;
    self.codeBtn.hidden = YES;
//    ViewBorderRadius(self.phoneBottomView, 1, 0.5, SegmentBtn_COLOR);
//    ViewBorderRadius(self.pwdBottomView, 1, 0.5, SegmentBtn_COLOR);
//    ViewBorderRadius(self.codeBtn, 1, 0.5, SegmentBtn_COLOR);
    self.codeView.placeholder = @"请输入密码";
    self.phoneView.placeholder = @"请输入账号";
    self.img1Tag.image = [UIImage imageNamed:@"账号"];
    self.img2Tag.image = [UIImage imageNamed:@"密码"];
    self.phoneView.placeholderColor = self.codeView.placeholderColor = SegmentBtn_COLOR;
    
    [self.codeView addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];

}
- (IBAction)segmentAction:(UIButton *)selectBtn{
    [self.codeView resignFirstResponder];
    [self.phoneView resignFirstResponder];

    if (self.segmentBtn1 == selectBtn) {
        self.segmentBtn1.selected = YES;
        self.segmentBtn2.selected = NO;

        self.segmentLine1.backgroundColor = SegmentBtn_COLOR;
        self.segmentLine2.backgroundColor = [UIColor clearColor];
        self.pwdBottomViewRight.constant = 0;
        self.codeBtn.hidden = YES;
        self.phoneView.placeholder = @"请输入账号";
        self.codeView.placeholder = @"请输入密码";
        self.codeView.text = @"";
        self.pwdHeadImv.image = [UIImage imageNamed:@"KD_Login_Pwd"];
        self.forgetBtn.hidden = NO;
        self.codeView.secureTextEntry = YES;
        
        self.img1Tag.image = [UIImage imageNamed:@"账号"];
        self.img2Tag.image = [UIImage imageNamed:@"密码"];
    }else{
        self.segmentBtn2.selected = YES;
        self.segmentBtn1.selected = NO;
    
        self.segmentLine2.backgroundColor = SegmentBtn_COLOR;
        self.segmentLine1.backgroundColor = [UIColor clearColor];
        self.pwdBottomViewRight.constant = 110;
        self.codeBtn.hidden = NO;
        self.phoneView.placeholder = @"请输入手机号";
        self.codeView.placeholder = @"请输入验证码";
        self.codeView.text = @"";
        self.pwdHeadImv.image = [UIImage imageNamed:@"KD_Login_SMS"];
        self.forgetBtn.hidden = YES;
        self.codeView.secureTextEntry = NO;
        
        self.img1Tag.image = [UIImage imageNamed:@"手机"];
        self.img2Tag.image = [UIImage imageNamed:@"短信"];

    }
}
  
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDLoginHeaderView" owner:nil options:nil] firstObject];
    }
    return self;
}

// 获取验证码
- (IBAction)getCodeAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    NSString *phone = self.phoneView.text;
    if (phone.length != 11) {
        [MCToast showMessage:@"请输入正确的手机号"];
        return;
    }
    NSString * url = [NSString stringWithFormat:@"/api/v1/player/sms?smsType=Login&phone=%@",self.phoneView.text];
    [[MCSessionManager shareManager] mc_GET:url parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
        [MCToast showMessage:@"验证码已发送"];
        [weakSelf changeSendBtnText];
    }];
}


// 登录
- (IBAction)loginBtnAction:(UIButton *)sender {
    NSString *phone = self.phoneView.text;
    NSString *code = self.codeView.text;
    __weak typeof(self) weakSelf = self;
//    if (phone.length != 11) {
//        [MCToast showMessage:@"手机号码错误,请重新核对并输入正确的手机号"];
//        return;
//    }
    
    if (!self.agreeBtn.selected) {
        [MCToast showMessage:@"请同意登录服务协议"];
        return;
    }
    //密码登录
    if (self.segmentBtn1.selected) {
        if (code.length == 0) {
            [MCToast showMessage:@"请输入密码"];
            return;
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:phone forKey:@"phone"];
        [params setValue:code forKey:@"password"];
        [params setValue:SharedDefaults.deviceid forKey:@"deviceId"];
        
        [[MCSessionManager shareManager] mc_Post_QingQiuTi:@"/api/v1/player/user/login" parameters:params ok:^(NSDictionary * _Nonnull resp) {
            [weakSelf loginSucess:resp];
        } other:^(NSDictionary * _Nonnull resp) {
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    //验证码登录
    }else{
        if (code.length == 0) {
            [MCToast showMessage:@"短信验证码错误,请重新核对并输入正确的验证码"];
            return;
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:phone forKey:@"phone"];
        [params setValue:code forKey:@"code"];
        [[MCSessionManager shareManager] mc_Post_QingQiuTi:@"/api/v1/player/user/login/code" parameters:params ok:^(NSDictionary * _Nonnull resp) {
            [weakSelf loginSucess:resp];
        } other:^(NSDictionary * _Nonnull resp) {
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
    
   

}
-(void)loginSucess:(MCNetResponse * _Nonnull) resp{

   
    
    
    [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
        // 2.保存登录信息
        NSDictionary *result = (NSDictionary *)resp;
        TOKEN = result[@"token"];
        MCModelStore.shared.preUserPhone = result[@"phone"];
        
        SharedDefaults.phone = result[@"phone"];
        SharedDefaults.nickname = result[@"nickname"];
        SharedDefaults.certification = [NSString stringWithFormat:@"%@",result[@"certification"]];
        SharedDefaults.level = [NSString stringWithFormat:@"%@",result[@"level"]];
        SharedDefaults.receivePaymentRate =[NSString stringWithFormat:@"%@",result[@"receivePaymentRate"]];
        SharedDefaults.agentId = [NSString stringWithFormat:@"%@",result[@"agentId"]];
        SharedDefaults.repaymentRate = [NSString stringWithFormat:@"%@",result[@"repaymentRate"]];
        SharedDefaults.token = [NSString stringWithFormat:@"%@",result[@"token"]];
        [UIApplication sharedApplication].keyWindow.rootViewController = [MGJRouter objectForURL:rt_tabbar_list];
    }];

 
    
//    [[KDLoginTool shareInstance] getChuXuCardData:YES];
    //获取贴牌信息
}
#pragma mark - MD5加密 32位 大写
- (NSString *)MD5ForUpper32Bate:(NSString *)str{
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    return digest;
}
// 注册
- (IBAction)registerAction:(id)sender {
    [MCLATESTCONTROLLER.navigationController pushViewController:[KDRegisterViewController new] animated:YES];
}
// 协议
- (IBAction)agreementAction:(id)sender {

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
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}
- (IBAction)forgetAction:(id)sender {
    self.codeView.text = @"";
    KDForgetPwdViewController * VC= [[KDForgetPwdViewController alloc]init];
    if (self.phoneView.text.length == 11) {
        VC.startPhone = self.phoneView.text;
    }else{
        VC.startPhone = @"";
    }

    [MCLATESTCONTROLLER.navigationController pushViewController:VC animated:YES];
    
}

-(void)textFiledEditChanged:(UITextField *)tf{
    if (!self.segmentBtn1.selected && tf.text.length > 6) {
        tf.text = [tf.text substringToIndex:6];
    }
}

@end
