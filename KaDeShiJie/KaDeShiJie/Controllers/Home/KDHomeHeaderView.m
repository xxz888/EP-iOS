//
//  KDHomeHeaderView.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/5.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDHomeHeaderView.h"
#import "KDMsgViewCell.h"
#import "KDProvisionsViewController.h"
#import "KDTopDelegateViewController.h"
#import "KDCreditManagerViewController.h"
#import "KDEarnCenterViewController.h"
#import "KDGatheringViewController.h"
#import <MCMessageModel.h>
#import "KDDirectRefundViewController.h"
#import "QMUIModalPresentationViewController.h"
#import <OEMSDK/MCWebViewController.h>
#import "KDWebContainer.h"
#import "KDCreditModel.h"
#import "KDKongKaViewController.h"
#import "KDHomeXinYongKaViewController.h"
#import "KDRenZhengView.h"
#import "KDHomeBillManageViewController.h"
#import "jintMyWallViewController.h"
#import "KDTrandingRecordViewController.h"
#import "MCManualRealNameController.h"
#import "jintMyWallViewController.h"
#import "UIView+Extension.h"
#import "KDWenZinTiShi.h"
#import "KDXinYongKaViewController.h"
#import "KDPayNewViewControllerQuickPass.h"
#import "KDWukaJifenViewController.h"

@interface KDHomeHeaderView ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIStackView *topView;
@property (weak, nonatomic) IBOutlet UIStackView *centerView;
@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UIView *msgContentView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHigCons;
@property (weak, nonatomic) IBOutlet MCBannerView *bannerView;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) KDHomeHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UIStackView *cententBottomView;
@property (weak, nonatomic) IBOutlet UIStackView *cententBottomView1;
@property (weak, nonatomic) IBOutlet UILabel *serverView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SDCycleScrollView *cyView;
@end

