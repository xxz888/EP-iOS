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
#import "KDHomeHeaderCardCollectionViewCell.h"
#import "KDXinYongKaViewController.h"
#import "KDMineKehuViewController.h"
#import "KDPayFeesViewController.h"

@interface KDHomeHeaderView ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
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

@property (nonatomic, strong) NSMutableArray * collectDataArray;

@end

@implementation KDHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDHomeHeaderView" owner:nil options:nil] firstObject];
    }
    return self;
}
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)collectDataArray
{
    if (_collectDataArray == nil) {
        _collectDataArray = [NSMutableArray array];
    }
    return _collectDataArray;
}
- (void)awakeFromNib
{
    [super awakeFromNib];

    [self registerView];
    [self setUI];
    [self setSDCycleScrollView];
    [self getMessage];
    
    
    
    [self requestCreditCard];
        
}

-(void)registerView{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"KDHomeHeaderCardCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"KDHomeHeaderCardCollectionViewCell"];
}

-(void)setUI{
    for (QMUIButton *btn in self.topView.subviews) {
        btn.imagePosition = QMUIButtonImagePositionTop;
    }
    BOOL is_acc = [SharedDefaults.phone isEqualToString:@"13383773800"];

    if (is_acc) {
        NSArray *titleArray = @[@"水费", @"电费", @"燃气费", @"有线电视"];
        for (int i = 0; i < 4; i++) {
            QMUIButton *btn = [self.centerView viewWithTag: 200 + i];
            btn.imagePosition = QMUIButtonImagePositionTop;
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"kd_home_bottomA_%d", i]] forState:UIControlStateNormal];
        }
        
        NSArray *titleArray1 = @[@"交通罚款", @"ETC缴费", @"游戏点卡", @"极速办卡"];
        for (int i = 0; i < 4; i++) {
            QMUIButton *btn = [self.cententBottomView viewWithTag: 300 + i];
            btn.imagePosition = QMUIButtonImagePositionTop;
            [btn setTitle:titleArray1[i] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"kd_home_bottomB_%d", i]] forState:UIControlStateNormal];
        }
        
        NSArray *titleArray2 = @[@"卡包", @"账单管理"];
        for (int i = 0; i < 2; i++) {
            QMUIButton *btn = [self.cententBottomView1 viewWithTag: 400 + i];
            btn.imagePosition = QMUIButtonImagePositionTop;
            [btn setTitle:titleArray2[i] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"kd_home_bottomC_%d", i]] forState:UIControlStateNormal];
        }
        
    }else{
        NSArray *titleArray = @[@"智能还款", @"快捷收款", @"空卡还款", @"极速办卡"];
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
       
        
    }

    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.serverView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft  cornerRadii:CGSizeMake(5,5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.serverView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.serverView.layer.mask = maskLayer;
    
    [self.banner2Imv rf_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
        [MCLATESTCONTROLLER.navigationController pushViewController:[[KDXinYongKaViewController alloc] init] animated:YES];

    }];
    
    [self.four1View rf_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
        [MCToast showMessage:@"暂未开放"];
    }];
    [self.four2View rf_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
        [MCToast showMessage:@"暂未开放"];
    }];
    [self.four3View rf_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
        [MCToast showMessage:@"暂未开放"];
    }];
    [self.four4View rf_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
        [MCToast showMessage:@"暂未开放"];
    }];
    
    [self.msgContentView rf_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
        [MCPagingStore pagingURL:rt_notice_list];
    }];
    
    self.contentView.layer.cornerRadius = 7;
    self.lineView.layer.cornerRadius = 2.3;
    __weak typeof(self) weakSelf = self;
    self.bannerView.resetHeightBlock = ^(CGFloat h) {
        weakSelf.bannerHigCons.constant = h;
        if (self.callBack) {
            self.callBack(661 - 128 + h);
        }
    };

     self.hidden3View.hidden = self.hidden4View.hidden = self.hidden5View.hidden = self.hidden6View.hidden = self.hidden7View.hidden = is_acc;
}
-(void)setSDCycleScrollView{
    SDCycleScrollView *cyView = [[SDCycleScrollView alloc] initWithFrame:self.msgView.bounds];
    cyView.delegate = self;
    cyView.backgroundColor = [UIColor clearColor];
    cyView.showPageControl = NO;
    cyView.clipsToBounds = YES;
    [cyView disableScrollGesture];
    cyView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    cyView.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.msgView addSubview:cyView];
    self.cyView = cyView;
 
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
- (IBAction)btnAction:(QMUIButton *)sender {
    BOOL is_acc = [SharedDefaults.phone isEqualToString:@"13383773800"];;

    if (is_acc) {
        if (sender.tag == 300 || sender.tag == 301) {
            [MCToast showMessage:@"暂时请至12123APP缴费"];
            return;
        }
        if (sender.tag == 303) {
            [MCLATESTCONTROLLER.navigationController pushViewController:[KDXinYongKaViewController new] animated:YES];
        }
        if (sender.tag == 400) {
            [MCPagingStore pagingURL:rt_card_list];
            return;
        }
        if (sender.tag == 401) {
            
        }
        KDPayFeesViewController * vc = [[KDPayFeesViewController alloc]init];
        vc.tag = sender.tag;
        [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
        return;
    }
        switch (sender.tag) {
            // 智能管理
            case 200:{[self zhinenghuankuan];}
                break;
            // 快捷收款
            case 201:{[self kuaijieshoukuan];}
                break;
            // 空卡还款
            case 202:{[MCToast showMessage:@"暂未开放"];}
                break;
            //极速办卡
            case 203:{[MCLATESTCONTROLLER.navigationController pushViewController:[KDXinYongKaViewController new] animated:YES];}
                break;
            //小额闪付
            case 300:{[self pushShanfu];}
                break;
            //刷脸付
            case 301:{[self pushShualianfu];}
                break;
            //手机POS"
            case 302:
            { [MCToast showMessage:@"暂未开放"];}
                break;
            //"支付宝收款
            case 303:
            { [MCToast showMessage:@"暂未开放"];}
                break;
            //我的团队
            case 400:{[MCLATESTCONTROLLER.navigationController pushViewController:[[KDMineKehuViewController alloc] init] animated:YES];}
                break;
            //无卡积分
            case 401:{[MCLATESTCONTROLLER.navigationController pushViewController:[KDWukaJifenViewController new] animated:YES];}
                break;
            default:
                break;
        }
}
//

//[MCLATESTCONTROLLER.navigationController pushViewController:[KDTrandingRecordViewController new] animated:YES];
//                if ([SharedUserInfo.certification integerValue] == 1) {
//                    [MCToast showMessage:@"您已实名认证"];
//                }else{
//                    [MCLATESTCONTROLLER.navigationController pushViewController:[MCManualRealNameController new] animated:YES];
//                }

#pragma ------------快捷收款------------
-(void)kuaijieshoukuan{
    __weak typeof(self) weakSelf = self;
    if ([SharedUserInfo.certification integerValue] == 1) {
        KDGatheringViewController * vc = [[KDGatheringViewController alloc]init];
        vc.whereCome = 1;
        [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
    }else{
        [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
            if ([SharedUserInfo.certification integerValue] == 1) {
                KDGatheringViewController * vc = [[KDGatheringViewController alloc]init];
                vc.whereCome = 1;
                [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
            }else{
                [weakSelf showRenzhengView];
            }
        }];
    }
}

#pragma ------------智能还款------------
-(void)zhinenghuankuan{
    __weak typeof(self) weakSelf = self;
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
#pragma ------------小额闪付------------
-(void)pushShanfu{
    __weak typeof(self) weakSelf = self;
    if ([SharedUserInfo.certification integerValue] == 1) {
        KDGatheringViewController * vc = [[KDGatheringViewController alloc]init];
        vc.whereCome = 2;
        [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
    }else{
        [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
            if ([SharedUserInfo.certification integerValue] == 1) {
                KDGatheringViewController * vc = [[KDGatheringViewController alloc]init];
                vc.whereCome = 2;
                [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
                
            }else{
                [weakSelf showRenzhengView];
            }
        }];
    }
    
    
    

}
#pragma ------------刷脸付------------

-(void)pushShualianfu{
    __weak typeof(self) weakSelf = self;
    if ([SharedUserInfo.certification integerValue] == 1) {
        KDGatheringViewController * vc = [[KDGatheringViewController alloc]init];
        vc.whereCome = 3;
        [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
    }else{
        [[MCModelStore shared] reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
            if ([SharedUserInfo.certification integerValue] == 1) {
                KDGatheringViewController * vc = [[KDGatheringViewController alloc]init];
                vc.whereCome = 3;
                [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
                
            }else{
                [weakSelf showRenzhengView];
            }
        }];
    }
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
#pragma mark - SDCycleScrollView 代理方法
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

#pragma mark - collectionView 代理方法

//返回CollectionView中cell的总数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectDataArray count];
}

//设置cell的size,宽为屏幕宽的一半，两个cell间隔10个像素，高为200像素
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize cellSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-50)/3, 130);
    return cellSize;
}

//添加数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KDHomeHeaderCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KDHomeHeaderCardCollectionViewCell" forIndexPath:indexPath];

    [cell.collImv sd_setImageWithURL:self.collectDataArray[indexPath.row][@"logo"] placeholderImage:[UIImage imageNamed:@"logo"]];
    cell.collTitle.text = self.collectDataArray[indexPath.row][@"title"];
    cell.cellContent.text = self.collectDataArray[indexPath.row][@"describe"];
//
    MCBankCardInfo *info = [MCBankStore getBankCellInfoWithName:self.collectDataArray[indexPath.row][@"title"]];
    //cell.collImv.backgroundColor = [info.cardCellBackgroundColor qmui_colorWithAlphaAddedToWhite:0.6];
//
    
//    //垂直分割线
//    CGSize contentSize = self.collectionView.contentSize;
//    UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(contentSize.width * 0.5 - 0.5, 0, 1, contentSize.height - 8)];
//    verticalLine.backgroundColor = [UIColor lightGrayColor];
//    verticalLine.alpha = 0.35;
//    [self.collectionView addSubview:verticalLine];
//
//    //水平分割线
//    UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(0, (cell.frame.size.height + 10) * (indexPath.row + 1) , contentSize.width, 1)];
//    horizontalLine.backgroundColor = [UIColor lightGrayColor];
//    horizontalLine.alpha = 0.35;
//    [self.collectionView addSubview:horizontalLine];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MCWebViewController *web = [[MCWebViewController alloc] init];
    web.urlString = self.collectDataArray[indexPath.row][@"link"];
    web.title =self.collectDataArray[indexPath.row][@"title"];
    [MCLATESTCONTROLLER.navigationController pushViewController:web animated:YES];
}
//更多信用卡
- (IBAction)moreCardAction:(id)sender {
    [MCLATESTCONTROLLER.navigationController pushViewController:[[KDXinYongKaViewController alloc] init] animated:YES];

}

- (IBAction)serviceOnlin:(id)sender {
    
    [MCLATESTCONTROLLER.navigationController pushViewController:[[MCHomeServiceViewController alloc] init] animated:YES];
}







-(void)requestCreditCard{
    kWeakSelf(self);
    [weakself.collectDataArray removeAllObjects];
    [MCSessionManager.shareManager mc_GET:@"/api/v1/player/creditCard" parameters:@{} ok:^(NSDictionary * _Nonnull respDic) {
        NSArray * array   = [[NSMutableArray alloc]initWithArray:respDic];
        
        NSMutableSet *randomSet = [[NSMutableSet alloc] init];

        while ([randomSet count] < 3) {
            int r = arc4random() % [array count];
            [randomSet addObject:[array objectAtIndex:r]];
        }
            
        NSArray *randomArray = [randomSet allObjects];
        [weakself.collectDataArray addObjectsFromArray:randomArray];
        
        [weakself.collectionView reloadData];
    }];
}



- (IBAction)persionAction:(id)sender {
    if (MCModelStore.shared.shareLink) {
        [MCPagingStore pagingURL:rt_share_single];

    }else{
        [MCSessionManager.shareManager mc_GET:@"/api/v1/player/user/propaganda/link" parameters:nil ok:^(NSDictionary * _Nonnull resp) {
            if (resp[@"link"]) {
                MCModelStore.shared.shareLink = resp[@"link"];
                [MCPagingStore pagingURL:rt_share_single];

            }
          
        }];
    }

}




@end
