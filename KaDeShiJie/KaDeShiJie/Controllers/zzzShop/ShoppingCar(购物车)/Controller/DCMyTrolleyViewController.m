//
//  DCMyTrolleyViewController.m
//  CDDStoreDemo
//
//  Created by apple on 2017/7/6.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//
#define collectionViewW 100
#define collectionViewH 150
#define recommendReusableViewH 40
#import "DCMyTrolleyViewController.h"
#import "DCGoodDetailViewController.h"
// Controllers

// Models
#import "DCRecommendItem.h"
// Views
#import "DCEmptyCartView.h"
#import "DCRecommendCell.h"
#import "DCRecommendReusableView.h"
// Vendors
#import <MJExtension.h>
#import "UINavigationController+FDFullscreenPopGesture.h"
// Categories
#import "DCCarView.h"
// Others
#import "RequestTool.h"
#import "KDPaySelectView.h"
#import <AlipaySDK/AlipaySDK.h>

@interface DCMyTrolleyViewController ()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>

/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;
/* 推荐商品数据 */
@property (strong , nonatomic)NSMutableArray<DCRecommendItem *> *recommendItem;

/* 通知 */
@property (weak ,nonatomic) id dcObserve;

@end

static NSString *const DCRecommendCellID = @"DCRecommendCell";

@implementation DCMyTrolleyViewController

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 1;
        layout.itemSize = CGSizeMake(collectionViewW, collectionViewH);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //滚动方向
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        
        //注册Cell
        [_collectionView registerClass:[DCRecommendCell class] forCellWithReuseIdentifier:DCRecommendCellID];
    }
    return _collectionView;
}

- (NSMutableArray<DCRecommendItem *> *)recommendItem
{
    if (!_recommendItem) {
        _recommendItem = [NSMutableArray array];
    }
    return _recommendItem;
}

#pragma mark - LifeCyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBase];
    
    
    
    [self setUpRecommendData];
    
 
    
    [self setUpRecommendReusableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpCarData];

}
#pragma mark - initizlize
- (void)setUpBase
{
    self.navigationController.title = @"购物车";
    self.title = @"购物车";
    self.view.backgroundColor = DCBGColor;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat colBottom = (self.isTabBar == NO) ? DCBottomTabH : 0;
    self.collectionView.frame = CGRectMake(0, ScreenH - collectionViewH - colBottom, ScreenW, collectionViewH);
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
-(void)setUpDCCarView:(NSDictionary *)dic{
    DCCarView * view = [[DCCarView alloc]init];
    [view.titleImv sd_setImageWithURL:dic[@"goodImageView"]];
    view.titlePrice.text = [NSString stringWithFormat:@"价格:%@元",@"198"];
    view.titleLbl.text = dic[@"goodTitle"];
    [view.payBtn addTarget:self action:@selector(alertPay) forControlEvents:UIControlEventTouchUpInside];
    view.frame = CGRectMake(0, DCTopNavH, ScreenW, ScreenH - DCTopNavH - DCBottomTabH - (collectionViewH + recommendReusableViewH));
    [self.view addSubview:view];

}
-(void)alertPay{
    KDPaySelectView *view = [[[NSBundle mainBundle] loadNibNamed:@"KDPaySelectView" owner:nil options:nil] lastObject];
    [view showSelectView];
    
    view.block = ^(NSInteger index) {
        [self alertAliPay];
    };
}


-(void)alertAliPay{
    
    [[MCSessionManager shareManager] mc_Post_QingQiuTi:@"/api/v1/player/shop/order/aliPay" parameters:
     @{ @"shopReceiptAddressId":@"54",
        @"sku":@"sd15sas726af" }
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

-(void)setUpCarData{
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"car"];
    if (dic) {
        [self setUpDCCarView:dic];
    }else{
        [self setUpEmptyCartView];
  
    }
}

#pragma mark - 推荐商品数据
- (void)setUpRecommendData
{
    WEAKSELF
    [RequestTool requestWithType:2 URL:@"http://api.zhifu168.com/api/shop/api/getGood/all" parameter:@{@"cid":@(arc4random() % 15),@"page":@"1",@"page_size":@"20"} successComplete:^(id responseObject) {
        
        weakSelf.recommendItem = [[NSMutableArray alloc]init];
        
        for (NSDictionary * dic in responseObject[@"content"]) {
            DCRecommendItem * item = [[DCRecommendItem alloc]init];
            item.image_url = dic[@"pict_url"];
            item.main_title = dic[@"title"];
            item.price = dic[@"quanhou_jiage"];
            item.volume = dic[@"volume"];
            item.tao_id = dic[@"tao_id"];
            item.goods_title = dic[@"tao_id"];
            item.images = [dic[@"small_images"] split:@"|"];
            
            [weakSelf.recommendItem addObject:item];
        
        }
        [self.collectionView reloadData];
        
        
        
    } failureComplete:^(NSError *error) {
        
    }];
//    _gridItem = [DCGridItem mj_objectArrayWithFilename:@"GoodsGrid.plist"];
    
}

#pragma mark - 推荐提示View
- (void)setUpRecommendReusableView
{
    DCRecommendReusableView *recommendReusableView = [[DCRecommendReusableView alloc]init];
    recommendReusableView.backgroundColor = self.collectionView.backgroundColor;
    [self.view addSubview:recommendReusableView];
    recommendReusableView.frame = CGRectMake(0, _collectionView.dc_y - recommendReusableViewH, ScreenW, recommendReusableViewH);
}

#pragma mark - 初始化空购物车View
- (void)setUpEmptyCartView
{
    DCEmptyCartView *emptyCartView = [[DCEmptyCartView alloc] init];
    [self.view addSubview:emptyCartView];
    
    emptyCartView.frame = CGRectMake(0, DCTopNavH, ScreenW, ScreenH - DCTopNavH - DCBottomTabH - (collectionViewH + recommendReusableViewH));
    emptyCartView.buyingClickBlock = ^{
        [self.tabBarController setSelectedIndex:0];
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _recommendItem.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DCRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCRecommendCellID forIndexPath:indexPath];
    cell.recommendItem = _recommendItem[indexPath.row];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DCGoodDetailViewController *dcVc = [[DCGoodDetailViewController alloc] init];
    dcVc.goodTitle = _recommendItem[indexPath.row].main_title;
    dcVc.goodPrice = _recommendItem[indexPath.row].price;
    dcVc.goodSubtitle = _recommendItem[indexPath.row].goods_title;
    dcVc.shufflingArray = _recommendItem[indexPath.row].images;
    dcVc.goodImageView = _recommendItem[indexPath.row].image_url;
    
    [self.navigationController pushViewController:dcVc animated:YES];
    NSLog(@"点击了推荐商品");
    
}


#pragma mark - 消失
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:_dcObserve];
}

@end
