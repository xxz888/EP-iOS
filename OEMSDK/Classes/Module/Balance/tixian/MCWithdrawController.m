//
//  MCWithdrawController.m
//  MCOEM
//
//  Created by wza on 2020/5/8.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCWithdrawController.h"
#import "MCPayPWDInputView.h"
#import "MCBankStore.h"
#import "KDFillButton.h"
#import "KDCommonAlert.h"


@interface MCWithdrawController ()<MCPayPWDInputViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bankLogoImgView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;
@property (weak, nonatomic) IBOutlet UILabel *bankNoLab;
@property (weak, nonatomic) IBOutlet UILabel *shouxuLab;

@property (weak, nonatomic) IBOutlet KDFillButton *sureButton;
@property (weak, nonatomic) IBOutlet UIButton *totalButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *avalibleLab;

@property(nonatomic, copy) NSString *availableBalance;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

//提现类型,默认为空，ali、card
@property(nonatomic, copy) NSString *withDrawType;

/// 最小提现金额
@property(nonatomic, copy) NSString *minWithDraw;

@property(nonatomic, strong) QMUIModalPresentationViewController *withdrawTypeModal;
@property (weak, nonatomic) IBOutlet UILabel *tipsLab;

@property(nonatomic, strong) QMUIModalPresentationViewController *modalVC;
@property(nonatomic, strong) MCPayPWDInputView *pwdInput;
 

@end

@implementation MCWithdrawController

- (MCPayPWDInputView *)pwdInput {
    if (!_pwdInput) {
        _pwdInput = [MCPayPWDInputView newFromNib];
        _pwdInput.delegate = self;
        _pwdInput.modal = self.modalVC;
    }
    return _pwdInput;
}

- (QMUIModalPresentationViewController *)modalVC {
    if (!_modalVC) {
        _modalVC = [[QMUIModalPresentationViewController alloc] init];
        _modalVC.contentView = self.pwdInput;
        __weak __typeof(self)weakSelf = self;
        _modalVC.layoutBlock = ^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
            weakSelf.pwdInput.frame = CGRectMake(10, NavigationContentTop+20, SCREEN_WIDTH-20, 170);
        };
    }
    return _modalVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    [self setNavigationBarTitle:@"提现" tintColor:nil];
    [self.totalButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];

    self.sureButton.layer.cornerRadius = self.sureButton.height/2;
    
    __weak __typeof(self)weakSelf = self;
    self.scroll.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
    
    [self requestData];
    
    self.bankNameLab.text = @"添加到账账户";
    self.bankLogoImgView.image = [[UIImage mc_imageNamed:@"tixian_add"] qmui_imageWithSpacingExtensionInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    self.tipsLab.textColor = MAINCOLOR;
    
    [self.sureButton setBackgroundImage:[UIImage qmui_imageWithColor:[UIColor qmui_colorWithHexString:@"#D9D9D9"]] forState:UIControlStateDisabled];
//    [self.sureButton setBackgroundImage:nil forState:UIControlStateNormal];
    self.sureButton.enabled = NO;
    self.sureButton.adjustsButtonWhenDisabled = NO;
    
    [self.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
    
}
- (void)lishi {
}
- (void)textChanged:(UITextField *)textField {
    self.sureButton.enabled = textField.text.length > 0;
}

- (void)requestData {
    
    [self requstAccount];
    [self requestWithdrawLimit];
}



/// 请求绑定的支付宝
//- (void)requestAliPhone {
//    NSString *userId = SharedUserInfo.userid;
//    NSDictionary *defaultCardDic = @{@"userId":userId, @"type":@"3", @"nature":@"0", @"isDefault":@"1"};
//    __weak __typeof(self)weakSelf = self;
//    [MCSessionManager.shareManager mc_POST:@"/user/app/bank/query/byuseridandtype/andnature" parameters:defaultCardDic ok:^(NSDictionary * _Nonnull resp) {
//        NSArray *result = resp[@"result"];
//        NSDictionary *dict = result.firstObject;
//        NSString *cardNo = [NSString stringWithFormat:@"%@", dict[@"cardNo"]];
//        if (!cardNo || cardNo.length != 11) {
//            return;
//        }
//        NSString *first = [cardNo substringWithRange:NSMakeRange(0, 3)];
//        NSString *last = [cardNo substringFromIndex:cardNo.length-4];
//
//        weakSelf.bankLogoImgView.image = [UIImage mc_imageNamed:@"ali_logo"];
//        weakSelf.bankNameLab.text = @"支付宝";
//        weakSelf.bankNoLab.text = [NSString stringWithFormat:@"%@ **** %@",first,last];
//
//    } other:^(NSDictionary * _Nonnull resp) {
//        QMUIAlertController *alert = [[QMUIAlertController alloc] initWithTitle:nil message:resp[@"messege"] preferredStyle:QMUIAlertControllerStyleAlert];
//        [alert addAction:[QMUIAlertAction actionWithTitle:@"下次再说" style:QMUIAlertActionStyleCancel handler:nil]];
//        [alert addAction: [QMUIAlertAction actionWithTitle:@"立即添加" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
//            [aAlertController hideWithAnimated:YES];
//            [weakSelf.navigationController pushViewController:[MCBindALIViewController new] animated:YES];
//        }]];
//        [alert showWithAnimated:YES];
//
//    }];
//}

/// 请求余额账户信息
- (void)requstAccount {
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_GET:[NSString stringWithFormat:@"/user/app/account/query/%@",TOKEN] parameters:nil ok:^(NSDictionary * _Nonnull resp) {
        [weakSelf.scroll.mj_header endRefreshing];
        weakSelf.availableBalance = [NSString stringWithFormat:@"%.3f", [resp[@"result"][@"balance"] floatValue]];
        self.textField.text = weakSelf.availableBalance;
        
 
        if ([weakSelf.availableBalance floatValue] == 0) {
            [self.sureButton setBackgroundImage:[UIImage qmui_imageWithColor:[UIColor qmui_colorWithHexString:@"#D9D9D9"]] forState:UIControlStateDisabled];

            self.sureButton.enabled = NO;
            self.sureButton.adjustsButtonWhenDisabled = NO;
        }else{
            self.sureButton.enabled = YES;
 
        }
        
        
//        QMUIModalPresentationViewController * alert = [[QMUIModalPresentationViewController alloc]init];
//        MCTiXianAlertView * commonAlert = [MCTiXianAlertView newFromNib];
//        commonAlert.presentView = alert;
//
//
//        alert.layoutBlock = ^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
//            commonAlert.frame = CGRectMake(SCREEN_WIDTH*84/375, kTopHeight+277-45, SCREEN_WIDTH*207/375, SCREEN_WIDTH*207/375);
//        };
//        commonAlert.priceLbl.text = [self.textField.text append:@"元"];
//        alert.contentView = commonAlert;
//
//
//
//        [alert showWithAnimated:YES completion:nil];
        
        
        
    
    } other:^(NSDictionary * _Nonnull resp) {
        [weakSelf.scroll.mj_header endRefreshing];
        [MCToast showMessage:resp[@"messege"]];
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.scroll.mj_header endRefreshing];
        [MCToast showMessage:[NSString stringWithFormat:@"%ld\n%@",error.code,error.domain]];
    }];
}

