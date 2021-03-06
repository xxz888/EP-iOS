//
//  MCXinyongkaHeader.m
//  MCOEM
//
//  Created by wza on 2020/4/24.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCXinyongkaHeader.h"
#import "BankCardTextField.h"
#import <BRPickerView/BRPickerView.h>
#import "MCTXManager.h"
#import "DDPhotoViewController.h"
@interface MCXinyongkaHeader ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet BankCardTextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;
@property (weak, nonatomic) IBOutlet UITextField *textField5;
@property (weak, nonatomic) IBOutlet UITextField *textField6;
@property (weak, nonatomic) IBOutlet UITextField *textField7;


@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UILabel *desc2;

@property (weak, nonatomic) IBOutlet UIView *bg1;
@property (weak, nonatomic) IBOutlet UIView *bg2;

@property(nonatomic, copy) NSString *lastDate;

@property(nonatomic, strong) BRStringPickerView *zdDayPicker;   //账单日
@property(nonatomic, strong) BRStringPickerView *hkDayPicker;   //还款日

@property (weak, nonatomic) IBOutlet QMUIButton *scanBtn;
@property (weak, nonatomic) IBOutlet BankCardTextField *kaihuyinhangTf;
@property (nonatomic ,strong)NSString * selectBankId;
@property (nonatomic ,strong)NSString * bankCardUrl;


@end



@implementation MCXinyongkaHeader



- (BRStringPickerView *)zdDayPicker {
    if (!_zdDayPicker) {
        _zdDayPicker = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
        _zdDayPicker.title = @"请选择账单日";
        NSMutableArray *tempA = [NSMutableArray new];
        for (int i=1; i<32; i++) {
            [tempA addObject:[NSString stringWithFormat:@"%d",i]];
        }
        _zdDayPicker.dataSourceArr = tempA;
        __weak __typeof(self)weakSelf = self;
        _zdDayPicker.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            //MCLog(@"%@",resultModel.value);
            weakSelf.textField6.text = [NSString stringWithFormat:@"%@日",resultModel.value];
        };
    }
    return _zdDayPicker;
}
- (BRStringPickerView *)hkDayPicker {
    if (!_hkDayPicker) {
        _hkDayPicker = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
        _hkDayPicker.title = @"请选择还款日";
        NSMutableArray *tempA = [NSMutableArray new];
        for (int i=1; i<32; i++) {
            [tempA addObject:[NSString stringWithFormat:@"%d",i]];
        }
        _hkDayPicker.dataSourceArr = tempA;
        __weak __typeof(self)weakSelf = self;
        _hkDayPicker.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            //MCLog(@"%@",resultModel.value);
            weakSelf.textField7.text = [NSString stringWithFormat:@"%@日",resultModel.value];
        };
    }
    return _hkDayPicker;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.desc2.textColor =  UIColor.mainColor;
    
    [self.sureButton setBackgroundColor:[UIColor qmui_colorWithHexString:@"#F7874E"]];
    self.sureButton.layer.cornerRadius = self.sureButton.height/2;
    
//    self.textField1.text = SharedUserInfo.realname;
    self.textField2.delegate = self;
    
    [self.textField3 addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.textField4 addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.textField5 addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.textField6.delegate = self;
    self.textField7.delegate = self;
    self.kaihuyinhangTf.delegate = self;
    self.scanBtn.imagePosition = QMUIButtonImagePositionTop;
    self.scanBtn.spacingBetweenImageAndTitle = 2;
    
    self.bg1.layer.cornerRadius = 12;
    self.bg2.layer.cornerRadius = 12;

}
-(void)setData{
    self.textField1.text = self.shimingName;
    self.textField3.text = self.shimingPhone;
}
- (void)textChanged:(UITextField *)textField {
    
    if (textField == self.textField3 && textField.text.length >= 11) {
        textField.text = [textField.text substringToIndex:11];
        return;
    }
    if (textField == self.textField4 && textField.text.length >= 4) {
        textField.text = [textField.text substringToIndex:4];
        return;
    }
    if(textField == self.textField5) { //有效期
        if(self.textField5.text.length == 2){
            if(self.lastDate.length == 3){
                self.textField5.text = [NSString stringWithFormat:@"%@", [self.textField5.text substringToIndex:1]];
            } else {
                self.textField5.text = [NSString stringWithFormat:@"%@/", self.textField5.text];
            }
        }
        if (textField.text.length >= 5) {
            textField.text = [textField.text substringToIndex:5];
        }
        self.lastDate = self.textField5.text;
        return;
    }
}

