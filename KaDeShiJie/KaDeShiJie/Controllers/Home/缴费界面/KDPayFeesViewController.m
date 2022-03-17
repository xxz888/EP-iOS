//
//  KDPayFeesViewController.m
//  KaDeShiJie
//
//  Created by BH on 2022/3/17.
//  Copyright © 2022 SS001. All rights reserved.
//

#import "KDPayFeesViewController.h"
#import "KDXinYongKaViewController.h"
#import "BRStringPickerView.h"

@interface KDPayFeesViewController ()

@end

@implementation KDPayFeesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"新增缴费" tintColor:[UIColor mainColor]];
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"缴费订单" forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.titleLabel.font = LYFont(13);
    shareBtn.frame = CGRectMake(SCREEN_WIDTH - 70, StatusBarHeightConstant + 12, 70, 22);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    
    switch (self.tag) {
        //水费
        case 200:{
            self.xiangmuLbl.text = @"杭州自来水水费";
            self.danweiLbl.text = @"杭州自来水有限责任公司";
        }
            break;
        //电费
        case 201:{
            self.xiangmuLbl.text = @"杭州智能电表";
            self.danweiLbl.text = @"杭州电力公司";
        }
            break;
        //燃气费
        case 202:{
            self.xiangmuLbl.text = @"杭州燃气费";
            self.danweiLbl.text = @"杭州燃气集团有限责任公司";
        }
            break;
        //有线电视
        case 203:{
            self.xiangmuLbl.text = @"杭州歌化费用清缴及充值";
            self.danweiLbl.text = @"杭州歌化有线电视有限公司";
        }
            break;
        //交通罚款
        case 300:{
            [MCToast showMessage:@"请至12123APP缴费"];
            return;
        }
            break;
        //ETC缴费
        case 301:{
            [MCToast showMessage:@"请至12123APP缴费"];
            return;
        }
            break;
        //游戏点卡
        case 302:{
            self.xiangmuLbl.text = @"梦幻西游";
            self.danweiLbl.text = @"杭州里森技术科技公司";
        }
            break;
        //极速办卡
        case 303:{
            [MCLATESTCONTROLLER.navigationController pushViewController:[KDXinYongKaViewController new] animated:YES];
        }
            break;
        //卡包
        case 400:{
            [MCPagingStore pagingURL:rt_card_list];
        }
            break;
        //账单管理
        case 401:{
            
        }
            break;
            
        default:
            break;
    }

}
- (IBAction)fenzuAction:(id)sender {
    
    BRStringPickerView *pickView = [[BRStringPickerView alloc] initWithPickerMode:BRStringPickerComponentSingle];
    pickView.dataSourceArr = @[@"我家", @"父母", @"朋友", @"房东", @"党团工会", @"暂不分组"];
    pickView.selectValue = @"我家";
    [pickView show];
    pickView.resultModelBlock = ^(BRResultModel * _Nullable resultModel) {
        [self.fenzuBtn setTitle:resultModel.value forState:0];
    };
    pickView.cancelBlock = ^{
      
    };
    
}
- (IBAction)nextAction:(id)sender {
    [MCToast showMessage:@"请输入正确的客户编号"];

}
-(void)clickRightBtnAction{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
