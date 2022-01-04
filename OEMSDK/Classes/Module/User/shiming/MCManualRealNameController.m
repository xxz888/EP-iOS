//
//  CommonRealnameVC.m
//  Project
//
//  Created by 熊凤伟 on 2018/3/22.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "MCManualRealNameController.h"
#import "LYImageMagnification.h"// 查看图片大图
#import "DDPhotoViewController.h"
#import "liveness/Liveness.h"

#define kViewColor [UIColor colorWithRed:210/255.0 green:210/255.0 blue:220/255.0 alpha:1.0]

#define ZhengMian @"身份证正面"
#define FanMian   @"身份证反面"
static const CGFloat margin = 10;

@interface MCManualRealNameController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate,LivenessDetectDelegate>
@property(assign,nonatomic)NSString * zhengmianfanmian;

/** 姓名输入框 */
@property (nonatomic, weak) UITextField *nameTF;
/** 身份证号输入框 */
@property (nonatomic, weak) UITextField *idCardTF;

@property (nonatomic, weak) UITextField *bankCardTF;

/** 正面拍摄按钮 */
@property (nonatomic, weak) UIButton *frontPhotoButton;
/** 反面拍摄按钮 */
@property (nonatomic, weak) UIButton *backPhotoButton;
/** 人物照拍摄按钮 */
@property (nonatomic, weak) UIButton *personPhotoButton;

/** imageOne */
@property (nonatomic, strong) UIImage *imageOne;
/** imageTwo */
@property (nonatomic, strong) UIImage *imageTwo;
/** imageThree */
@property (nonatomic, strong) UIImage *imageThree;

/** index(0-正面拍摄按钮 1-反面拍摄按钮 2-人物拍摄按钮) */
@property (nonatomic, assign) NSInteger index;

@property(nonatomic,assign)NSInteger isWho;

/** imageOne */
@property (nonatomic, strong) NSString *imageOneURL;
/** imageTwo */
@property (nonatomic, strong) NSString *imageTwoURL;
/** imageThree */
@property (nonatomic, strong) NSString *imageThreeURL;

@property (nonatomic, weak) UITextField * phoneTf;
@property (nonatomic, strong) NSString * bankURL;


@property (nonatomic, assign) NSInteger ocrIndex;



@end

@implementation MCManualRealNameController