- (IBAction)buttonTouched:(id)sender {

    if ([self verifyFailedTextField:self.textField1] ||
        [self verifyFailedTextField:self.kaihuyinhangTf] ||
         [self verifyFailedTextField:self.textField5] ||
         [self verifyFailedTextField:self.textField4] ||
        [self verifyFailedTextField:self.textField6] ||
        [self verifyFailedTextField:self.textField7] ||
         [self verifyFailedTextField:self.textField3]) {
        return;
    }
    if (self.model) {   //修改
        [self modifyXinyong];
    } else {    //新增
        [self bindXinyong];
    }

}
//新增信用卡
- (void)bindXinyong {
    if (self.bankCardUrl.length == 0) {
        [MCToast showMessage:@"请上传信用卡照片"];
        return;
    }
    NSArray *addr = [self.textField4.text componentsSeparatedByString:@"-"];
    NSString *cardNo = [self.kaihuyinhangTf.mc_realText qmui_stringByReplacingPattern:@" " withString:@""];
    /*
     {
     bankCardNo*    string
     bankId*    integer($int32)
     billingDate    integer($int32)
     cardType*    string
     Enum:
     [ CreditCard, DebitCard ]
     city    string
     cityId    integer($int32)
     cvc    string
     phone*    string
     province    string
     provinceId    integer($int32)
     repaymentDate    integer($int32)
     subBankCode    string
     subBankName    string
     validPeriod    string
     }
     
     **/

    NSDictionary *param = @{
                            @"bankCardUrl":self.bankCardUrl,
                            @"bankCardNo": cardNo,
                            @"billingDate":[self.textField6.text substringToIndex:self.textField6.text.length-1],
                            @"cardType":@"CreditCard",
                            @"cvc":self.textField4.text,
                            @"phone":self.textField3.text,
                            @"repaymentDate":[self.textField7.text substringToIndex:self.textField7.text.length-1],
                            @"validPeriod":[self.textField5.text replaceAll:@"/" target:@""],

                            };
    kWeakSelf(self);
    [MCSessionManager.shareManager mc_Post_QingQiuTi:@"/api/v1/player/bank" parameters:param ok:^(NSDictionary * _Nonnull resp) {
        [MCLATESTCONTROLLER.navigationController popViewControllerAnimated:YES];
    } other:^(NSDictionary * _Nonnull resp) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
//    NSString *cardNo = [self.textField2.mc_realText qmui_stringByReplacingPattern:@" " withString:@""];
//    NSDictionary *param = @{@"realname":self.textField1.text,
//                            @"idcard":SharedUserInfo.idcard,
//                            @"bankcard":cardNo,
//                            @"mobile":self.textField3.text,
//                            @"securitycode":self.textField4.text,
//                            @"expiretime":self.textField5.text,
//                            @"repaymentDay":[self.textField7.text substringToIndex:self.textField7.text.length-1],
//                            @"billDay":[self.textField6.text substringToIndex:self.textField6.text.length-1]
//                            };
//    //MCLog(@"%@",param);
//    [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/user/app/bank/add/%@",TOKEN] parameters:param ok:^(NSDictionary * _Nonnull resp) {
//        [MCToast showMessage:resp[@"messege"]];
//
//        //新增成功之后发送一个通知让 KDWebContainer 重新加载
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"mcNotificationWebContainnerReset" object:nil];
//        });
//
//        [MCLATESTCONTROLLER.navigationController popViewControllerAnimated:YES];
//    }];
}
//修改信用卡
- (void)modifyXinyong {
    NSDictionary *param = @{
                            @"bankCardNo":self.kaihuyinhangTf.text,
                            @"billingDate":[self.textField6.text substringToIndex:self.textField6.text.length-1],
                            @"cardType":@"CreditCard",
                            @"cvc":self.textField4.text,
                            @"phone":self.textField3.text,
                            @"repaymentDate":[self.textField7.text substringToIndex:self.textField7.text.length-1],
                            @"validPeriod":[self.textField5.text replaceAll:@"/" target:@""],
                            @"id":self.model.id

                            };
    [MCSessionManager.shareManager mc_put:@"/api/v1/player/bank" parameters:param ok:^(NSDictionary * _Nonnull respDic) {
        [MCToast showMessage:@"修改成功"];
        [MCLATESTCONTROLLER.navigationController popViewControllerAnimated:YES];
    } other:^(NSDictionary * _Nonnull respDic) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (BOOL)verifyFailedTextField:(UITextField *)textField {
    if (textField == self.textField1 && textField.text.length <= 0) {
        [MCToast showMessage:textField.placeholder];
        return YES;
    }
    if (textField == self.kaihuyinhangTf && textField.text.length < 16) {
        [MCToast showMessage:textField.placeholder];
        return YES;
    }
    if (textField == self.textField3 && textField.text.length < 11) {
        [MCToast showMessage:textField.placeholder];
        return YES;
    }
    if (textField == self.textField4 && textField.text.length < 2) {
        [MCToast showMessage:textField.placeholder];
        return YES;
    }
    if (textField == self.textField5 && textField.text.length < 4) {
        [MCToast showMessage:textField.placeholder];
        return YES;
    }
    if (textField == self.textField6 && textField.text.length == 0) {
        [MCToast showMessage:textField.placeholder];
        return YES;
    }
    if (textField == self.textField7 && textField.text.length == 0) {
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
    [self.sureButton setTitle:@"确认修改" forState:UIControlStateNormal];
//    for (int i=2000; i<2003; i++) {
//        UIView *vv = [self viewWithTag:i];
//        vv.userInteractionEnabled = NO;
//        vv.alpha = 0.3;
//    }
    self.scanBtn.hidden = YES;
    self.textField1.text = model.name;
    self.kaihuyinhangTf.text = model.bankCardNo;
    self.textField3.text = model.phone;
    self.textField4.text = model.cvc;
    self.textField5.text = model.validPeriod;
    
    self.textField6.text = [NSString stringWithFormat:@"%@日",(long)model.billingDate];
    
    self.textField7.text = [NSString stringWithFormat:@"%@日",(long)model.repaymentDate];

    
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
    if (textField == self.textField6) {
        [self endEditing:YES];
        [self.zdDayPicker show];
        return NO;
    }
    if (textField == self.textField7) {
        [self endEditing:YES];
        [self.hkDayPicker show];
        return NO;
    }
//    if (textField == self.kaihuyinhangTf) {
//        [self endEditing:YES];
//        [self selctSheng];
//        return NO;
//    }
    return YES;
}
-(void)selctSheng{
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
            weakSelf.selectBankId = [NSString stringWithFormat:@"%@",resultModel.key];
            weakSelf.kaihuyinhangTf.text = resultModel.name;
        };
        pickView.cancelBlock = ^{[UIView animateWithDuration:0.5 animations:^{}]; };
    }];
}
- (IBAction)paizhaoAction:(id)sender {
    [self scanTouched];
}
- (void)scanTouched {
    
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
//        }
//    }];
}
//#pragma mark - 上传银行卡图片
- (void)uploadBankImage:(UIImage *)image {
    
    __weak __typeof(self)weakSelf = self;
    [MCSessionManager.shareManager mc_UPLOAD:@"/api/v1/player/upload/ORC" parameters:@{} images:@[image] remoteFields:@[@"bankFile"] imageNames:@[@"bankFile"] imageScale:0.1 imageType:nil ok:^(NSDictionary * _Nonnull resp) {
        
        if (resp[@"fileUrl"]) {
            weakSelf.bankCardUrl = resp[@"fileUrl"];
            NSDictionary *param = @{
                                    @"link":resp[@"fileUrl"],
                                    @"orcType":@"BankCard",
                                    };
            kWeakSelf(self);
            [MCSessionManager.shareManager mc_Post_QingQiuTi:@"/api/v1/player/orc" parameters:param ok:^(NSDictionary * _Nonnull resp) {
                
                NSString * no = [NSString stringWithFormat:@"%@",resp[@"number"]];
                NSMutableString *string = [NSMutableString string];
                for (int i = 0; i < no.length; i++) {
                    [string appendString:[no substringWithRange:NSMakeRange(i, 1)]];
                    if (i % 4 == 3) {
                        [string appendString:@" "];
                    }
                }
                weakSelf.kaihuyinhangTf.text = [NSString stringWithFormat:@"%@",string];
                
            } other:^(NSDictionary * _Nonnull resp) {

            } failure:^(NSError * _Nonnull error) {
                
            }];
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
- (IBAction)alertPhone:(UIButton *)sender {
   
}

- (IBAction)alertCVN:(UIButton *)sender {
 
}


@end