@implementation KDHomeHeaderView

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    for (QMUIButton *btn in self.topView.subviews) {
        btn.imagePosition = QMUIButtonImagePositionTop;
//        btn.spacingBetweenImageAndTitle = 15;
    }
    
    NSArray *titleArray = @[@"智能管理", @"快捷收款", @"空卡还款", @"极速办卡"];
    for (int i = 0; i < 4; i++) {
        QMUIButton *btn = [self.centerView viewWithTag: 200 + i];
        btn.imagePosition = QMUIButtonImagePositionTop;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"kd_home_bottom_%d", i]] forState:UIControlStateNormal];
    }
    
    NSArray *titleArray1 = @[@"小额闪付", @"刷脸付", @"手机POS", @"支付宝收款"];
    for (int i = 0; i < 4; i++) {
        QMUIButton *btn = [self.cententBottomView viewWithTag: 300 + i];
        btn.imagePosition = QMUIButtonImagePositionTop;
        [btn setTitle:titleArray1[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"kd_home_bottom1_%d", i]] forState:UIControlStateNormal];
    }
    
    NSArray *titleArray2 = @[@"我的团队", @"無卡积分"];
    for (int i = 0; i < 2; i++) {
        QMUIButton *btn = [self.cententBottomView1 viewWithTag: 400 + i];
        btn.imagePosition = QMUIButtonImagePositionTop;
        [btn setTitle:titleArray2[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"kd_home_bottom2_%d", i]] forState:UIControlStateNormal];
    }
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.serverView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft  cornerRadii:CGSizeMake(5,5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.serverView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.serverView.layer.mask = maskLayer;
    
    
    
    self.contentView.layer.cornerRadius = 7;
//    self.msgContentView.layer.cornerRadius = 10;
    self.lineView.layer.cornerRadius = 2.3;
    __weak typeof(self) weakSelf = self;
    self.bannerView.resetHeightBlock = ^(CGFloat h) {
        weakSelf.bannerHigCons.constant = h;
        if (self.callBack) {
            self.callBack(661 - 128 + h);
        }
    };
    
    SDCycleScrollView *cyView = [[SDCycleScrollView alloc] initWithFrame:self.msgView.bounds];
    cyView.delegate = self;
    cyView.backgroundColor = [UIColor clearColor];
    cyView.showPageControl = NO;
    cyView.clipsToBounds = YES;
    [cyView disableScrollGesture];
    cyView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
//    cyView.imageURLStringsGroup = self.dataArray;
    cyView.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.msgView addSubview:cyView];
    self.cyView = cyView;
    [self getMessage];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDHomeHeaderView" owner:nil options:nil] firstObject];
    }
    return self;
}
- (IBAction)btnAction:(QMUIButton *)sender {
    __weak typeof(self) weakSelf = self;
    if (sender.tag == 100 || sender.tag == 101 || sender.tag == 102) {
            switch (sender.tag) {
                //空卡
                case 100:{ [MCToast showMessage:@"暂未开放"];}
                    break;
                //信用卡还款
                case 101:{
                        if ([SharedUserInfo.certification integerValue] == 1) {
                            KDDirectRefundViewController * vc = [[KDDirectRefundViewController alloc]init];
                            vc.navTitle = @"信用卡还款";
                            //订单类型（2为还款记录、3为空卡记录）
                            vc.orderType = @"2";
                            [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
                        }else{
                            [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
                                if ([SharedUserInfo.certification integerValue] == 1) {
                                    KDDirectRefundViewController * vc = [[KDDirectRefundViewController alloc]init];
                                    vc.navTitle = @"信用卡还款";
                                    //订单类型（2为还款记录、3为空卡记录）
                                    vc.orderType = @"2";
                                    [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];}
                                else{
                                    [weakSelf showRenzhengView];
                                }
                            }];
                        }
                }
                    break;
                //刷卡
                case 102:{
                        if ([SharedUserInfo.certification integerValue] == 1) {
                            [self pushShuaka];
                        }else{
                            [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
                                if ([SharedUserInfo.certification integerValue] == 1) {
                                    [weakSelf pushShuaka];
                                }else{
                                    [weakSelf showRenzhengView];
                                }
                            }];
                        }
                    }
                    break;
                default:
                    break;
        }
    }else{
        switch (sender.tag) {
            // 账单管理
            case 200:[MCLATESTCONTROLLER.navigationController pushViewController:[KDTrandingRecordViewController new] animated:YES];
                break;
            // 信用管理
            case 201:[MCLATESTCONTROLLER.navigationController pushViewController:[KDXinYongKaViewController new] animated:YES];
                break;
            // 实名认证
            case 202:
            
                if ([SharedUserInfo.certification integerValue] == 1) {
                    [MCToast showMessage:@"您已实名认证"];
                }else{
                    [MCLATESTCONTROLLER.navigationController pushViewController:[MCManualRealNameController new] animated:YES];
                }
                break;
            //我的钱包
            case 203:{
                
                [MCLATESTCONTROLLER.navigationController pushViewController:[KDWukaJifenViewController new] animated:YES];

                //[MCLATESTCONTROLLER.navigationController pushViewController:[jintMyWallViewController new] animated:YES];
            }
                break;
            //小额闪付
            case 300:{
                if ([SharedUserInfo.certification integerValue] == 1) {
                    [self pushShanfu];
                }else{
                    [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
                        if ([SharedUserInfo.certification integerValue] == 1) {
                            [weakSelf pushShanfu];
                        }else{
                            [weakSelf showRenzhengView];
                        }
                    }];
                }
            }
                break;
            //刷脸付
            case 301:{
                if ([SharedUserInfo.certification integerValue] == 1) {
                    [self pushShualianfu];
                }else{
                    [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
                        if ([SharedUserInfo.certification integerValue] == 1) {
                            [weakSelf pushShualianfu];
                        }else{
                            [weakSelf showRenzhengView];
                        }
                    }];
                }
            }
                break;
            case 302:
            { [MCToast showMessage:@"暂未开放"];}
                break;
            case 303:
            { [MCToast showMessage:@"暂未开放"];}
                break;
            default:
                break;
        }
    }

   
}
-(void)pushShuaka{
    KDGatheringViewController * vc = [[KDGatheringViewController alloc]init];
    vc.whereCome = 1;
    [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
}
-(void)pushShanfu{
    KDGatheringViewController * vc = [[KDGatheringViewController alloc]init];
    vc.whereCome = 2;
    [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
}
-(void)pushShualianfu{
    KDGatheringViewController * vc = [[KDGatheringViewController alloc]init];
    vc.whereCome = 3;
    [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
}
- (void)pushCardVCWithType:(MCBankCardType)cardType
{
    [MCPagingStore pagingURL:rt_card_edit withUerinfo:@{@"type":@(MCBankCardTypeXinyongka), @"isLogin":@(YES)}];

}

-(void)showRenzhengView{
    QMUIModalPresentationViewController * alert = [[QMUIModalPresentationViewController alloc]init];
    KDRenZhengView * renzhengView = [KDRenZhengView renZhengView];
    renzhengView.frame = CGRectMake(0, 0, 316, 282);
    alert.contentView = renzhengView;
    alert.dimmingView.userInteractionEnabled = NO;
    [alert showWithAnimated:YES completion:nil];
    
    
    renzhengView.quedingBtnActionBlock = ^{
        [MCLATESTCONTROLLER.navigationController pushViewController:[MCManualRealNameController new] animated:YES];
        [alert hideWithAnimated:YES completion:nil];

    };
    
    renzhengView.closeActionBlock = ^{
        [alert hideWithAnimated:YES completion:nil];
    };
    
    renzhengView.closeActionBlock1 = ^{
        [alert hideWithAnimated:YES completion:nil];
    };
    
    
}
#pragma mark - SDCycleScrollViewDelegate
- (UINib *)customCollectionViewCellNibForCycleScrollView:(SDCycleScrollView *)view
{
    UINib *nib = [UINib nibWithNibName:@"KDMsgViewCell" bundle:[NSBundle mainBundle]];
    return nib;
}
- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view
{
    MCMessageModel *model = self.dataArray[index];
    KDMsgViewCell *myCell = (KDMsgViewCell *)cell;
    myCell.topLabel.text = [NSString stringWithFormat:@"%@ %@", model.title?model.title:@"", model.createdTime?model.createdTime:@""];
    
    
    if (model.content) {
        myCell.centerLabel.text = model.content;
    }
    
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    [MCPagingStore pagingURL:rt_notice_list];
}
- (void)getMessage {
    kWeakSelf(self)
    [MCLATESTCONTROLLER.sessionManager mc_GET:@"/api/v1/player/notice" parameters:nil ok:^(NSDictionary * _Nonnull resp) {
        weakself.dataArray = [MCMessageModel mj_objectArrayWithKeyValuesArray:resp];
        if ([weakself.dataArray count] > 0) {
            weakself.cyView.localizationImageNamesGroup = weakself.dataArray;
        }
    }];
}
    

- (void)pushTopDelegateVC
{
    [MCLATESTCONTROLLER.sessionManager mc_POST:@"/transactionclear/app/standard/extension/user/query" parameters:@{@"userId":SharedUserInfo.userid} ok:^(NSDictionary * _Nonnull resp) {
        NSDictionary *dict = resp[@"result"];
        if (dict.allKeys != 0) {
            NSInteger grade = [dict[@"promotionLevelId"] intValue];
            if (grade < 3) {
                [MCToast showMessage:@"您当前不是顶级代理，无法进入"];
            } else {
                [MCLATESTCONTROLLER.navigationController pushViewController:[KDTopDelegateViewController new] animated:YES];
            }
        } else {
            [MCToast showMessage:@"您当前不是顶级代理，无法进入"];
        }
    }];
}
@end
