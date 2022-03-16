//
//  KDConfirmViewController.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/8.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDConfirmViewController.h"
#import "KDJFPayViewController.h"
#import "KDJFAdressManagerViewController.h"
#import "KDJFAdressListViewController.h"
#import "KDPayNewViewControllerShop.h"
#import "KDPaySelectView.h"
#import "KDPayZhuanZhangView.h"
#import <AlipaySDK/AlipaySDK.h>

@interface KDConfirmViewController ()
@property (nonatomic ,strong)NSDictionary * adressDic;
@property (nonatomic ,strong)MCBankCardModel * cardModel;



@end

@implementation KDConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"确认订单" tintColor:nil];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.noAddressView.backgroundColor = KWhiteColor;
    ViewRadius(self.noAddressView, 3);
    ViewRadius(self.goodImv, 3);

    [self.goodImv sd_setImageWithURL:[NSURL URLWithString:self.goodDic[@"logo"]] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    self.goodTitle.text = self.goodDic[@"title"];
    self.goodPrice.text = self.goodPrice1.text = self.goodPrice2.text = self.goodTotalPrice.text =
    [NSString stringWithFormat:@"¥%@元",self.goodDic[@"price"]];
    
    
    //添加没有地址view的手势
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickNoAdressAction:)];
    [self.noAddressView addGestureRecognizer:tap];
    
    //添加有地址view的手势
    UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHaveAdressAction:)];
    [self.haveAddressView addGestureRecognizer:tap1];


}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    kWeakSelf(self);

    [[MCSessionManager shareManager] mc_GET:[NSString stringWithFormat:@"/api/v1/player/shop/address"] parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
        if ([resp count] != 0) {
            weakself.noAddressView.hidden = YES;
            weakself.haveAddressView.hidden = NO;
            NSArray * arr = [NSArray arrayWithArray:resp];
            weakself.cPhone.text = @"";
            weakself.cAdress.text = [NSString stringWithFormat:@"%@",arr[0][@"address"]];
            weakself.cName.text = arr[0][@"receiptName"];
            weakself.cDetailAdress.text = @"";
//            weakself.cDetailAdress.text = resp[@"completeAddress"];
            weakself.adressDic = arr[0];
        }else{
            weakself.noAddressView.hidden = NO;
            weakself.haveAddressView.hidden = YES;

        }

    }];
}
-(void)clickNoAdressAction:(id)tap{
    KDJFAdressListViewController * vc = [[KDJFAdressListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)clickHaveAdressAction:(id)tap{
    kWeakSelf(self);
    KDJFAdressListViewController * vc = [[KDJFAdressListViewController alloc]init];
    vc.block = ^(NSDictionary * dic) {
        weakself.cAdress.text = [NSString stringWithFormat:@"%@",dic[@"address"]];
        weakself.cName.text = dic[@"receiptName"];
        weakself.adressDic = dic;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)confirmAction:(id)sender {

    if (!self.adressDic) {
        [MCToast showMessage:@"请添加收获地址"];
        return;
    }
    //先弹出支付方式的弹框
    [self alertPay];
    
    
//    [self requestCards];
}
-(void)alertPay{
    KDPaySelectView *view = [[[NSBundle mainBundle] loadNibNamed:@"KDPaySelectView" owner:nil options:nil] lastObject];
    [view showSelectView];
    
    view.block = ^(NSInteger index) {
        if (index == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self requestCards];
            });
        }
        if (index == 2) {
            [self alertZhuanZhang];
        }
        
        if (index == 3) {
            [self alertAliPay];
        }
    };
}
//请求银行卡
- (void)requestCards {
    __weak __typeof(self)weakSelf = self;
    NSString * url = @"/api/v1/player/bank/credit";
    [self.sessionManager mc_GET:url parameters:nil ok:^(NSDictionary * _Nonnull resp) {
        NSArray *temArr = [MCBankCardModel mj_objectArrayWithKeyValuesArray:resp];

        NSMutableArray * modelArray = [[NSMutableArray alloc]init];
        for (MCBankCardModel * cardModel in temArr) {
            BRResultModel * model = [[BRResultModel alloc]init];
            model.key = cardModel.id;
            model.value = [NSString stringWithFormat:@"%@ (%@)",cardModel.bankName,[cardModel.bankCardNo substringFromIndex:cardModel.bankCardNo.length - 4]];
            [modelArray addObject:model];
        }
        BRStringPickerView *pickView = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
        pickView.title = @"请选择信用卡";
        pickView.dataSourceArr = modelArray;
        [pickView show];
        pickView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
            
            
            for (MCBankCardModel * cardModel in temArr) {
                if ([cardModel.id integerValue] == [resultModel.key integerValue]) {
                    weakSelf.cardModel = cardModel;
                }
            }
            
            [weakSelf shopOrder];
            
        };
        pickView.cancelBlock = ^{[UIView animateWithDuration:0.5 animations:^{}]; };
    }];
}
-(void)alertZhuanZhang{
    __weak typeof(self) weakSelf = self;
    [[MCSessionManager shareManager] mc_Post_QingQiuTi:@"/api/v1/player/shop/order/debitCard" parameters:@{@"shopReceiptAddressId":[NSString stringWithFormat:@"%@",self.adressDic[@"id"]],@"sku":[NSString stringWithFormat:@"%@",self.goodDic[@"sku"]]} ok:^(NSDictionary * _Nonnull resp) {
        
        KDPayZhuanZhangView *view = [[[NSBundle mainBundle] loadNibNamed:@"KDPayZhuanZhangView" owner:nil options:nil] lastObject];
        view.frame = CGRectMake(0, 0, KScreenWidth, 300);
        [view showzhuanzhangView:resp];
    
    } other:^(NSDictionary * _Nonnull resp) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
  
    
 
}

-(void)alertAliPay{
    
    [[MCSessionManager shareManager] mc_Post_QingQiuTi:@"/api/v1/player/shop/order/aliPay" parameters:
     @{ @"shopReceiptAddressId":[NSString stringWithFormat:@"%@",self.adressDic[@"id"]],
        @"sku":[NSString stringWithFormat:@"%@",self.goodDic[@"sku"]] }
       ok:^(NSDictionary * _Nonnull resp) {
        
        NSString * aliPayRes = [NSString stringWithFormat:@"%@",resp[@"aliPayRes"]];
        
        if (aliPayRes != nil) {
            NSString *appScheme = @"wukashidaiAliPay";
            
            [[AlipaySDK defaultService] payOrder:aliPayRes fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
            }];
        }
            
    
    } other:^(NSDictionary * _Nonnull resp) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
//下单
-(void)shopOrder{
    __weak typeof(self) weakSelf = self;
    [[MCSessionManager shareManager] mc_Post_QingQiuTi:@"/api/v1/player/shop/order" parameters:@{@"shopReceiptAddressId":[NSString stringWithFormat:@"%@",self.adressDic[@"id"]],@"sku":[NSString stringWithFormat:@"%@",self.goodDic[@"sku"]]} ok:^(NSDictionary * _Nonnull resp) {
        
        [weakSelf shopPay:resp[@"orderId"]];
    
    } other:^(NSDictionary * _Nonnull resp) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}




-(void)shopPay:(NSString *)orderId{
    if (orderId.length == 0) {
        [MCToast showMessage:@"orderId为空"];
        return;
    }
    if (!self.cardModel) {
        [MCToast showMessage:@"creditCardId为空"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [MCLATESTCONTROLLER.sessionManager mc_Post_QingQiuTi:@"/api/v1/player/shop/pay" parameters:@{@"orderId":orderId,@"creditCardId":self.cardModel.id} ok:^(NSDictionary * _Nonnull respDic) {
        
        //发短信
        if ([respDic[@"state"] isEqualToString:@"Sms"] ) {
            KDPayNewViewControllerShop * vc = [[KDPayNewViewControllerShop alloc]init];
            vc.cardModel = self.cardModel;
            vc.orderId = orderId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if ([respDic[@"state"] isEqualToString:@"Unpaid"] ){
            [weakSelf payConfirm:orderId];
        }
        
        
        
    } other:^(NSDictionary * _Nonnull respDic) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
-(void)payConfirm:(NSString *)orderId{

    NSDictionary *params = @{@"orderId":orderId,};
    __weak typeof(self) weakSelf = self;
    [MCSessionManager.shareManager mc_Post_QingQiuTi:@"/api/v1/player/shop/pay/confirm" parameters:params ok:^(NSDictionary * _Nonnull respDic) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MCToast showMessage:@"操作成功"];
        });
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    } other:^(NSDictionary * _Nonnull respDic) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}














//NSDictionary *params =
//@{
//    @"creditCardId":self.xinyongInfo.id,
//    @"debitCardId":self.chuxuInfo.id,
//    @"amount":self.money,
//    @"channelId":channelModel.channelId,
// };
//__weak typeof(self) weakSelf = self;
//[MCSessionManager.shareManager mc_Post_QingQiuTi:@"/api/v1/player/receivePayment/pre" parameters:params ok:^(NSDictionary * _Nonnull respDic) {
//    KDPayNewViewController * vc = [[KDPayNewViewController alloc]init];
//    vc.cardModel = cardModel;
//    vc.cardchuxuModel = self.chuxuInfo;
//    vc.channelId = channelModel.channelId;
//    vc.amount = self.money;
//    //发短信
//    if ([respDic[@"channelBind"][@"bindStep"] isEqualToString:@"Sms"] ) {
//        vc.channelBindId = [NSString stringWithFormat:@"%@",respDic[@"channelBind"][@"id"]];
//    }else{
//        vc.orderId = [NSString stringWithFormat:@"%@",respDic[@"orderId"]];
//    }
//
//
//
//    [self.navigationController pushViewController:vc animated:YES];
//
//} other:^(NSDictionary * _Nonnull respDic) {
//
//} failure:^(NSError * _Nonnull error) {
//
//}];

@end
