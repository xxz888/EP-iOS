//
//  KDMineHeaderView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/8.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDMineHeaderView.h"
#import <OEMSDK/OEMSDK.h>
#import "KDMyReferrerViewController.h"
#import "KDAboutMineViewController.h"
#import "KDWXViewController.h"
#import "KDTrandingRecordViewController.h"
#import "KDJFShopManagerViewController.h"
#import "KDMineKehuViewController.h"

#import "KDWebContainer.h"
#import "KDJFShopViewController.h"
#import "UIView+Extension.h"
#import "jintMyWallViewController.h"
@interface KDMineHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UIView *topContentView;
@property (weak, nonatomic) IBOutlet UIView *bottomContentView;
@property (weak, nonatomic) IBOutlet MCBannerView *bannerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHigCons;

// 推荐人
@property (weak, nonatomic) IBOutlet UIView *prePersonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContentViewHigCons;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@end

@implementation KDMineHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dianhua.text =   [NSString stringWithFormat:@"联系客服：%@",SharedDefaults.servicePhone];

    self.gradeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.gradeLabel.layer.borderWidth = 1;
    self.gradeLabel.layer.cornerRadius = self.gradeLabel.ly_height * 0.5;
    self.gradeLabel.layer.masksToBounds = YES;
    
    self.topContentView.layer.cornerRadius = 12;
    self.bottomContentView.layer.cornerRadius = 12;
    
    if (MCModelStore.shared.preUserPhone.length != 11) {
        [self.prePersonView removeFromSuperview];
        self.topContentViewHigCons.constant = 180;
        self.lineView.hidden = YES;
    }
    
    self.bannerView.layer.cornerRadius = 10;
    self.bannerView.layer.masksToBounds = YES;
    self.bannerView.resetHeightBlock = ^(CGFloat h) {
        self.bannerHigCons.constant = h;
    };
    
 
    //推广二维码
    [self.erweimaView rf_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
        [MCPagingStore pagingURL:rt_share_single];
    }];
    //我的卡包
    [self.kabaoView rf_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
        [MCPagingStore pagingURL:rt_card_list];
    }];
    //我的钱包
    [self.qianbaoView rf_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
        [MCLATESTCONTROLLER.navigationController pushViewController:[jintMyWallViewController new] animated:YES];

    }];
    //我的客服
    [self.kefuView rf_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
        [MCLATESTCONTROLLER.navigationController pushViewController:[[MCHomeServiceViewController alloc] init] animated:YES];

    }];
    //关于我们
    [self.guanyuwomenView rf_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
        [MCLATESTCONTROLLER.navigationController pushViewController:[KDAboutMineViewController new] animated:YES];

    }];
    //联系我们
    [self.lianxiView rf_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
        [MCLATESTCONTROLLER.navigationController pushViewController:[[MCHomeServiceViewController alloc] init] animated:YES];

    }];
    //我的客户
    [self.wodekefuView rf_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
        [MCLATESTCONTROLLER.navigationController pushViewController:[[KDMineKehuViewController alloc] init] animated:YES];
        
    }];
    //设置
    [self.shezhiView rf_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
        [MCLATESTCONTROLLER.navigationController pushViewController:[MCSettingViewController new] animated:YES];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDMineHeaderView" owner:nil options:nil] firstObject];
    }
    return self;
}

- (IBAction)mineBtnAction:(UIButton *)sender {
    switch (sender.tag) {
//        case 110:
//            [MCLATESTCONTROLLER.navigationController pushViewController:[KDJFShopViewController new] animated:YES];
//
//            break;
        case 100:

            [MCPagingStore pagingURL:rt_share_single];
            break;
        case 101:
            
            [MCPagingStore pagingURL:rt_card_list];

            
         
            break;
        case 102: // 交易记录
            //原生界面
            [MCLATESTCONTROLLER.navigationController pushViewController:[KDTrandingRecordViewController new] animated:YES];
            //本地vue
//            [MCLATESTCONTROLLER.navigationController pushViewController:KDWebContainer.shared.jiaoyijiluVC animated:YES];
            break;
        case 103:
            [MCLATESTCONTROLLER.navigationController pushViewController:[KDMyReferrerViewController new] animated:YES];
            break;
        case 104:
            NSLog(@"我的奖券");
            break;
        case 105:
            [MCLATESTCONTROLLER.navigationController pushViewController:[[MCHomeServiceViewController alloc] init] animated:YES];
//            [MCPagingStore pagingURL:rt_setting_service];
            break;
        case 106:
        {
            [MCLATESTCONTROLLER.navigationController pushViewController:[KDAboutMineViewController new] animated:YES];
        }
            break;
        case 107:
            [MCPagingStore pagingURL:rt_setting_list];
            break;
        case 108:
            NSLog(@"底部图片");
        break;
            
        default:
            break;
    }
}
// 个人资料
- (IBAction)clickPersonCenter:(UIButton *)sender {
    [MCPagingStore pagingURL:rt_user_info];
}
- (void)getUserGradeName
{
  
}
@end
