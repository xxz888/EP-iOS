//
//  DCHandPickViewController.m
//  CDDMall
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCHandPickViewController.h"

// Controllers
#import "DCNavigationController.h"
#import "DCGoodsSetViewController.h"
#import "DCCommodityViewController.h"
#import "DCMyTrolleyViewController.h"
#import "DCGoodDetailViewController.h"
#import "DCGMScanViewController.h"
// Models
#import "DCGridItem.h"
#import "DCRecommendItem.h"
// Views
#import "DCNavSearchBarView.h"
#import "DCHomeTopToolView.h"
/* cell */
#import "DCGoodsCountDownCell.h" //倒计时商品
#import "DCNewWelfareCell.h"     //新人福利
#import "DCGoodsHandheldCell.h"  //掌上专享
#import "DCExceedApplianceCell.h"//不止
#import "DCGoodsYouLikeCell.h"   //猜你喜欢商品
#import "DCGoodsGridCell.h"      //10个选项
/* head */
#import "DCSlideshowHeadView.h"  //轮播图
#import "DCCountDownHeadView.h"  //倒计时标语
#import "DCYouLikeHeadView.h"    //猜你喜欢等头部标语
/* foot */
#import "DCTopLineFootView.h"    //热点
#import "DCOverFootView.h"       //结束
#import "DCScrollAdFootView.h"   //底滚动广告
// Vendors
#import "DCHomeRefreshGifHeader.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
// Categories
#import "UIBarButtonItem+DCBarButtonItem.h"
// Others
#import "CDDTopTip.h"
#import "NetworkUnit.h"
#import "DCClassMianItem.h"
#import "RequestTool.h"
#import "DCGoodDetailViewController.h"
@interface DCHandPickViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;
/* 10个属性 */
@property (strong , nonatomic)NSMutableArray<DCGridItem *> *gridItem;
/* 推荐商品属性 */
@property (strong , nonatomic)NSMutableArray<DCRecommendItem *> *youLikeItem;
/* 顶部工具View */
@property (nonatomic, strong) DCHomeTopToolView *topToolView;
/* 滚回顶部按钮 */
@property (strong , nonatomic)UIButton *backTopButton;
@property (nonatomic,  assign) BOOL  statusBarFlag;

@end
/* cell */
static NSString *const DCGoodsCountDownCellID = @"DCGoodsCountDownCell";
static NSString *const DCNewWelfareCellID = @"DCNewWelfareCell";
static NSString *const DCGoodsHandheldCellID = @"DCGoodsHandheldCell";
static NSString *const DCGoodsYouLikeCellID = @"DCGoodsYouLikeCell";
static NSString *const DCGoodsGridCellID = @"DCGoodsGridCell";
static NSString *const DCExceedApplianceCellID = @"DCExceedApplianceCell";
/* head */
static NSString *const DCSlideshowHeadViewID = @"DCSlideshowHeadView";
static NSString *const DCCountDownHeadViewID = @"DCCountDownHeadView";
static NSString *const DCYouLikeHeadViewID = @"DCYouLikeHeadView";
/* foot */
static NSString *const DCTopLineFootViewID = @"DCTopLineFootView";
static NSString *const DCOverFootViewID = @"DCOverFootView";
static NSString *const DCScrollAdFootViewID = @"DCScrollAdFootView";

