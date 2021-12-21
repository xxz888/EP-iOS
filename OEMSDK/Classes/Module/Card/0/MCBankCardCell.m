//
//  MCBankCardCell.m
//  MCOEM
//
//  Created by wza on 2020/4/24.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCBankCardCell.h"
#import "MCBankStore.h"
#import "KDCommonAlert.h"

@implementation MCBankCardCell

+ (instancetype)cellForTableView:(UITableView *)tableView {
    static NSString *cellID = @"MCBankCardCell";
    MCBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:cellID bundle:[NSBundle OEMSDKBundle]] forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.cenView.layer.masksToBounds = YES;
    self.cenView.layer.cornerRadius = 8.f;
    self.defBtn.layer.masksToBounds = YES;
    self.defBtn.layer.cornerRadius = 8.f;
    self.logo.backgroundColor = UIColorWhite;
    self.logo.layer.cornerRadius = self.logo.qmui_width/2;
    self.modifyBtn.layer.cornerRadius = self.modifyBtn.qmui_height/2;
    
    self.defBtn.contentEdgeInsets = UIEdgeInsetsMake(3, 6, 3, 6);
}

- (void)setModel:(MCBankCardModel *)model {
    _model = model;
    self.bankName.text = model.bankName;
    NSString *firstName = [model.name substringWithRange:NSMakeRange(0, 1)];
    if (model.name.length == 2) {
        self.username.text = [NSString stringWithFormat:@"（%@*）", firstName];
    } else {
        NSString *last = [model.name substringFromIndex:model.name.length-1];
        self.username.text = [NSString stringWithFormat:@"（%@*%@）", firstName, last];
    }
    
    
    if([model.cardType containsString:@"CreditCard"]){
//        self.defBtn.hidden = NO;
        self.cardType.text = @"提现卡";
        
    } else if([model.cardType containsString:@"DebitCard"]) {
//        self.defBtn.hidden = YES;
        self.cardType.text = @"充值卡";
                
    } else {
        [MCToast showMessage:@"发现未识别的卡"];
    }
    
    NSString *subCardString = model.bankCardNo;
    
//    [model.bankCardNo substringWithRange:NSMakeRange(4, model.bankCardNo.length - 3 - 4)];
    self.cardNo.text = subCardString;//[model.bankCardNo stringByReplacingOccurrencesOfString:subCardString withString:@" **** **** **** "];
    
//    self.cardDetail.text = model.cardType;
    
    MCBankCardInfo *info = [MCBankStore getBankCellInfoWithName:model.bankName];
    self.logo.image = info.logo;
    self.bgImage.backgroundColor = [info.cardCellBackgroundColor qmui_colorWithAlphaAddedToWhite:0.6];
//    if(model.idDef){
//        [self.defBtn setTitle:@"默认卡" forState:UIControlStateNormal];
//        self.defBtn.userInteractionEnabled = NO;
//        self.defBtn.layer.borderWidth = 0;
//    } else {
//        [self.defBtn setTitle:@"设为默认卡" forState:UIControlStateNormal];
//        self.defBtn.userInteractionEnabled = YES;
//        self.defBtn.layer.borderWidth = 1;
//        self.defBtn.layer.borderColor = UIColorWhite.CGColor;
//        self.defBtn.layer.cornerRadius = self.defBtn.height/2;
//    }
}
- (IBAction)defBtnTouched:(id)sender {  //设为默认
    [MCSessionManager.shareManager mc_POST:[NSString stringWithFormat:@"/user/app/bank/default/%@",TOKEN] parameters:@{@"cardno":self.model.cardNo} ok:^(NSDictionary * _Nonnull resp) {
        [MCToast showMessage:@"设置成功"];
        self.block(MCBankCardCellActionDefault, self.model);
    }];
}
- (IBAction)delBtnTouched:(id)sender {  //删除卡片

    
    QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要解绑此银行卡吗？" preferredStyle:QMUIAlertControllerStyleAlert];
    [alert addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
    [alert addAction:[QMUIAlertAction actionWithTitle:@"解绑" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         
            [MCSessionManager.shareManager mc_put:@"/api/v1/player/bank" parameters:@{@"status":@"Delete",@"id":[NSString stringWithFormat:@"%@",self.model.id]} ok:^(NSDictionary * _Nonnull respDic) {
                [MCToast showMessage:@"解绑成功"];
                
                self.block(MCBankCardCellActionDelete, self.model);

            } other:^(NSDictionary * _Nonnull respDic) {
                
            } failure:^(NSError * _Nonnull error) {
                
            }];
        });

    }]];
    [alert showWithAnimated:YES];
    
}
- (IBAction)modifyTouched:(id)sender {  //修改
    self.block(MCBankCardCellActionModify, self.model);
}

@end
