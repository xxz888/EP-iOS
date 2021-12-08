//
//  MCChuxukaHeader.m
//  MCOEM
//
//  Created by wza on 2020/4/24.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCChuxukaHeader.h"
#import "BankCardTextField.h"
#import <BRPickerView/BRPickerView.h>
#import "MCTXManager.h"
#import "KDPhoneAlertContent.h"
#import "DDPhotoViewController.h"
#import "KDCommonAlert.h"
@interface MCChuxukaHeader ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet BankCardTextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;

@property (weak, nonatomic) IBOutlet UIButton *wenhaoBtn;
@property (weak, nonatomic) IBOutlet UILabel *scanBtnBottomLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCons;
@property(nonatomic, strong) NSMutableArray<QMUIButton *> *buttons;
@property (weak, nonatomic) IBOutlet UIView *bgview;

@property(nonatomic, strong) BRAddressPickerView *addressPicker;
@property(nonatomic, strong) BRAddressPickerView *bankNameAddressPicker;

@property (weak, nonatomic) IBOutlet UIStackView *imgStack;
@property(nonatomic, strong) NSString * idCard;
@property (weak, nonatomic) IBOutlet UITextField *kaihuyinhangTf;
@property (nonatomic ,strong)NSString * selectBankId;
@property (weak, nonatomic) IBOutlet UITextField *kaihuzhihangTf;

@property(nonatomic, strong) NSString * provinceId;
@property(nonatomic, strong) NSString * cityId;

@end

@implementation MCChuxukaHeader
- (BRAddressPickerView *)addressPicker {
    if (!_addressPicker) {
        _addressPicker = [[BRAddressPickerView alloc] initWithPickerMode:BRAddressPickerModeCity];
        _addressPicker.title = @"请选择开户省市";
        _addressPicker.selectValues = @[@"上海市", @"上海市"];
        __weak __typeof(self)weakSelf = self;
        _addressPicker.resultBlock = ^(BRProvinceModel * _Nullable province, BRCityModel * _Nullable city, BRAreaModel * _Nullable area) {
            [MCLATESTCONTROLLER.sessionManager mc_GET:@"/api/v1/player/province" parameters:@{} ok:^(MCNetResponse * _Nonnull resp) {
                NSArray * respArry = [NSArray arrayWithArray:resp];
                for (NSDictionary * dic1 in respArry) {
                    if ([dic1[@"province"] containsString:province.name] || [province.name containsString:dic1[@"province"]]) {
                        for (NSDictionary * dic2 in dic1[@"cities"]) {
                            if ([dic2[@"city"] containsString:city.name] || [city.name containsString:dic1[@"city"]]) {
                                weakSelf.provinceId = [NSString stringWithFormat:@"%@",dic2[@"provinceId"]];
                                weakSelf.cityId = [NSString stringWithFormat:@"%@",dic2[@"cityId"]];
                                weakSelf.textField4.text = [NSString stringWithFormat:@"%@-%@",dic1[@"province"],dic2[@"city"]];
                            }
                        }
                    }
                }
            }];
        };
    }
    return _addressPicker;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.buttons = [NSMutableArray new];
   
    self.bgview.layer.cornerRadius = 12;
    
    [self.sureButton setBackgroundColor:[UIColor qmui_colorWithHexString:@"#F7874E"]];
    self.sureButton.layer.cornerRadius = self.sureButton.height/2;
    kWeakSelf(self);
//    [MCModelStore.shared reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
//        weakself.textField1.text = userInfo.realname;
//        weakself.idCard = userInfo.idcard;
//    }];


    UIView *vv = [self viewWithTag:2004];
    
    QMUIButton *b1 = [self creatButtonWithTitle:@"到账卡:用于刷卡到账、余额提现（必须绑定一张）"];
    QMUIButton *b2 = [self creatButtonWithTitle:@"充值卡:仅限于购买产品使用"];
    b1.selected = YES;
    b1.frame = CGRectMake(15, 0, vv.width-15, vv.height/2);
    b2.frame = CGRectMake(15, b1.bottom, vv.width-15, vv.height/2);
    [vv addSubview:b1];
    [vv addSubview:b2];
    
    self.textField2.delegate = self;
    self.textField4.delegate = self;
    self.kaihuzhihangTf.delegate = self;
    self.kaihuyinhangTf.delegate = self;
    [self.textField3 addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
}
- (void)textChanged:(UITextField *)textField {
    
    if (textField == self.textField3 && textField.text.length >= 11) {
        textField.text = [textField.text substringToIndex:11];
        return;
    }
}

- (QMUIButton *)creatButtonWithTitle:(NSString *)title {
    QMUIButton *button = [[QMUIButton alloc] qmui_initWithImage:[UIImage mc_imageNamed:@"card_no"] title:title];
    [button setImage:[UIImage mc_imageNamed:@"card_no"] forState:UIControlStateNormal];
    UIImage *hlImg = [[UIImage mc_imageNamed:@"card_yes"] imageWithColor: UIColor.mainColor];
    [button setImage:hlImg forState:UIControlStateSelected];
    [button addTarget:self action:@selector(checkTouched:) forControlEvents:UIControlEventTouchUpInside];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    button.titleLabel.font = UIFontMake(13);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:UIColorGrayLighten forState:UIControlStateNormal];
    [self.buttons addObject:button];
    return button;
}

