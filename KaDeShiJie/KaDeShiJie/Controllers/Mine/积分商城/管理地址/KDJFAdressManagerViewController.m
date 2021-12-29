//
//  KDJFAdressManagerViewController.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/11.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJFAdressManagerViewController.h"
#import "BRAddressPickerView.h"
@interface KDJFAdressManagerViewController ()
@property (nonatomic ,strong)NSString * cityId;
@end

@implementation KDJFAdressManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:self.whereCome ? @"新增地址" : @"编辑地址" tintColor:nil];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];

    [self.adressTf addTarget:self action:@selector(textFieldChangeAction:) forControlEvents:(UIControlEventEditingDidBegin)];
    
    
    if (!self.whereCome) {
        self.shouhuorenTf.text = self.startDic[@"receiptName"];
    }
}
-(void)textFieldChangeAction:(id)tf{
    [self.view endEditing:YES];
    BRAddressPickerView * addressPicker = [[BRAddressPickerView alloc] initWithPickerMode:BRAddressPickerModeCity];
    addressPicker.title = @"请选择省市";
    addressPicker.selectValues = @[@"上海市", @"上海市"];
   __weak __typeof(self)weakSelf = self;
    addressPicker.resultBlock = ^(BRProvinceModel * _Nullable province, BRCityModel * _Nullable city, BRAreaModel * _Nullable area) {
        weakSelf.adressTf.text = [NSString stringWithFormat:@"%@%@%@",province.name,city.name,area.name];
        [MCLATESTCONTROLLER.sessionManager mc_GET:@"/api/v1/player/province" parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
            NSArray * respArry = [NSArray arrayWithArray:resp];
            for (NSDictionary * dic1 in respArry) {
                if ([dic1[@"name"] containsString:province.name] || [province.name containsString:dic1[@"name"]]) {
                    for (NSDictionary * dic2 in dic1[@"cities"]) {
                        if ([dic2[@"name"] containsString:city.name] || [city.name containsString:dic2[@"name"]]) {
                            weakSelf.cityId = [NSString stringWithFormat:@"%@",dic2[@"id"]];
                            weakSelf.adressTf.text = [NSString stringWithFormat:@"%@%@",dic1[@"name"],dic2[@"name"]];
                        }
                    }
                }
            }
        }];
    };
    [addressPicker show];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    if (self.shouhuorenTf.text.length == 0) {
        [MCToast showMessage:@"请填写收货人姓名"];
        return;
    }
    if (self.phoneTf.text.length == 0) {
        [MCToast showMessage:@"请填写收货人手机号"];
        return;
    }
    if (!self.cityId) {
        [MCToast showMessage:@"请选择城市"];
        return;
    }
    if (self.detailAdressTf.text.length == 0) {
        [MCToast showMessage:@"请填写详细地址"];
        return;
    }
    
    NSString * adress = [NSString stringWithFormat:@"%@%@",weakSelf.adressTf.text,self.detailAdressTf.text];

    
    if (self.whereCome) {

        [self.sessionManager mc_Post_QingQiuTi:@"/api/v1/player/shop/address" parameters:@{@"receiptName":self.shouhuorenTf.text,
                                                                                           @"cityId":self.cityId,
                                                                                           @"address":adress,
                                                                        
        } ok:^(NSDictionary * _Nonnull resp) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } other:^(NSDictionary * _Nonnull resp) {
            [MCLoading hidden];
        } failure:^(NSError * _Nonnull error) {
            [MCLoading hidden];
        }];
    }else{
        [MCSessionManager.shareManager mc_put:@"/api/v1/player/shop/address" parameters:@{@"status":@"Maintain",
                                                                                          @"id":[NSString stringWithFormat:@"%@",self.startDic[@"id"]],
                                                                                          @"receiptName":self.shouhuorenTf.text,
                                                                                          @"cityId":self.cityId,
                                                                                          @"address":adress,
                                                                                        
                                                                                        } ok:^(NSDictionary * _Nonnull respDic) {
            [MCToast showMessage:@"修改成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } other:^(NSDictionary * _Nonnull respDic) {
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
    

}
@end