#pragma mark --- LIFE
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 主界面
    [self setupMainView];
}
#pragma mark --- SET UP VIEW
//------ 主界面 ------//
- (void)setupMainView {
    
    // 0. 初始值
    
    [self setNavigationBarTitle:@"实名认证" tintColor:nil];
    self.imageOne = nil;
    self.imageTwo = nil;
    self.imageThree = nil;
    self.bankURL = nil;
    // 容器
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTop)];
    scrollView.directionalLockEnabled = YES;// 单一方向滚动
    scrollView.pagingEnabled = NO;// 翻页
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    [self.view addSubview:scrollView];
    
    // 1. 用户名/身份证
    // 用户名
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(margin, margin, scrollView.width - margin * 2, 40)];
    nameView.layer.cornerRadius = 6;
    nameView.layer.masksToBounds = YES;
    nameView.layer.borderColor =  [UIColor qmui_colorWithHexString:@"#F1F1F1"].CGColor;
    nameView.layer.borderWidth = 1;
    [scrollView addSubview:nameView];
    
    
  

    
    
    
    UILabel *nameTitleLabel = [self labelWithFrame:CGRectMake(0, 0, 100, nameView.height-1) text:@"姓名" textColor:[UIColor darkGrayColor] textAlignment:(NSTextAlignmentCenter) font:[UIFont systemFontOfSize:14]];
    
    [nameView addSubview:nameTitleLabel];
    UIView *nameLineView = [[UIView alloc] initWithFrame:CGRectMake(nameTitleLabel.right, 5, 1, nameView.height - 10)];
    nameLineView.backgroundColor = [UIColor qmui_colorWithHexString:@"#F1F1F1"];
    [nameView addSubview:nameLineView];
    UITextField *nameTF = [[UITextField alloc] initWithFrame:CGRectMake(nameLineView.right + 5, 0, nameView.width - nameLineView.right - 5 - margin, nameView.height-1)];
    nameTF.textColor = [UIColor qmui_colorWithHexString:@"#333333"];
    nameTF.textAlignment = NSTextAlignmentLeft;
    nameTF.font = [UIFont systemFontOfSize:14];
    nameTF.tintColor = [UIColor lightGrayColor];
    nameTF.placeholder = @"请输入真实姓名";
    nameTF.keyboardType = UIKeyboardTypeDefault;
    nameTF.delegate = self;
    [nameView addSubview:nameTF];
    self.nameTF = nameTF;
    //身份证号
    UIView *cardNoView = [[UIView alloc] initWithFrame:CGRectMake(nameView.left, nameView.bottom + margin, nameView.width, nameView.height)];
    
    
    
    cardNoView.layer.cornerRadius = 6;
    cardNoView.layer.masksToBounds = YES;
    cardNoView.layer.borderColor = [UIColor qmui_colorWithHexString:@"#F1F1F1"].CGColor;
    cardNoView.layer.borderWidth = 1;
    [scrollView addSubview:cardNoView];
    
    
    UILabel *cardNoTitleLabel = [self labelWithFrame:CGRectMake(0, 0, 100, nameView.height) text:@"身份证" textColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:14]];
    [cardNoView addSubview:cardNoTitleLabel];
    UIView *cardNoLineView = [[UIView alloc] initWithFrame:CGRectMake(cardNoTitleLabel.right, 5, 1, cardNoView.height - 10)];
    cardNoLineView.backgroundColor = [UIColor qmui_colorWithHexString:@"#F1F1F1"];
    [cardNoView addSubview:cardNoLineView];
    UITextField *idCardTF = [[UITextField alloc] initWithFrame:CGRectMake(cardNoLineView.right + 5, 0, cardNoView.width - cardNoLineView.height - 5 - margin, cardNoView.height)];
    idCardTF.textColor = [UIColor qmui_colorWithHexString:@"#333333"];
    idCardTF.textAlignment = NSTextAlignmentLeft;
    idCardTF.font = [UIFont systemFontOfSize:14];
    idCardTF.tintColor = [UIColor lightGrayColor];
    idCardTF.placeholder = @"请输入身份证号";
    idCardTF.keyboardType = UIKeyboardTypeDefault;
    idCardTF.delegate = self;
    [cardNoView addSubview:idCardTF];
    self.idCardTF = idCardTF;
    
    
    UIView *codeRightView1 = [[UIView alloc] initWithFrame:CGRectMake(cardNoView.width - 50,0,40,40)];
    UIButton * scanBankCardButton1 =[UIButton buttonWithType:UIButtonTypeCustom];
    [scanBankCardButton1 setImage:[UIImage mc_imageNamed:@"lx_card_scan"] forState:0];
    scanBankCardButton1.frame = CGRectMake(0, 0,40,40);
    scanBankCardButton1.tag = 1002;
    [scanBankCardButton1 addTarget:self action:@selector(clickScan:) forControlEvents:UIControlEventTouchUpInside];
    [codeRightView1 addSubview:scanBankCardButton1];
    [cardNoView addSubview:codeRightView1];
    
    
    
    

    UIView * bankcardNoView = [[UIView alloc] initWithFrame:CGRectMake(cardNoView.left, cardNoView.bottom + margin, cardNoView.width, cardNoView.height)];
    bankcardNoView.layer.cornerRadius = 6;
    bankcardNoView.layer.masksToBounds = YES;
    bankcardNoView.layer.borderColor =  [UIColor qmui_colorWithHexString:@"#F1F1F1"].CGColor;
    bankcardNoView.layer.borderWidth = 1;
    [scrollView addSubview:bankcardNoView];
    
    
    UILabel * bankcardNoTitleLabel = [self labelWithFrame:CGRectMake(0, 0, 100, nameView.height) text:@"储蓄卡" textColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:14]];
    [bankcardNoView addSubview:bankcardNoTitleLabel];
    UIView *cardcardNoLineView = [[UIView alloc] initWithFrame:CGRectMake(bankcardNoTitleLabel.right, 5, 1, bankcardNoTitleLabel.height - 10)];
    cardcardNoLineView.backgroundColor = [UIColor qmui_colorWithHexString:@"#F1F1F1"];
    [bankcardNoView addSubview:cardcardNoLineView];
    UITextField *bankCardTf = [[UITextField alloc] initWithFrame:CGRectMake(cardNoLineView.right + 5, 0, cardNoView.width - cardNoLineView.height - 5 - margin, cardNoView.height)];
    bankCardTf.userInteractionEnabled = NO;
    bankCardTf.textColor = [UIColor qmui_colorWithHexString:@"#333333"];
    bankCardTf.tag = 1002;
    bankCardTf.textAlignment = NSTextAlignmentLeft;
    bankCardTf.font = [UIFont systemFontOfSize:14];
    bankCardTf.tintColor = [UIColor lightGrayColor];
    bankCardTf.placeholder = @"请输入你的银行卡号";
    bankCardTf.keyboardType = UIKeyboardTypeDefault;
    bankCardTf.delegate = self;
    [bankcardNoView addSubview:bankCardTf];
    self.bankCardTF = bankCardTf;
    
    
    
    UIView *codeRightView = [[UIView alloc] initWithFrame:CGRectMake(bankcardNoView.width - 50,0,40,40)];
    UIButton * scanBankCardButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [scanBankCardButton setImage:[UIImage mc_imageNamed:@"lx_card_scan"] forState:0];
    scanBankCardButton.frame = CGRectMake(0, 0,40,40);
    scanBankCardButton.tag = 1001;
    [scanBankCardButton addTarget:self action:@selector(clickScan:) forControlEvents:UIControlEventTouchUpInside];
    [codeRightView addSubview:scanBankCardButton];
    [bankcardNoView addSubview:codeRightView];
    
    
    
    
    UIView * phoneView = [[UIView alloc] initWithFrame:CGRectMake(bankcardNoView.left, bankcardNoView.bottom + margin, bankcardNoView.width, bankcardNoView.height)];
    phoneView.layer.cornerRadius = 6;
    phoneView.layer.masksToBounds = YES;
    phoneView.layer.borderColor =  [UIColor qmui_colorWithHexString:@"#F1F1F1"].CGColor;
    phoneView.layer.borderWidth = 1;
    [scrollView addSubview:phoneView];
    
    
    UILabel * phoneTitleLabel = [self labelWithFrame:CGRectMake(0, 0, 100, nameView.height) text:@"银行预留手机号" textColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:14]];
    [phoneView addSubview:phoneTitleLabel];
    UIView * phoneLineView = [[UIView alloc] initWithFrame:CGRectMake(phoneTitleLabel.right, 5, 1, phoneTitleLabel.height - 10)];
    phoneLineView.backgroundColor = [UIColor qmui_colorWithHexString:@"#F1F1F1"];
    [phoneView addSubview:phoneLineView];
    UITextField *phoneTf = [[UITextField alloc] initWithFrame:CGRectMake(phoneLineView.right + 5, 0, phoneView.width - phoneLineView.height - 5 - margin, phoneView.height)];
    phoneTf.textColor = [UIColor qmui_colorWithHexString:@"#333333"];
    phoneTf.textAlignment = NSTextAlignmentLeft;
    phoneTf.font = [UIFont systemFontOfSize:14];
    phoneTf.tintColor = [UIColor lightGrayColor];
    phoneTf.placeholder = @"请输入你的手机号";
    phoneTf.keyboardType = UIKeyboardTypeDefault;
    phoneTf.delegate = self;
    [phoneView addSubview:phoneTf];
    self.phoneTf = phoneTf;
    
    
    
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, phoneView.bottom + margin, scrollView.width, 10)];
    
    


    
    
    
    lineView.backgroundColor = [UIColor qmui_colorWithHexString:@"#F1F1F1"];
    [scrollView addSubview:lineView];
    
    // 2. 拍摄区
    // 头部文字
    NSString *headerMessage = @"请拍摄并上传";
    UILabel *headerMessageLabel = [self labelWithFrame:CGRectMake(margin, lineView.bottom, scrollView.width - margin * 2, 60) text:headerMessage textColor:[UIColor qmui_colorWithHexString:@"#333333"] textAlignment:(NSTextAlignmentCenter) font:[UIFont systemFontOfSize:13]];
    headerMessageLabel.numberOfLines = 0;
    [scrollView addSubview:headerMessageLabel];
    // 示例图片
    CGFloat showImageMargin = 10;
    CGFloat showImageW = (SCREEN_WIDTH - showImageMargin * 4) / 2;
    CGFloat showImageH = showImageW *0.8;
    NSArray *showImageArr = @[@"common_shiming_01_new", @"common_shiming_02_new"];
    for (int i = 0; i < showImageArr.count; i++) {
        UIButton *tempButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        tempButton.frame = CGRectMake(showImageMargin + (showImageW + showImageMargin) * i, headerMessageLabel.bottom, showImageW, showImageH);
        [tempButton setBackgroundImage:[UIImage mc_imageNamed:showImageArr[i]] forState:(UIControlStateNormal)];
   
        [scrollView addSubview:tempButton];
    }
    // 箭头
    UIImageView *downArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake((scrollView.width - 20) / 2, headerMessageLabel.bottom + showImageH + 5, 20, 25)];
    downArrowImageView.image = [UIImage mc_imageNamed:@"common_shiming_down"];
    [scrollView addSubview:downArrowImageView];
    // 拍摄按钮
    CGFloat buttonMargin = 10;
    CGFloat buttonW = (SCREEN_WIDTH - buttonMargin * 4) / 2;
    CGFloat buttonH = buttonW *0.8;
    UIButton *frontPhotoButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    frontPhotoButton.frame = CGRectMake(buttonMargin, downArrowImageView.bottom + 5, showImageW, showImageH);
    frontPhotoButton.tag = 0;
    [frontPhotoButton setBackgroundImage:[UIImage mc_imageNamed:@"common_realname_add_01"] forState:0];
