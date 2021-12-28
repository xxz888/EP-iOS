//
//  KDJFShopViewController.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/6.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDJFShopViewController.h"
#import "KDJFShopHeaderCollectionReusableView.h"
#import "KDJFShopCollectionViewCell.h"
#import "KDJFShopDetailViewController.h"
#import "KDJFOrderListViewController.h"

@interface KDJFShopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * jfCollectionView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation KDJFShopViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = CGRectMake(0, NavigationContentTop, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationContentTop-kTabBarHeight);
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    self.jfCollectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
    self.jfCollectionView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.jfCollectionView.delegate = self;
    self.jfCollectionView.dataSource = self;
    [self.jfCollectionView registerNib:[UINib nibWithNibName:@"KDJFShopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"KDJFShopCollectionViewCell"];
    [self.view addSubview:self.jfCollectionView];
    self.view.backgroundColor = self.jfCollectionView.backgroundColor = [UIColor whiteColor];

    
    if (@available(iOS 11.0, *)) {
        self.jfCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//    [self setNavigationBarTitle:@"商城" backgroundImage:[UIImage qmui_imageWithColor:UIColor.mainColor]];
    
    [self setNavigationBarTitle:@"商城" tintColor:nil];
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"我的订单" forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.titleLabel.font = LYFont(13);
    shareBtn.frame = CGRectMake(SCREEN_WIDTH - 70, StatusBarHeightConstant + 12, 70, 22);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
    [self requestCollectionData];
}
-(void)clickRightBtnAction{
//    [self.navigationController pushViewController:[KDJFOrderListViewController new] animated:YES];
    [MCToast showMessage:@"开发中"];
}
-(void)requestCollectionData{
    kWeakSelf(self);
    [self.sessionManager mc_GET:@"/api/v1/player/shop/product" parameters:@{} ok:^(NSDictionary * _Nonnull respDic) {
        weakself.dataArray  = [[NSMutableArray alloc]initWithArray:respDic];
        [weakself.jfCollectionView reloadData];
    }];
    
    return;
    [self.sessionManager mc_Post_QingQiuTi:@"facade/app/coin/goods/list" parameters:@{@"name":@"",@"page":@"1",@"size":@"20"} ok:^(NSDictionary * _Nonnull resp) {
      
    } other:^(NSDictionary * _Nonnull resp) {
        [MCLoading hidden];
    } failure:^(NSError * _Nonnull error) {
        [MCLoading hidden];
    }];
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"KDJFShopCollectionViewCell";
    KDJFShopCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.collTitle.text = self.dataArray[indexPath.row][@"title"];
    cell.collPrice.text = [NSString stringWithFormat:@"¥%@元",self.dataArray[indexPath.row][@"price"]];
    [cell.collImv sd_setImageWithURL:self.dataArray[indexPath.row][@"logo"] placeholderImage:[UIImage imageNamed:@"logo"]];

    cell.backgroundColor = KWhiteColor;
    return cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (KScreenWidth - 34)/2;
    CGFloat height = width * 1.2;
    return CGSizeMake(width, height);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 12, 12, 12);
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [MCToast showMessage:@"开发中"];
    return;
    KDJFShopDetailViewController * vc = [[KDJFShopDetailViewController alloc]init];
    vc.goodDic = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 要先设置表头大小
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 248+(KScreenWidth-24)*0.43);
    return size;
}
 
// 创建一个继承collectionReusableView的类,用法类比tableViewcell
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // 头部视图
        // 代码初始化表头
        // [collectionView registerClass:[HeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView"];
        // xib初始化表头
        [collectionView registerNib:[UINib nibWithNibName:@"KDJFShopHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KDJFShopHeaderCollectionReusableView"];
        KDJFShopHeaderCollectionReusableView * tempHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KDJFShopHeaderCollectionReusableView" forIndexPath:indexPath];
        reusableView = tempHeaderView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        // 底部视图
    }
    return reusableView;
}

@end