@implementation DCHandPickViewController

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.frame = CGRectMake(0, -StatusBarHeightConstant, ScreenW, ScreenH - DCBottomTabH+StatusBarHeightConstant);
        _collectionView.showsVerticalScrollIndicator = NO;        //注册

        [_collectionView registerClass:[DCGoodsCountDownCell class] forCellWithReuseIdentifier:DCGoodsCountDownCellID];
        [_collectionView registerClass:[DCGoodsHandheldCell class] forCellWithReuseIdentifier:DCGoodsHandheldCellID];
        [_collectionView registerClass:[DCGoodsYouLikeCell class] forCellWithReuseIdentifier:DCGoodsYouLikeCellID];
        [_collectionView registerClass:[DCGoodsGridCell class] forCellWithReuseIdentifier:DCGoodsGridCellID];
        [_collectionView registerClass:[DCExceedApplianceCell class] forCellWithReuseIdentifier:DCExceedApplianceCellID];
        [_collectionView registerClass:[DCNewWelfareCell class] forCellWithReuseIdentifier:DCNewWelfareCellID];
        
        
        [_collectionView registerClass:[DCTopLineFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCTopLineFootViewID];
        [_collectionView registerClass:[DCOverFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCOverFootViewID];
        [_collectionView registerClass:[DCScrollAdFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCScrollAdFootViewID];
        
        [_collectionView registerClass:[DCYouLikeHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCYouLikeHeadViewID];
        [_collectionView registerClass:[DCSlideshowHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCSlideshowHeadViewID];
        [_collectionView registerClass:[DCCountDownHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCCountDownHeadViewID];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBase];
    
    [self setUpNavTopView];
    
    [self setUpGoodsData];
    
    [self setUpScrollToTopView];
    
    [self setUpGIFRrfresh];
    
    [self getNetwork];
}

#pragma mark - initialize
- (void)setUpBase
{
    _statusBarFlag = NO;
    self.collectionView.backgroundColor = DCBGColor;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
 
        return UIStatusBarStyleLightContent; // 白色
}

#pragma mark - 获取网络
- (void)getNetwork
{
    if ([[NetworkUnit getInternetStatus] isEqualToString:@"notReachable"]) { //网络
        [CDDTopTip showTopTipWithMessage:@"您现在暂无可用网络"];
    }
}


#pragma mark - 设置头部header
- (void)setUpGIFRrfresh
{
    self.collectionView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(setUpRecData)];
}

#pragma mark - 刷新
- (void)setUpRecData
{
    WEAKSELF
    [DCSpeedy dc_callFeedback]; //触动
    [self setUpGoodsData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ //手动延迟
        [weakSelf.collectionView.mj_header endRefreshing];
    });
}

#pragma mark - 加载数据
- (void)setUpGoodsData
{
    
//    {"page":"1","cid":"4","page_size":"14"}
    WEAKSELF
    [RequestTool requestWithType:2 URL:@"http://api.zhifu168.com/api/shop/api/getGood/all" parameter:@{@"cid":@(arc4random() % 15),@"page":@"1",@"page_size":@"20"} successComplete:^(id responseObject) {
        
        weakSelf.youLikeItem = [[NSMutableArray alloc]init];
        
        for (NSDictionary * dic in responseObject[@"content"]) {
            DCRecommendItem * item = [[DCRecommendItem alloc]init];
            item.image_url = dic[@"pict_url"];
            item.main_title = dic[@"title"];
            item.price = dic[@"quanhou_jiage"];
            item.volume = dic[@"volume"];
            item.tao_id = dic[@"tao_id"];
            item.goods_title = dic[@"tao_id"];
            item.images = [dic[@"small_images"] split:@"|"];
            
            [weakSelf.youLikeItem addObject:item];
        
        }
        [self.collectionView reloadData];
        
        
        
    } failureComplete:^(NSError *error) {
        
    }];
    _gridItem = [DCGridItem mj_objectArrayWithFilename:@"GoodsGrid.plist"];
//    _youLikeItem = [DCRecommendItem mj_objectArrayWithFilename:@"HomeHighGoods.plist"];
}

#pragma mark - 滚回顶部
- (void)setUpScrollToTopView
{
    _backTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_backTopButton];
    [_backTopButton addTarget:self action:@selector(ScrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [_backTopButton setImage:[UIImage imageNamed:@"btn_UpToTop"] forState:UIControlStateNormal];
    _backTopButton.hidden = YES;
    _backTopButton.frame = CGRectMake(ScreenW - 50, ScreenH - 110, 40, 40);
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    _topToolView = [[DCHomeTopToolView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 64)];
    WEAKSELF
    _topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了首页扫一扫");
        DCGMScanViewController *dcGMvC = [DCGMScanViewController new];
        dcGMvC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:dcGMvC animated:YES];
    };
    _topToolView.rightItemClickBlock = ^{
        NSLog(@"点击了首页分类");
        DCCommodityViewController *dcComVc = [DCCommodityViewController new];
        dcComVc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:dcComVc animated:YES];
    };
    _topToolView.rightRItemClickBlock = ^{
        [weakSelf unlogin];
        NSLog(@"点击了首页购物车");
        DCMyTrolleyViewController *shopCarVc = [DCMyTrolleyViewController new];
        shopCarVc.hidesBottomBarWhenPushed = YES;
        shopCarVc.isTabBar = YES;
        shopCarVc.title = @"购物车";
        [weakSelf.navigationController pushViewController:shopCarVc animated:YES];
    };
    _topToolView.searchButtonClickBlock = ^{
        NSLog(@"点击了首页搜索");
    };
    _topToolView.voiceButtonClickBlock = ^{
        NSLog(@"点击了首页语音");
    };
    [self.view addSubview:_topToolView];
    
}
-(void)unlogin{
    if (!TOKEN) {
        //选择
        __weak typeof(self) weakSelf = self;
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [MCApp userLogout];
        }];
        [alert addAction:action1];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           

        }];
        


        [alert addAction:action];
        [self presentViewController:alert animated:NO completion:nil];
        
        
        
        return;
    }
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 6;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) { //10属性
        return _gridItem.count;
    }
    if (section == 1 || section == 2 || section == 3) { //广告福利  倒计时  掌上专享
        return 0;
    }
    if (section == 4) { //推荐
        return 0;
    }
    if (section == 5) { //猜你喜欢
        return _youLikeItem.count;
    }
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    if (indexPath.section == 0) {//10
        DCGoodsGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCGoodsGridCellID forIndexPath:indexPath];
        cell.gridItem = _gridItem[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        gridcell = cell;
        
    }else if (indexPath.section == 1) {//广告福利
        DCNewWelfareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCNewWelfareCellID forIndexPath:indexPath];
        gridcell = cell;
    }
    else if (indexPath.section == 2) {//倒计时
        DCGoodsCountDownCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCGoodsCountDownCellID forIndexPath:indexPath];
        gridcell = cell;
    }
    else if (indexPath.section == 3) {//掌上专享
        DCExceedApplianceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCExceedApplianceCellID forIndexPath:indexPath];
        cell.goodExceedArray = GoodsRecommendArray;
        gridcell = cell;

    }
    else if (indexPath.section == 4) {//推荐
        DCGoodsHandheldCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCGoodsHandheldCellID forIndexPath:indexPath];
        NSArray *images = GoodsHandheldImagesArray;
        cell.handheldImage = images[indexPath.row];
        gridcell = cell;
    }
    else {//猜你喜欢
        DCGoodsYouLikeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCGoodsYouLikeCellID forIndexPath:indexPath];
        cell.lookSameBlock = ^{
            NSLog(@"点击了第%zd商品的找相似",indexPath.row);
        };
        cell.youLikeItem = _youLikeItem[indexPath.row];
        gridcell = cell;
    }
    return gridcell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            DCSlideshowHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCSlideshowHeadViewID forIndexPath:indexPath];
            headerView.imageGroupArray = GoodsHomeSilderImagesArray;
            reusableview = headerView;
        }else if (indexPath.section == 2){
            DCCountDownHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCCountDownHeadViewID forIndexPath:indexPath];
            reusableview = headerView;
        }else if (indexPath.section == 4){
            DCYouLikeHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCYouLikeHeadViewID forIndexPath:indexPath];
            [headerView.likeImageView sd_setImageWithURL:[NSURL URLWithString:@"http://gfs7.gomein.net.cn/T1WudvBm_T1RCvBVdK.png"]];
            reusableview = headerView;
        }else if (indexPath.section == 5){
            DCYouLikeHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCYouLikeHeadViewID forIndexPath:indexPath];
            [headerView.likeImageView sd_setImageWithURL:[NSURL URLWithString:@"http://gfs7.gomein.net.cn/T1WudvBm_T1RCvBVdK.png"]];
            reusableview = headerView;
        }

    }
    if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 0) {
            DCTopLineFootView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCTopLineFootViewID forIndexPath:indexPath];
            reusableview = footview;
            footview.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
            [footview addGestureRecognizer:tap];
            
            
        }else if (indexPath.section == 3){
            DCScrollAdFootView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCScrollAdFootViewID forIndexPath:indexPath];
            reusableview = footerView;
        }else if (indexPath.section == 5) {
            DCOverFootView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCOverFootViewID forIndexPath:indexPath];
            reusableview = footview;
        }
    }

    return reusableview;
}