//    [frontPhotoButton setImage:[UIImage mc_imageNamed:@"common_realname_add_01"] forState:(UIControlStateNormal)];
    [frontPhotoButton addTarget:self action:@selector(showImageButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [scrollView addSubview:frontPhotoButton];
    self.frontPhotoButton = frontPhotoButton;
    UIButton *backPhotoButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    backPhotoButton.frame = CGRectMake(frontPhotoButton.right + buttonMargin, frontPhotoButton.top, showImageW, showImageH);
    backPhotoButton.tag = 1;
    [backPhotoButton setBackgroundImage:[UIImage mc_imageNamed:@"common_realname_add_02"] forState:0];
//    [backPhotoButton setImage:[UIImage mc_imageNamed:@"common_realname_add_02"] forState:(UIControlStateNormal)];
    [backPhotoButton addTarget:self action:@selector(showImageButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [scrollView addSubview:backPhotoButton];
    self.backPhotoButton = backPhotoButton;
//    UIButton *personPhotoButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    personPhotoButton.frame = CGRectMake(backPhotoButton.right + buttonMargin, backPhotoButton.top, showImageW, showImageH);
//    personPhotoButton.tag = 2;
//    [personPhotoButton setImage:[UIImage mc_imageNamed:@"common_realname_add_03"] forState:0];
//
//    [personPhotoButton addTarget:self action:@selector(photoButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
//    [scrollView addSubview:personPhotoButton];
//    self.personPhotoButton = personPhotoButton;
    
    // 3. 底部说明文字
    NSString *bottomMessage = @"•请保证您的年龄符合18-80周岁\n\n•必须上传身份证的正反面\n\n•未达到示例标准、照片不清晰、经过编辑处理等非正常拍摄都不予通过";
    CGFloat bottomMessageH = [self stringHeightWithString:bottomMessage width:scrollView.width - margin * 2 font:[UIFont systemFontOfSize:12]];
    UILabel *bottomMessageLabel = [self labelWithFrame:CGRectMake(margin, backPhotoButton.bottom + margin+20, scrollView.width - margin * 2, bottomMessageH+20) text:bottomMessage textColor:[UIColor qmui_colorWithHexString:@"#333333"] textAlignment:(NSTextAlignmentLeft) font:[UIFont systemFontOfSize:13]];
    bottomMessageLabel.numberOfLines = 0;
    [scrollView addSubview:bottomMessageLabel];
    
    // 4. 提交按钮
    UIButton *submitButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    submitButton.frame = CGRectMake(margin, bottomMessageLabel.bottom + 50, scrollView.width - margin * 2, 50);
    submitButton.backgroundColor = MAINCOLOR;
    submitButton.layer.cornerRadius = 6;
    submitButton.layer.masksToBounds = YES;
    submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [submitButton setTitle:@"立即认证" forState:(UIControlStateNormal)];
    [submitButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    submitButton.tag = 2;
    [scrollView addSubview:submitButton];
    
    // 修改容器高度
    //scrollView.contentSize = CGSizeMake(ScreenWidth, submitButton.LY_bottom + margin);
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,CGRectGetMaxY(submitButton.frame)+NavigationContentTop + margin);
}

- (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)alignment font:(UIFont *)font {
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    lab.text = text;
    lab.textColor = textColor;
    lab.textAlignment = alignment;
    lab.font = font;
    return lab;
}

- (CGFloat)stringHeightWithString:(NSString *)string width:(CGFloat)width font:(UIFont *)font {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.height;
}

//textField代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField isExclusiveTouch]) {
        [textField resignFirstResponder];
    }
    return YES;
}



-(void)showImageButtonClick:(UIButton *)btn{
    self.index = btn.tag;
    UIViewController *current = MCLATESTCONTROLLER;
    __weak __typeof(self)weakSelf = self;
    if (btn.tag == 0) {
        self.zhengmianfanmian = ZhengMian;
    }
    if (btn.tag == 1) {
        self.zhengmianfanmian = FanMian;
    }

    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied) {
            [MCToast showMessage:@"请在设置-隐私-相机界面，打开相机权限"];
            return;
        }
        
        //调用身份证大小的相机
        DDPhotoViewController *vc = [[DDPhotoViewController alloc] init];
 
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        vc.imageblock = ^(UIImage *image) {
           
            if ([self.zhengmianfanmian isEqualToString:ZhengMian]) {
                self.imageOne = image;
                [self.frontPhotoButton setImage:image forState:(UIControlStateNormal)];
                [self requestDataForUploadImages:self.imageOne fileName:@"one"];
            }else{
                //向服务器上传身份证反面
                self.imageTwo = image;
                [self.backPhotoButton setImage:image forState:(UIControlStateNormal)];
                [self requestDataForUploadImages:self.imageTwo fileName:@"two"];
            }
            
        };
        [self presentViewController:vc animated:YES completion:nil];
    }];
    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"选择照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = NO;
        [current presentViewController:pickerImage animated:YES completion:nil];
    }];
    [alertVc addAction:cancle];
    [alertVc addAction:camera];
    [alertVc addAction:picture];
    [current presentViewController:alertVc animated:YES completion:nil];
}
#pragma mark Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        if ([self.zhengmianfanmian isEqualToString:ZhengMian]) {
            self.imageOne = info[UIImagePickerControllerOriginalImage];
            [self.frontPhotoButton setImage:info[UIImagePickerControllerOriginalImage] forState:(UIControlStateNormal)];
            [self requestDataForUploadImages:self.imageOne fileName:@"one"];
        }else{
            //向服务器上传身份证反面
            self.imageTwo = info[UIImagePickerControllerOriginalImage];
            [self.backPhotoButton setImage:info[UIImagePickerControllerOriginalImage] forState:(UIControlStateNormal)];
            [self requestDataForUploadImages:self.imageTwo fileName:@"two"];
        }
    }
    

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//#pragma mark --- TARGET METHOD
///// 1. 示例图片按钮点击事件
//- (void)showImageButtonClick:(UIButton *)sender {
//
//    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2, 0, 0)];
//    tempImageView.image = sender.imageView.image;
//    [LYImageMagnification scanBigImageWithImageView:tempImageView alpha:.6];
//}
/// 2. 拍摄按钮点击事件
//- (void)photoButtonClick:(UIButton *)sender {
//
//    self.index = sender.tag;
//    if (self.index == 2) {
//        [self shiming];
//    }else{
//        // 拍照
//        [self getImageFromIpc];
//    }
//
//}
-(void)shiming{
    // UI设置，默认不用设置
    NSDictionary *uiConfig = @{
       @"bottomAreaBgColor":@"F08300"    //屏幕下方颜色 026a86
       ,@"navTitleColor": @"FFFFFF"      // 导航栏标题颜色 FFFFFF
       ,@"navBgColor": @"F08300"         // 导航栏背景颜色 0186aa
       ,@"navTitle": @"人脸识别"          // 导航栏标题 活体检测
       ,@"navTitleSize":@"18"            // 导航栏标题大小 20
    };
    NSDictionary *param = @{@"actions":@"1279", @"actionsNum":@"1",
                            @"uiConfig":uiConfig};
#if TARGET_IPHONE_SIMULATOR  //模拟器

#else if TARGET_OS_IPHONE      //真机
    
    [[Liveness shareInstance] startProcess:self withParam:param withDelegate:self];
#endif
}
#pragma mark -----------活物识别完成,回调到这个界面---------------
- (void)onLiveDetectCompletion:(NSDictionary *)result{
    //code=0 代表监测成功
    __weak __typeof(self)weakSelf = self;
    if ([result[@"code"] integerValue] == 0) {
        NSString *code = [result objectForKey:@"code"];
        // 错误信息
        NSString *msg = [result objectForKey:@"msg"];
        NSString *base64String = [result objectForKey:@"passFace"];
        // 将base64字符串转为NSData
        NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:base64String options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
        // 将NSData转为UIImage
        UIImage *decodedImage = [UIImage imageWithData: decodeData];
        //身份证上传
        self.imageThree = decodedImage;
        [self requestDataForUploadImages:decodedImage fileName:@"three"];
      
    }else{
        [MCToast showMessage:result[@"msg"]];
    }
}
/// 3. 提交按钮点击事件
- (void)submitButtonClick
{
    //百度人脸
//    [self baiduFace];
//    return;
    
    
    self.index = 2;
    // 判断
    if (self.nameTF.text.length == 0 ) {
        [self showAlertWithMessage:@"请填写姓名"];
        return;
    }
    if (self.idCardTF.text.length == 0 ) {
        [self showAlertWithMessage:@"请填写身份证号"];
        return;
    }
    if (self.bankCardTF.text.length == 0 ) {
        [self showAlertWithMessage:@"请填写储蓄卡号"];
        return;
    }
    if (self.phoneTf.text.length == 0) {
        [self showAlertWithMessage:@"请填写银行预留手机号"];
        return;
    }
    if (self.imageOne == nil || self.imageTwo == nil) {
        [self showAlertWithMessage:@"请上传身份证正反面图片！"];
        return;
    }
    
    [self shiming];
    // 请求提交
//    [self requestDataForCheckInputInfo];
}
#pragma mark --- DELEGATE
-(void)clickScan:(UIButton *)btn{
    self.ocrIndex = btn.tag;
__weak __typeof(self)weakSelf = self;
AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
if (authStatus == AVAuthorizationStatusDenied) {
    [MCToast showMessage:@"请在设置-隐私-相机界面，打开相机权限"];
    return;
}

//调用身份证大小的相机
DDPhotoViewController *vc = [[DDPhotoViewController alloc] init];
vc.modalPresentationStyle = UIModalPresentationFullScreen;
vc.imageblock = ^(UIImage *image) {
    [self uploadBankImage:image];
};
[MCLATESTCONTROLLER presentViewController:vc animated:YES completion:nil];
}
//#pragma mark - 上传银行卡图片
- (void)uploadBankImage:(UIImage *)image {
__weak __typeof(self)weakSelf = self;
[MCSessionManager.shareManager mc_UPLOAD:@"/api/v1/player/upload/ORC" parameters:@{} images:@[image] remoteFields:@[@"bankFile"] imageNames:@[@"bankFile"] imageScale:0.1 imageType:nil ok:^(NSDictionary * _Nonnull resp) {
    
    if (resp[@"fileUrl"]) {
        if (self.ocrIndex == 1001) {
            weakSelf.bankURL = resp[@"fileUrl"];
        }
        
        NSDictionary *param = @{
                                @"link":resp[@"fileUrl"],
                                @"orcType": self.ocrIndex == 1001 ? @"BankCard" :@"IdCard",
                                };
        kWeakSelf(self);
        [MCSessionManager.shareManager mc_Post_QingQiuTi:@"/api/v1/player/orc" parameters:param ok:^(NSDictionary * _Nonnull resp) {
            NSString * no = [NSString stringWithFormat:@"%@",resp[@"number"]];
         
            if (self.ocrIndex == 1001) {
              
                NSMutableString *string = [NSMutableString string];
                for (int i = 0; i < no.length; i++) {
                    [string appendString:[no substringWithRange:NSMakeRange(i, 1)]];
                    if (i % 4 == 3) {
                        [string appendString:@" "];
                    }
                }
                weakSelf.bankCardTF.text = [NSString stringWithFormat:@"%@",string];
            }else{
                weakSelf.idCardTF.text = no;
            }
        } other:^(NSDictionary * _Nonnull resp) {

        } failure:^(NSError * _Nonnull error) {
            
        }];
    }


} other:^(NSDictionary * _Nonnull resp) {
    [MCLoading hidden];
    [MCToast showMessage:resp[@"messege"]];

} failure:^(NSError * _Nonnull error) {
    [MCLoading hidden];
    [MCToast showMessage:[NSString stringWithFormat:@"%ld\n%@", (long)error.code, error.localizedFailureReason]];
}];

}

