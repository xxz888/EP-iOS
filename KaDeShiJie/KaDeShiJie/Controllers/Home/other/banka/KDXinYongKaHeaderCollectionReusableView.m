//
//  KDXinYongKaHeaderCollectionReusableView.m
//  KaDeShiJie
//
//  Created by apple on 2021/6/8.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDXinYongKaHeaderCollectionReusableView.h"
#import "KDJFChangeViewController.h"

@interface KDXinYongKaHeaderCollectionReusableView()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cyView;
@end
@implementation KDXinYongKaHeaderCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    ViewRadius(self.personImv, 15);
//    SDCycleScrollView *cyView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth-24, (KScreenWidth-24)*0.43)];
//    cyView.layer.cornerRadius = 7;
//    cyView.delegate = self;
//    cyView.backgroundColor = [UIColor clearColor];
//    cyView.showPageControl = YES;
//    cyView.clipsToBounds = YES;
//    [cyView disableScrollGesture];
//    cyView.localizationImageNamesGroup =@[@"画板 1.png"];
//    cyView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    cyView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
//
//    [self.lunboView addSubview:cyView];
//    self.cyView = cyView;
//    self.btn1.imagePosition = QMUIButtonImagePositionTop;
//    self.btn2.imagePosition = QMUIButtonImagePositionTop;
//    self.btn3.imagePosition = QMUIButtonImagePositionTop;
//    self.btn4.imagePosition = QMUIButtonImagePositionTop;
//
//    [self.personImv sd_setImageWithURL:[NSURL URLWithString:SharedUserInfo.headImvUrl]];
//    self.personTitle.text = SharedUserInfo.realname;
////    [self requestJiFenData];
//    //添加手势
//    self.jifenView.userInteractionEnabled = YES;
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickNoAdressAction:)];
//    [self.jifenView addGestureRecognizer:tap];
}
-(void)clickNoAdressAction:(id)tap{
    [MCLATESTCONTROLLER.navigationController pushViewController:[KDJFChangeViewController new] animated:YES];

}
//查询积分
-(void)requestJiFenData{
    kWeakSelf(self);
    
    [MCLATESTCONTROLLER.sessionManager mc_Post_QingQiuTi:@"user/app/coin/get" parameters:@{} ok:^(NSDictionary * _Nonnull resp) {
        weakself.jifenLbl.text = [NSString stringWithFormat:@"%@",resp[@"result"]];
    } other:^(NSDictionary * _Nonnull resp) {
        [MCLoading hidden];
    } failure:^(NSError * _Nonnull error) {
        [MCLoading hidden];
    }];
}
@end