- (void)checkTouched:(QMUIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    for (QMUIButton *bb in self.buttons) {
        bb.selected = NO;
    }
    sender.selected = YES;
}

- (IBAction)buttonTouched:(id)sender {
    
    if ([self verifyFailedTextField:self.textField1] ||
        [self verifyFailedTextField:self.textField2] ||
        [self verifyFailedTextField:self.textField3] ||
        [self verifyFailedTextField:self.textField4] ) {
        return;
    }
    if (self.model) {   //修改
        [self modifyChuxu];
    } else {    //新增
        [self bindChuxu];
    }
}

//新增储蓄卡
- (void)bindChuxu {
    NSArray *addr = [self.textField4.text componentsSeparatedByString:@"-"];
    NSString *cardNo = [self.textField2.mc_realText qmui_stringByReplacingPattern:@" " withString:@""];
    /*
     address*    string
     bank*    string
     Enum:
     [ ICBC ]
     bankCardNo*    string
     billingDate    integer($int32)
     cardType*    string
     Enum:
     [ CreditCard, DebitCard ]
     cvc    string
     name*    string
     phone*    string
     repaymentDate    integer($int32)
     validPeriod    string
     
     **/
//    NSDictionary *param = @{@"realname":self.textField1.text,
//                            @"idcard":self.idCard,
//                            @"bankcard":cardNo,
//                            @"mobile":self.textField3.text,
//                            @"type":self.buttons[0].isSelected?@"2":@"0",
//                            @"province":addr[0],
//                            @"city":addr[1]};
    NSDictionary *param = @{
                            @"address":[self.textField4.text replaceAll:@"-" target:@""],
                            @"bankCardNo":cardNo,
                            @"bankId":self.selectBankId,
                            @"cardType":@"DebitCard",
                            @"name":self.textField1.text,
                            @"phone":self.textField3.text,
                            };
    kWeakSelf(self);
    [MCSessionManager.shareManager mc_Post_QingQiuTi:@"/api/v1/player/bank" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        [MCLATESTCONTROLLER.navigationController popViewControllerAnimated:YES];
    } other:^(MCNetResponse * _Nonnull resp) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
//    [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/user/app/bank/add/%@",TOKEN] parameters:param ok:^(MCNetResponse * _Nonnull resp) {
//        [MCToast showMessage:resp.messege];
//        [MCLATESTCONTROLLER.navigationController qmui_popViewControllerAnimated:YES completion:^{
//            if ([weakself.whereCome isEqualToString:@"1"]) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"mcNotificationWebContainnerReset" object:nil];
//            }else{
//                if (weakself.loginVC) {
//                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FIRSTSHIMING"];
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            [UIApplication sharedApplication].keyWindow.rootViewController = [MGJRouter objectForURL:rt_tabbar_list];
//                        });
//                }
//            }
//
//        }];
//    }];
}

//修改储蓄卡
- (void)modifyChuxu {
    return;
    NSString *cardNo = [self.textField2.mc_realText qmui_stringByReplacingPattern:@" " withString:@""];

    NSArray *addr = [self.textField4.text componentsSeparatedByString:@"-"];
    NSDictionary *param = @{@"userId":SharedUserInfo.userid,
                            @"bankCardNumber":cardNo,
                            @"province":addr[0],
                            @"city":addr[1]};
    [MCSessionManager.shareManager mc_POST:@"/user/app/bank/set/bankinfo/province/city" parameters:param ok:^(MCNetResponse * _Nonnull resp) {
        [MCToast showMessage:resp.messege];
        [MCLATESTCONTROLLER.navigationController popViewControllerAnimated:YES];
    }];
}