- (void)setAvailableBalance:(NSString *)availableBalance {
    _availableBalance = availableBalance;
  

    if ([availableBalance floatValue] <= 500) {
        
        NSAttributedString *a1 = [[NSAttributedString alloc] initWithString:@"总金额：" attributes:@{NSFontAttributeName:UIFontMake(14),NSForegroundColorAttributeName:UIColorGrayDarken}];
        NSAttributedString *a2 = [[NSAttributedString alloc] initWithString:availableBalance attributes:@{NSFontAttributeName:UIFontBoldMake(14),NSForegroundColorAttributeName:UIColorGrayDarken}];
        NSAttributedString *a3 = [[NSAttributedString alloc] initWithString:@"元，实时到账。" attributes:@{NSFontAttributeName:UIFontMake(14),NSForegroundColorAttributeName:UIColorGrayDarken}];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] init];
        [att appendAttributedString:a1];
        [att appendAttributedString:a2];
        [att appendAttributedString:a3];
        self.avalibleLab.attributedText = att;
    }else{
        NSAttributedString *a1 = [[NSAttributedString alloc] initWithString:@"总金额：" attributes:@{NSFontAttributeName:UIFontMake(14),NSForegroundColorAttributeName:UIColorGrayDarken}];
        NSAttributedString *a2 = [[NSAttributedString alloc] initWithString:availableBalance attributes:@{NSFontAttributeName:UIFontBoldMake(14),NSForegroundColorAttributeName:UIColorGrayDarken}];
        NSAttributedString *a3 = [[NSAttributedString alloc] initWithString:@"元，下一个工作日12:00前到账。" attributes:@{NSFontAttributeName:UIFontMake(14),NSForegroundColorAttributeName:UIColorGrayDarken}];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] init];
        [att appendAttributedString:a1];
        [att appendAttributedString:a2];
        [att appendAttributedString:a3];
        self.avalibleLab.attributedText = att;

    }
}