#pragma mark --- PRIVATE METHOD
#pragma mark --- 调用系统相册的方法
//- (void)getImageFromIpc {
//
//    // 1. 判断是否可以打开相册
////    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
////
////        return;
////    }
//    // 2. 创建图片选择控制器
//    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
//    /**
//     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
//     UIImagePickerControllerSourceTypePhotoLibrary, // 相册
//     UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
//     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
//     }
//     */
//    // 3. 设置打开照片相册类型(显示所有相薄)
//    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    // 4. 设置代理
//    ipc.delegate = self;
//    // 5. modal出这个控制器
//    [self presentViewController:ipc animated:YES completion:nil];
//}
//#pragma mark --- UIImagePickerControllerDelegate代理方法
//// 1. 选择图片时调用
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//
//    // 销毁控制器
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    // 设置图片
//    if (self.index == 0) {
//        self.imageOne = info[UIImagePickerControllerOriginalImage];
//        [self.frontPhotoButton setImage:info[UIImagePickerControllerOriginalImage] forState:(UIControlStateNormal)];
//        [self requestDataForUploadImages:self.imageOne fileName:@"one"];
//
//    }
//    if (self.index == 1) {
//        self.imageTwo = info[UIImagePickerControllerOriginalImage];
//        [self.backPhotoButton setImage:info[UIImagePickerControllerOriginalImage] forState:(UIControlStateNormal)];
//        [self requestDataForUploadImages:self.imageTwo fileName:@"two"];
//
//    }
//    if (self.index == 2) {
//        self.imageThree = info[UIImagePickerControllerOriginalImage];
//        [self.personPhotoButton setImage:info[UIImagePickerControllerOriginalImage] forState:(UIControlStateNormal)];
//        [self requestDataForUploadImages:self.imageThree fileName:@"three"];
//
//    }
//}
//
//// 2. 取消选择时调用
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark --- SET DATA
//------ 传入姓名身份证号数据请求(用来判定是否可以上传图片) ------//
- (void)requestDataForCheckInputInfo {
    NSString *idCardNo = [self.idCardTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *debitCardNo = [self.bankCardTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    
    
    if (self.nameTF.text.length == 0) {
        [MCToast showMessage:@"请填写姓名"];
        return;
    }
    if (idCardNo.length == 0) {
        [MCToast showMessage:@"请填写身份证号"];
        return;
    }
//    if (debitCardNo.length == 0) {
//        [MCToast showMessage:@"请填写储蓄卡号"];
//        return;
//    }
    if (self.bankURL.length == 0) {
        [MCToast showMessage:@"请扫描上传银行卡"];
        return;
    }
    if (self.phoneTf.text.length == 0) {
        [MCToast showMessage:@"请填写银行预留手机号"];
        return;
    }
    if (!self.imageOneURL) {
        [MCToast showMessage:@"请上传身份证正面照"];
        return;
    }
    if (!self.imageTwoURL) {
        [MCToast showMessage:@"请上传身份证反面照"];
        return;
    }
    if (!self.imageThreeURL) {
        [MCToast showMessage:@"请进行活体检测"];
        return;
    }


    /* token  realname:真实姓名  idcard:身份证号  */
    NSDictionary *param = @{@"name":self.nameTF.text,
                            @"idCardNo":idCardNo,
                            @"debitCardNo":debitCardNo,
                            @"faceUrl":self.imageThreeURL,
                            @"idCardBackUrl":self.imageTwoURL,
                            @"idCardFrontUrl":self.imageOneURL,
                            @"bankPhone":self.phoneTf.text,
                            @"debitCardUrl":self.bankURL

    };
    __weak __typeof(self)weakSelf = self;
    [[MCSessionManager shareManager] mc_Post_QingQiuTi:@"/api/v1/player/user/certification" parameters:param ok:^(NSDictionary * _Nonnull resp) {
        NSDictionary * dic = [NSDictionary dictionaryWithDictionary:resp];
        if ([dic[@"certification"] integerValue] == 1) {
            [MCToast showMessage:@"实名认证成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [MCToast showMessage:dic[@"message"]];
        }
        
        [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
           
        }];
        
    } other:^(NSDictionary * _Nonnull resp) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}
//------ 上传图片 ------//
- (void)requestDataForUploadImages:(UIImage *)selectImg fileName:(NSString *)name{
    NSString *phone = SharedUserInfo.phone;
    NSDictionary *uploadDic = @{};
    NSArray *imagesArr = @[selectImg];
    __weak __typeof(self)weakSelf = self;
    [MCSessionManager.shareManager mc_UPLOAD:@"/api/v1/player/upload/IdCard" parameters:uploadDic images:imagesArr remoteFields:nil imageNames:@[name] imageScale:0.0001 imageType:nil ok:^(NSDictionary * _Nonnull resp) {
        NSDictionary * dic = [NSDictionary dictionaryWithDictionary:resp];
        // 设置图片
        if (self.index == 0) {
            self.imageOneURL = dic[@"fileUrl"];
        }
        if (self.index == 1) {
            self.imageTwoURL = dic[@"fileUrl"];
        }
        if (self.index == 2) {
            self.imageThreeURL = dic[@"fileUrl"];
            [self requestDataForCheckInputInfo];
        }
//        [MCToast showMessage:@"提交成功，请耐心等待审核通过"];
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//        [UIApplication sharedApplication].keyWindow.rootViewController = [MGJRouter objectForURL:rt_user_realname];
    } other:nil failure:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)baiduFace {
    NSArray *images = @[self.imageOne,self.imageTwo,self.imageThree];
    NSArray *imageNames = @[@"idCardTop",@"idCardBack",@"imageFace"];
    [MCSessionManager.shareManager mc_UPLOAD:@"/paymentgateway/baidu/idcard/getScore" parameters:nil images:images remoteFields:imageNames imageNames:imageNames imageScale:0.0001 imageType:nil ok:^(NSDictionary * _Nonnull resp) {
        MCLog(@"成功，%@",resp[@"result"]);
        [UIApplication sharedApplication].keyWindow.rootViewController = [MGJRouter objectForURL:rt_user_realname];
    } other:^(NSDictionary * _Nonnull resp) {
        //MCLog(@"%@",resp[@"result"]);
    } failure:^(NSError * _Nonnull error) {
        //MCLog(@"%@",error);
    }];
}

@end