- (BOOL)verifyFailedTextField:(UITextField *)textField {
    if (textField.text.length < 1) {
        [MCToast showMessage:textField.placeholder];
        return YES;
    }
    if (textField == self.textField2 && textField.text.length < 16) {
        [MCToast showMessage:textField.placeholder];
        return YES;
    }
    if (textField == self.textField3 && textField.text.length < 11) {
        [MCToast showMessage:textField.placeholder];
        return YES;
    }
    if (textField == self.textField4 && textField.text.length < 1) {
        [MCToast showMessage:textField.placeholder];
        return YES;
    }
    return NO;
}

- (void)setModel:(MCBankCardModel *)model {
    _model = model;
    if (!model) {
        return;
    }
    self.topCons.constant = 423;
    UIView *vv = [self viewWithTag:2004];
    vv.hidden = YES;
    
    
    for (int i=2000; i<2003; i++) {
        UIView *vv = [self viewWithTag:i];
        vv.userInteractionEnabled = NO;
        vv.alpha = 0.3;
    }
    self.scanBtn.hidden = YES;
    self.scanBtnBottomLabel.hidden = YES;
    self.wenhaoBtn.hidden = YES;
    
    kWeakSelf(self);
//    [MCModelStore.shared reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
//        weakself.textField1.text = userInfo.realname;
//        weakself.idCard = userInfo.idcard;
//    }];
//
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < model.cardNo.length; i++) {
        [string appendString:[model.cardNo substringWithRange:NSMakeRange(i, 1)]];
        if (i % 4 == 3) {
            [string appendString:@" "];
        }
    }
    self.textField2.text = string;
    self.textField3.text = model.phone;
    self.textField4.text = [NSString stringWithFormat:@"%@-%@",model.province,model.city];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textField2) {
        [textField bankNoshouldChangeCharactersInRange:range replacementString:string];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.textField4) {
        [self endEditing:YES];
        [self.addressPicker show];
        return NO;
    }
    if (textField == self.kaihuyinhangTf) {
        [self endEditing:YES];
        [self selctBank];
        return NO;
    }
    if (textField == self.kaihuzhihangTf) {
        [self endEditing:YES];
        [self selectKaihuzhihang];
        return NO;
    }
    return YES;
}
-(void)selectProvince{
    NSString * proviceUrl = @"";
    __weak typeof(self) weakSelf = self;
    [MCLATESTCONTROLLER.sessionManager mc_GET:@"/api/v1/player/province" parameters:@{} ok:^(MCNetResponse * _Nonnull resp) {
        NSArray * respArry = [NSArray arrayWithArray:resp];
        
    }];
}
-(void)selctBank{
    if (self.provinceId.length == 0 || self.cityId.length == 0) {
        [MCToast showMessage:@"请先选择地区"];
        return;
    }
    NSString * proviceUrl = @"";
    __weak typeof(self) weakSelf = self;
    [MCLATESTCONTROLLER.sessionManager mc_GET:@"/api/v1/player/bank" parameters:@{} ok:^(MCNetResponse * _Nonnull resp) {
        NSArray * result = resp;
        NSMutableArray * modelArray = [[NSMutableArray alloc]init];
        for (NSDictionary * dic in result) {
            BRResultModel * model = [[BRResultModel alloc]init];
            model.key = dic[@"id"];
            model.value = dic[@"name"];
            [modelArray addObject:model];
        }
        BRStringPickerView *pickView = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
        pickView.title = @"请选择银行";
        pickView.dataSourceArr = modelArray;
        [pickView show];
        pickView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            weakSelf.selectBankId = [NSString stringWithFormat:@"%@",resultModel.key];
            weakSelf.kaihuyinhangTf.text = resultModel.name;
        };
        pickView.cancelBlock = ^{[UIView animateWithDuration:0.5 animations:^{}]; };
    }];
}
-(void)selectKaihuzhihang{
    if (self.provinceId.length == 0 || self.cityId.length == 0) {
        [MCToast showMessage:@"请先选择地区"];
        return;
    }
    if (self.selectBankId.length == 0 ) {
        [MCToast showMessage:@"请先选择开户银行"];
        return;
    }
    NSString * proviceUrl = @"";
    __weak typeof(self) weakSelf = self;
    NSString * url = [NSString stringWithFormat:@"/api/v1/player/bank/branch?provinceId=%@&cityId=%@&bankId=%@",self.provinceId,self.cityId,self.selectBankId];
    [MCLATESTCONTROLLER.sessionManager mc_GET:url parameters:@{} ok:^(MCNetResponse * _Nonnull resp) {
        NSArray * result = resp;
        NSMutableArray * modelArray = [[NSMutableArray alloc]init];
        for (NSDictionary * dic in result) {
            BRResultModel * model = [[BRResultModel alloc]init];
            model.key = dic[@"subBankCode"];
            model.value = dic[@"bankAddress"];
            [modelArray addObject:model];
        }
        BRStringPickerView *pickView = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
        pickView.title = @"请选择支行";
        pickView.dataSourceArr = modelArray;
        [pickView show];
        pickView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
//            weakSelf.selectBankId = [NSString stringWithFormat:@"%@",resultModel.key];
            weakSelf.kaihuzhihangTf.text = resultModel.value;
        };
        pickView.cancelBlock = ^{[UIView animateWithDuration:0.5 animations:^{}]; };
    }];
}
- (IBAction)scanTouched:(UIButton *)sender {
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
        [weakSelf.scanBtn setImage:image forState:UIControlStateNormal];
        [self uploadBankImage:image];
    };
    [MCLATESTCONTROLLER presentViewController:vc animated:YES completion:nil];
    
    