- (IBAction)onBankTouched:(id)sender {
    MCCardManagerController *vc = [[MCCardManagerController alloc] init];
    vc.titleString = @"选择储蓄卡";
    [self.navigationController pushViewController:vc animated:YES];
    __weak typeof(self) weakSelf = self;
    vc.selectCardBlock = ^(MCBankCardModel * _Nonnull cardModel, NSInteger type) {
        self.withDrawType = @"card";
        MCBankCardInfo *ii = [MCBankStore getBankCellInfoWithName:cardModel.bankName];
        weakSelf.bankLogoImgView.image = ii.logo;
        weakSelf.bankNameLab.text = cardModel.bankName;
        weakSelf.bankNoLab.text = [NSString stringWithFormat:@"储蓄卡 尾号%@",(cardModel.cardNo?[cardModel.cardNo substringFromIndex:cardModel.cardNo.length-4]:@"")];
    };
}
- (IBAction)onSureTouched:(id)sender {
    [self.view endEditing:YES];
    if (!self.withDrawType || self.withDrawType.length < 1) {
        [MCToast showMessage:@"请添加到账账户"];
        return;
    }
    CGFloat input = self.textField.text.floatValue;
    CGFloat total= self.availableBalance.floatValue;
    if (input < self.minWithDraw.floatValue) {
        [MCToast showMessage:[NSString stringWithFormat:@"最低提现金额不得低于%@元",self.minWithDraw]];
        return;
    }
    if (input > total) {
        [MCToast showMessage:@"输入金额不得大于可提现金额"];
        return;
    }
    [self.modalVC showWithAnimated:YES completion:nil];
}
- (IBAction)onTotalTouched:(id)sender {
    self.textField.text = self.availableBalance;
}

/// 提现到银行卡
- (void)withdraw {
    NSDictionary *param = @{@"phone":SharedUserInfo.phone,
                            @"amount":self.textField.text,
                            @"order_desc":@"余额提现",
                            @"channe_tag":@"YILIAN"};
    kWeakSelf(self);
    [MCSessionManager.shareManager mc_POST:@"/facade/app/withdraw/" parameters:param ok:^(NSDictionary * _Nonnull resp) {
    
        
//        QMUIAlertController * alert = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"提现成功" preferredStyle:QMUIAlertControllerStyleAlert];
//        [alert addAction:[QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }]];
//        [alert showWithAnimated:YES];
    }];
}

/// 提现到支付宝
//- (void)withDrawToAli {
//    NSString *phone = SharedUserInfo.phone;
//    NSDictionary *withdrawDic = @{@"amount":self.textField.text, @"order_desc":@"支付宝提现"};
//    [MCSessionManager.shareManager mc_POST:@"/facade/app/ali/withdraw" parameters:withdrawDic ok:^(NSDictionary * _Nonnull resp) {
//        QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:@"提示" message:@"提现成功" preferredStyle:QMUIAlertControllerStyleAlert];
//        [alert addAction:[QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }]];
//        [alert showWithAnimated:YES];
//    }];
//}

/// 提现限额
- (void)requestWithdrawLimit {
    __weak __typeof(self)weakSelf = self;
    [self.sessionManager mc_POST:@"facade/app/withdraw/brand/limit/query" parameters:@{@"brandId":SharedConfig.brand_id} ok:^(NSDictionary * _Nonnull resp) {
        
        weakSelf.minWithDraw = [NSString stringWithFormat:@"%@",resp[@"result"][@"singleMinLimit"]];
        
        weakSelf.textField.enabled=NO;
        weakSelf.textField.placeholder = [NSString stringWithFormat:@"提现金额，最低%@元", weakSelf.minWithDraw];
    }];
}

#pragma mark - MCPayPWDInputViewDelegate
- (void)payPWDInputViewDidCommited:(NSString *)pwd {
    //MCLog(@"%@",pwd);
    __weak __typeof(self)weakSelf = self;
    [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/user/app/paypass/auth/%@",TOKEN] parameters:@{@"paypass":pwd} ok:^(NSDictionary * _Nonnull resp) {
//        if ([weakSelf.withDrawType isEqualToString:@"ali"]) {
//            [weakSelf withDrawToAli];
//        } else if ([weakSelf.withDrawType isEqualToString:@"card"]) {
            [weakSelf withdraw];
//        }
    }];
}

@end
