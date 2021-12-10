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
    }
    
    NSArray *titleArray = @[@"账单管理", @"申请办卡", @"实名认证", @"信誉检测"];
    for (int i = 0; i < 4; i++) {
        QMUIButton *btn = [self.centerView viewWithTag: 200 + i];
        btn.imagePosition = QMUIButtonImagePositionTop;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"kd_home_bottom_%d", i]] forState:UIControlStateNormal];
    }
    
    NSArray *titleArray1 = @[@"小额闪付", @"刷脸付", @"花呗", @"手机POS"];
    for (int i = 0; i < 4; i++) {
        QMUIButton *btn = [self.cententBottomView viewWithTag: 300 + i];
        btn.imagePosition = QMUIButtonImagePositionTop;
        [btn setTitle:titleArray1[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"kd_home_bottom1_%d", i]] forState:UIControlStateNormal];
    }
    
    
//    UIView *view = [[UIView alloc] init];
//    view.frame = CGRectMake(16,195.7,328,150);
//    view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
//    self.cententBottomView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.03].CGColor;
//    self.cententBottomView.layer.shadowOffset = CGSizeMake(0,3);
//    self.cententBottomView.layer.shadowOpacity = 1;
//    self.cententBottomView.layer.shadowRadius = 5;
//    self.cententBottomView.layer.cornerRadius = 6.7;
    
    self.contentView.layer.cornerRadius = 7;
    self.msgContentView.layer.cornerRadius = 10;
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
//    cyView.imageURLStringsGroup = self.dataArray;
    cyView.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.msgView addSubview:cyView];
    self.cyView = cyView;
//    [self getMessage];
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
    if (sender.tag == 100 || sender.tag == 101 || sender.tag == 102) {
            switch (sender.tag) {
                case 100:{
                    [MCLATESTCONTROLLER.navigationController pushViewController:[jintMyWallViewController new] animated:YES];
                }
                    break;
                case 101:{
                    KDDirectRefundViewController * vc = [[KDDirectRefundViewController alloc]init];
                    vc.navTitle = @"信用卡还款";
                    //订单类型（2为还款记录、3为空卡记录）
                    vc.orderType = @"2";
                    [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 102:
                    [MCLATESTCONTROLLER.navigationController pushViewController:[KDGatheringViewController new] animated:YES];
                    break;
                default:
                    break;
        }
    }else{
        switch (sender.tag) {
            case 200: // 账单管理
                [MCLATESTCONTROLLER.navigationController pushViewController:[KDTrandingRecordViewController new] animated:YES];
                break;
            case 201: // 信用管理
                [MCLATESTCONTROLLER.navigationController pushViewController:[KDCreditManagerViewController new] animated:YES];
                break;
            case 202: // 实名认证
                [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
                    if ([userInfo.certification integerValue] == 1) {
                        [MCToast showMessage:@"您已实名认证"];
                    }else{
                        [MCLATESTCONTROLLER.navigationController pushViewController:[MCManualRealNameController new] animated:YES];
                    }
                }];
               
                break;
            case 203:
                [MCLATESTCONTROLLER.navigationController pushViewController:[KDHomeXinYongKaViewController new] animated:YES];
                break;
            case 204:
                break;
            case 205:
                break;
            case 206: // 备付金
                [MCLATESTCONTROLLER.navigationController pushViewController:[KDProvisionsViewController new] animated:YES];
                break;
            case 207:
                break;
            default:
                break;
        }
    }

   
}
-(void)showRenzhengView{
    QMUIModalPresentationViewController * alert = [[QMUIModalPresentationViewController alloc]init];
    KDRenZhengView * renzhengView = [KDRenZhengView renZhengView];
    renzhengView.frame = CGRectMake(0, 0, 316, 282);
    alert.contentView = renzhengView;
    alert.dimmingView.userInteractionEnabled = NO;
    [alert showWithAnimated:YES completion:nil];
    
    
    renzhengView.quedingBtnActionBlock = ^{
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
    myCell.topLabel.text = [NSString stringWithFormat:@"%@%@", model.title, model.createTime];
    myCell.centerLabel.text = model.content;
    
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    [MCPagingStore pagingURL:rt_notice_list];
}
- (void)getMessage {
    [MCLATESTCONTROLLER.sessionManager mc_GET:[NSString stringWithFormat:@"/user/app/jpush/history/brand/%@",TOKEN] parameters:nil ok:^(MCNetResponse * _Nonnull resp) {
        for (NSDictionary *dic in resp.result[@"content"]) {
            if (![dic[@"btype"] isEqualToString:@"androidVersion"]) { // 过滤安卓消息
                self.dataArray = [MCMessageModel mj_objectArrayWithKeyValuesArray:resp.result[@"content"]];
//                self.dataArray = [NSMutableArray arrayWithArray:@[@"1", @"2", @"3", @"4", @"5", @"6"]];
                self.cyView.localizationImageNamesGroup = self.dataArray;
                break;
            }
        }
    }];
}

- (void)pushTopDelegateVC
{
    [MCLATESTCONTROLLER.sessionManager mc_POST:@"/transactionclear/app/standard/extension/user/query" parameters:@{@"userId":SharedUserInfo.userid} ok:^(MCNetResponse * _Nonnull resp) {
        NSDictionary *dict = resp.result;
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