-(void)tapHandler:(id)tap{
    DCGoodDetailViewController *dcVc = [[DCGoodDetailViewController alloc] init];
       dcVc.goodTitle = @"三星s22礼盒全新samsung galaxy";
       dcVc.goodPrice = @"5799";
       dcVc.goodSubtitle = @"【新品现货 顺丰速发 旗舰新品定制礼盒】三星S22礼盒全新官方正品智能5G数码手机 Samsung Galaxy全网通";
       
       NSArray * arr = @[@"https://img.alicdn.com/i1/370627083/O1CN018JHMhU22C44ibqDws_!!370627083.jpg"];
       dcVc.shufflingArray = arr;
       dcVc.goodImageView = @"https://img.alicdn.com/bao/uploaded/i2/370627083/O1CN01jyj4zV22C44rTLwmA_!!0-item_pic.jpg";
       dcVc.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:dcVc animated:YES];

}
//这里我为了直观的看出每组的CGSize设置用if 后续我会用简洁的三元表示
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//9宫格组
        return CGSizeMake(ScreenW/5 , ScreenW/5 + DCMargin);
    }
    if (indexPath.section == 1) {//广告
        return CGSizeMake(ScreenW, 180);
    }
    if (indexPath.section == 2) {//计时
        return CGSizeMake(ScreenW, 150);
    }
    if (indexPath.section == 3) {//掌上
        return CGSizeMake(ScreenW,ScreenW * 0.35 + 120);
    }
    if (indexPath.section == 4) {//推荐组
        return [self layoutAttributesForItemAtIndexPath:indexPath].size;
    }
    if (indexPath.section == 5) {//猜你喜欢
        return CGSizeMake((ScreenW - 4)/2, (ScreenW - 4)/2 + 40);
    }
    return CGSizeZero;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            layoutAttributes.size = CGSizeMake(ScreenW, ScreenW * 0.38);
        }else if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4){
            layoutAttributes.size = CGSizeMake(ScreenW * 0.5, ScreenW * 0.24);
        }else{
            layoutAttributes.size = CGSizeMake(ScreenW * 0.25, ScreenW * 0.35);
        }
    }
    return layoutAttributes;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return CGSizeMake(ScreenW, 230); //图片滚动的宽高
    }
