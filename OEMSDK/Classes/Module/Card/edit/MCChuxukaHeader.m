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
#import "DDPhotoViewController.h"
#import "KDCommonAlert.h"

@interface MCChuxukaHeader ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

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
@property (weak, nonatomic) IBOutlet UITextField *sehfenzhengTf;

@property (weak, nonatomic) IBOutlet UIStackView *imgStack;
@property(nonatomic, strong) NSString * idCard;
@property (weak, nonatomic) IBOutlet UITextField *kaihuyinhangTf;
@property (nonatomic ,strong)NSString * bankId;
@property (weak, nonatomic) IBOutlet UITextField *kaihuzhihangTf;

@property (nonatomic ,strong)NSString * province;
@property(nonatomic, strong) NSString * provinceId;

@property (nonatomic ,strong)NSString * city;
@property(nonatomic, strong) NSString * cityId;

@property (nonatomic ,strong)NSString * subBankCode;
@property (nonatomic ,strong)NSString * subBankName;
@property (nonatomic ,strong)NSString * zhengmianUrl;
@property (nonatomic ,strong)NSString * fanmianUrl;

@property (weak, nonatomic) IBOutlet UIImageView *zhengmianImv;
@property (weak, nonatomic) IBOutlet UIImageView *fanmianImv;


@property (nonatomic ,assign)NSInteger selectTag;

@property(nonatomic,assign)BOOL isFanmian;
@end