//    [MCTXManager.shared startBankOcrCompletion:^(MCTXResult * _Nonnull result) {
//        if (result.error == nil) {
//            NSString *no = result.brankCardNo;
//            NSMutableString *string = [NSMutableString string];
//            for (int i = 0; i < no.length; i++) {
//                [string appendString:[no substringWithRange:NSMakeRange(i, 1)]];
//                if (i % 4 == 3) {
//                    [string appendString:@" "];
//                }
//            }
//            weakSelf.textField2.text = string;
//            if (result.cardImg) {
//                [weakSelf.scanBtn setImage:result.cardImg forState:UIControlStateNormal];
//            }
//        }
//    }];
}


//#pragma mark - 上传银行卡图片
- (void)uploadBankImage:(UIImage *)image {
    __weak __typeof(self)weakSelf = self;
    [MCSessionManager.shareManager mc_UPLOAD:@"/paymentchannel/app/auth/bankcardocr" parameters:@{@"brandId":SharedConfig.brand_id} images:@[image] remoteFields:@[@"bankFile"] imageNames:@[@"bankFile"] imageScale:0.1 imageType:nil ok:^(MCNetResponse * _Nonnull resp) {
        //MCLog(@"%@",resp.result);
        if (resp.result[@"cardNum"] && [resp.result[@"cardNum"] length] > 10) {
            NSString * no = [NSString stringWithFormat:@"%@",resp.result[@"cardNum"]];
            NSMutableString *string = [NSMutableString string];
            for (int i = 0; i < no.length; i++) {
                [string appendString:[no substringWithRange:NSMakeRange(i, 1)]];
                if (i % 4 == 3) {
                    [string appendString:@" "];
                }
            }
            weakSelf.textField2.text = [NSString stringWithFormat:@"%@",string];
        }else{
            [MCToast showMessage:@"卡号识别失败，请手动填写卡号"];
        }


    } other:^(MCNetResponse * _Nonnull resp) {
        [MCLoading hidden];
        [MCToast showMessage:resp.messege];
        MCTXResult *rr = [[MCTXResult alloc] init];
        rr.error = [NSError errorWithDomain:resp.messege code:resp.code.intValue userInfo:nil];
    } failure:^(NSError * _Nonnull error) {
        [MCLoading hidden];
        [MCToast showMessage:[NSString stringWithFormat:@"%ld\n%@", (long)error.code, error.localizedFailureReason]];
        MCTXResult *rr = [[MCTXResult alloc] init];
        rr.error = error;
    }];
}

- (IBAction)alertPhone:(id)sender {
    QMUIModalPresentationViewController *diaV = [[QMUIModalPresentationViewController alloc] init];
    KDPhoneAlertContent *content = [KDPhoneAlertContent newFromNib];
    __block QMUIModalPresentationViewController *blockDiav = diaV;
    content.touchBlock = ^{
        [blockDiav hideWithAnimated:YES completion:nil];
    };
    diaV.contentView = content;
    [diaV showWithAnimated:YES completion:nil];
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