//    if (section == 2 || section == 4 || section == 5) {//猜你喜欢的宽高
//        return CGSizeMake(ScreenW, 40);  //推荐适合的宽高
//    }
    if (section == 5) {//猜你喜欢的宽高
        return CGSizeMake(ScreenW, 40);  //推荐适合的宽高
    }
    return CGSizeZero;
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(ScreenW, 130);  //Top头条的宽高
    }
//    if (section == 3) {
//        return CGSizeMake(ScreenW, 80); // 滚动广告
//    }
    if (section == 5) {
        return CGSizeMake(ScreenW, 40); // 结束
    }
    return CGSizeZero;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 5) ? 4 : 0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 5) ? 4 : 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<DCClassMianItem *> * mainItem = @[];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            mainItem = [DCClassMianItem mj_objectArrayWithFilename:@"ClassiftyGoods00.plist"];
            
        }else  if (indexPath.row == 1) {
            mainItem = [DCClassMianItem mj_objectArrayWithFilename:@"ClassiftyGoods01.plist"];
            
        }else  if (indexPath.row == 2) {
            mainItem = [DCClassMianItem mj_objectArrayWithFilename:@"ClassiftyGoods02.plist"];

        }else  if (indexPath.row == 3) {
            mainItem = [DCClassMianItem mj_objectArrayWithFilename:@"ClassiftyGoods09.plist"];

        }else  if (indexPath.row == 4) {
            mainItem = [DCClassMianItem mj_objectArrayWithFilename:@"ClassiftyGoods05.plist"];

        }else  if (indexPath.row == 5) {
            mainItem = [DCClassMianItem mj_objectArrayWithFilename:@"ClassiftyGoods08.plist"];

        }else  if (indexPath.row == 6) {
            mainItem = [DCClassMianItem mj_objectArrayWithFilename:@"ClassiftyGoods10.plist"];

        }else  if (indexPath.row == 7) {
            mainItem = [DCClassMianItem mj_objectArrayWithFilename:@"ClassiftyGoods03.plist"];

        }else  if (indexPath.row == 8) {
            mainItem = [DCClassMianItem mj_objectArrayWithFilename:@"ClassiftyGoods07.plist"];

        }else  if (indexPath.row == 9) {
            mainItem = [DCClassMianItem mj_objectArrayWithFilename:@"ClassiftyGoods11.plist"];

        }
        NSInteger  index= [@(arc4random() % 4) integerValue];
        DCCalssSubItem * item = mainItem[indexPath.section].goods[index];
        DCGoodsSetViewController *goodSetVc = [[DCGoodsSetViewController alloc] init];
        goodSetVc.calssSubItem = item;
        goodSetVc.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:goodSetVc animated:YES];
    }

    
    if (indexPath.section == 5) {
        DCGoodDetailViewController *dcVc = [[DCGoodDetailViewController alloc] init];
        dcVc.goodTitle = self.youLikeItem[indexPath.row].main_title;
        dcVc.goodPrice = self.youLikeItem[indexPath.row].price;
        dcVc.goodSubtitle = self.youLikeItem[indexPath.row].goods_title;
        dcVc.shufflingArray = self.youLikeItem[indexPath.row].images;
        dcVc.goodImageView = self.youLikeItem[indexPath.row].image_url;
        dcVc.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:dcVc animated:YES];
    }
    

}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    _backTopButton.hidden = (scrollView.contentOffset.y > ScreenH) ? NO : YES;//判断回到顶部按钮是否隐藏
    _topToolView.hidden = (scrollView.contentOffset.y < 0) ? YES : NO;//判断顶部工具View的显示和隐形
    
    if (scrollView.contentOffset.y > DCNaviH) {
        _statusBarFlag = NO;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [[NSNotificationCenter defaultCenter]postNotificationName:SHOWTOPTOOLVIEW object:nil];
    }else{
        _statusBarFlag = YES;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [[NSNotificationCenter defaultCenter]postNotificationName:HIDETOPTOOLVIEW object:nil];
    }
}

#pragma mark - collectionView滚回顶部
- (void)ScrollToTop
{
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

#pragma mark - 消息
- (void)messageItemClick
{

}
@end