@implementation MCChuxukaHeader
- (BRAddressPickerView *)addressPicker {
    if (!_addressPicker) {
        _addressPicker = [[BRAddressPickerView alloc] initWithPickerMode:BRAddressPickerModeCity];
        _addressPicker.title = @"请选择开户省市";
        _addressPicker.selectValues = @[@"上海市", @"上海市"];
        __weak __typeof(self)weakSelf = self;
        _addressPicker.resultBlock = ^(BRProvinceModel * _Nullable province, BRCityModel * _Nullable city, BRAreaModel * _Nullable area) {
            [MCLATESTCONTROLLER.sessionManager mc_GET:@"/api/v1/player/province" parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
                NSArray * respArry = [NSArray arrayWithArray:resp];
                for (NSDictionary * dic1 in respArry) {
                    if ([dic1[@"name"] containsString:province.name] || [province.name containsString:dic1[@"name"]]) {
                        for (NSDictionary * dic2 in dic1[@"cities"]) {
                            if ([dic2[@"name"] containsString:city.name] || [city.name containsString:dic2[@"name"]]) {
//                                weakSelf.provinceId = [NSString stringWithFormat:@"%@",dic2[@"provinceId"]];
                                weakSelf.cityId = [NSString stringWithFormat:@"%@",dic2[@"id"]];
                                
//                                weakSelf.province = dic1[@"province"];
                                weakSelf.city = dic2[@"name"];
                                weakSelf.textField4.text = [NSString stringWithFormat:@"%@%@",dic1[@"name"],dic2[@"name"]];
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
    self.isFanmian = NO;
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
    
    
    
    self.zhengmianImv.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickzhengmianImv:)];
    //别忘了添加到testView上
    [self.zhengmianImv addGestureRecognizer:tap];
    
    
    self.fanmianImv.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickfanmianImv:)];
    //别忘了添加到testView上
    [self.fanmianImv addGestureRecognizer:tap1];
    
    
    
    [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
        self.textField3.text = userInfo.phone;
        self.textField1.text = userInfo.name;
        self.sehfenzhengTf.text = userInfo.idCardNo;
    }];
    
    
    

    
}
-(void)clickzhengmianImv:(id)tap{
    self.isFanmian = NO;

    UIViewController *current = MCLATESTCONTROLLER;
    __weak __typeof(self)weakSelf = self;
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
            [self uploadBankImage:image];
        };
        [MCLATESTCONTROLLER presentViewController:vc animated:YES completion:nil];
        
        
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
-(void)clickfanmianImv:(id)tap{
    self.isFanmian = YES;

    
    
    UIViewController *current = MCLATESTCONTROLLER;
    __weak __typeof(self)weakSelf = self;
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
            [self uploadBankImage:image];
        };
        [MCLATESTCONTROLLER presentViewController:vc animated:YES completion:nil];
        
        
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
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self uploadBankImage:image];

        
       
     
        
        
    }
    

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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
    if (self.textField1.text.length ==0 ) {
        [MCToast showMessage:self.textField1.placeholder];
        return;
    }
    if (self.textField3.text.length ==0 ) {
        [MCToast showMessage:self.textField3.placeholder];
        return;
    }
    if (self.textField2.text.length ==0 ) {
        [MCToast showMessage:self.textField2.placeholder];
        return;
    }
    if (self.zhengmianUrl.length == 0) {
        [MCToast showMessage:@"请上传银行卡正面照片"];
        return;
    }
    if (self.fanmianUrl.length == 0) {
        [MCToast showMessage:@"请上传银行卡反面照片"];
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
     "bankCardNo": "string",
       "billingDate": 0,
       "cardType": "CreditCard",
       "cvc": "string",
       "phone": "string",
       "repaymentDate": 0,
       "validPeriod": "string"
     
     **/
//    NSDictionary *param = @{@"realname":self.textField1.text,
//                            @"idcard":self.idCard,
//                            @"bankcard":cardNo,
//                            @"mobile":self.textField3.text,
//                            @"type":self.buttons[0].isSelected?@"2":@"0",
//                            @"province":addr[0],
//                            @"city":addr[1]};
    NSDictionary *param = @{
                            @"bankCardBackUrl":self.fanmianUrl,
                            @"bankCardUrl":self.zhengmianUrl,
                            @"cardType":@"DebitCard",
                            @"name":self.textField1.text,
                            @"phone":self.textField3.text,
                            @"bankCardNo":cardNo
                            };
    kWeakSelf(self);
    [MCSessionManager.shareManager mc_Post_QingQiuTi:@"/api/v1/player/bank" parameters:param ok:^(NSDictionary * _Nonnull resp) {
        [MCLATESTCONTROLLER.navigationController popViewControllerAnimated:YES];
    } other:^(NSDictionary * _Nonnull resp) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
//    [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/user/app/bank/add/%@",TOKEN] parameters:param ok:^(NSDictionary * _Nonnull resp) {
//        [MCToast showMessage:resp[@"messege"]];
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

    NSString *cardNo = [self.textField2.mc_realText qmui_stringByReplacingPattern:@" " withString:@""];

    NSDictionary *param = @{
                            @"bankCardNo":cardNo,
                            @"cardType":@"DebitCard",
                            @"name":self.textField1.text,
                            @"phone":self.textField3.text,
                            @"id":self.model.id,
                            };
    [MCSessionManager.shareManager mc_put:@"/api/v1/player/bank" parameters:param ok:^(NSDictionary * _Nonnull respDic) {
        [MCToast showMessage:@"修改成功"];
        [MCLATESTCONTROLLER.navigationController popViewControllerAnimated:YES];
    } other:^(NSDictionary * _Nonnull respDic) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
//    NSString *cardNo = [self.textField2.mc_realText qmui_stringByReplacingPattern:@" " withString:@""];
//
//    NSArray *addr = [self.textField4.text componentsSeparatedByString:@"-"];
//    NSDictionary *param = @{@"userId":SharedUserInfo.userid,
//                            @"bankCardNumber":cardNo,
//                            @"province":addr[0],
//                            @"city":addr[1]};
//    [MCSessionManager.shareManager mc_POST:@"/user/app/bank/set/bankinfo/province/city" parameters:param ok:^(NSDictionary * _Nonnull resp) {
//        [MCToast showMessage:resp[@"messege"]];
//        [MCLATESTCONTROLLER.navigationController popViewControllerAnimated:YES];
//    }];
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
//    self.topCons.constant = 600;
    UIView *vv = [self viewWithTag:2004];
    vv.hidden = YES;
    
    
    self.scanBtn.hidden = YES;
    self.scanBtnBottomLabel.hidden = YES;
    self.wenhaoBtn.hidden = YES;
    
    kWeakSelf(self);
//    [MCModelStore.shared reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
//        weakself.textField1.text = userInfo.realname;
//        weakself.idCard = userInfo.idcard;
//    }];
//

    self.textField2.text = model.bankCardNo;
    self.textField4.text = [NSString stringWithFormat:@"%@%@",model.province,model.city];
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
//    if (textField == self.kaihuzhihangTf) {
//        [self endEditing:YES];
//        [self selectKaihuzhihang];
//        return NO;
//    }
    return YES;
}
-(void)selectProvince{
    NSString * proviceUrl = @"";
    __weak typeof(self) weakSelf = self;
    [MCLATESTCONTROLLER.sessionManager mc_GET:@"/api/v1/player/province" parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
        NSArray * respArry = [NSArray arrayWithArray:resp];
        
    }];
}
-(void)selctBank{
    if ( self.cityId.length == 0) {
        [MCToast showMessage:@"请先选择地区"];
        return;
    }
    NSString * proviceUrl = @"";
    __weak typeof(self) weakSelf = self;
    [MCLATESTCONTROLLER.sessionManager mc_GET:@"/api/v1/player/bank" parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
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
            weakSelf.bankId = [NSString stringWithFormat:@"%@",resultModel.key];
            weakSelf.kaihuyinhangTf.text = resultModel.name;
        };
        pickView.cancelBlock = ^{[UIView animateWithDuration:0.5 animations:^{}]; };
    }];
}
-(void)selectKaihuzhihang{
    if ( self.cityId.length == 0) {
        [MCToast showMessage:@"请先选择地区"];
        return;
    }
    if (self.bankId.length == 0 ) {
        [MCToast showMessage:@"请先选择开户银行"];
        return;
    }
    NSString * proviceUrl = @"";
    __weak typeof(self) weakSelf = self;
    NSString * url = [NSString stringWithFormat:@"/api/v1/player/bank/branch?cityId=%@&bankId=%@",self.cityId,self.bankId];
    [MCLATESTCONTROLLER.sessionManager mc_GET:url parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
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
            weakSelf.subBankCode = [NSString stringWithFormat:@"%@",resultModel.key];
            weakSelf.subBankName =  resultModel.value;
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
//fileName = "8d1e2b42c54846749144efd8d6c2cb1a.jpg";
//fileUrl = "https://wuuka.oss-cn-hongkong.aliyuncs.com/8d1e2b42c54846749144efd8d6c2cb1a.jpg";

//#pragma mark - 上传银行卡图片
- (void)uploadBankImage:(UIImage *)image {
    __weak __typeof(self)weakSelf = self;
    [MCSessionManager.shareManager mc_UPLOAD:@"/api/v1/player/upload/ORC" parameters:@{} images:@[image] remoteFields:@[@"bankFile"] imageNames:@[@"bankFile"] imageScale:0.1 imageType:nil ok:^(NSDictionary * _Nonnull resp) {
        if (resp[@"fileUrl"]) {
        
            if (weakSelf.isFanmian) {
                weakSelf.fanmianImv.image = image;
                weakSelf.fanmianUrl = resp[@"fileUrl"];
            }else{
                weakSelf.zhengmianImv.image = image;
                weakSelf.zhengmianUrl = resp[@"fileUrl"];
                kWeakSelf(self);
                NSDictionary *param = @{
                                        @"link":resp[@"fileUrl"],
                                        @"orcType":@"BankCard",
                                        };
                [MCSessionManager.shareManager mc_Post_QingQiuTi:@"/api/v1/player/orc" parameters:param ok:^(NSDictionary * _Nonnull resp) {
                    NSString * no = [NSString stringWithFormat:@"%@",resp[@"number"]];
                    NSMutableString *string = [NSMutableString string];
                    for (int i = 0; i < no.length; i++) {
                        [string appendString:[no substringWithRange:NSMakeRange(i, 1)]];
                        if (i % 4 == 3) {
                            [string appendString:@" "];
                        }
                    }
                    weakSelf.textField2.text = [NSString stringWithFormat:@"%@",string];
                } other:^(NSDictionary * _Nonnull resp) {

                } failure:^(NSError * _Nonnull error) {
                    
                }];
                

            }
   
     
        }


    } other:^(NSDictionary * _Nonnull resp) {
        [MCLoading hidden];
        [MCToast showMessage:resp[@"messege"]];
        MCTXResult *rr = [[MCTXResult alloc] init];
//        rr.error = [NSError errorWithDomain:resp[@"messege"] code:resp[@"code"].intValue userInfo:nil];
    } failure:^(NSError * _Nonnull error) {
        [MCLoading hidden];
        [MCToast showMessage:[NSString stringWithFormat:@"%ld\n%@", (long)error.code, error.localizedFailureReason]];
        MCTXResult *rr = [[MCTXResult alloc] init];
        rr.error = error;
    }];
    
}

- (IBAction)alertPhone:(id)sender {
   
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
