//
//  KDMyWallView.m
//  KaDeShiJie
//
//  Created by BH on 2021/11/24.
//  Copyright © 2021 SS001. All rights reserved.
//

#import "KDMyWallView.h"
#import "KDTiXianViewController.h"
#import "KDTixianjiluViewController.h"
#import "KDZhiFuShouYiViewController.h"
#import "KDJiangLiShouYiViewController.h"
#import "KDWallDetailViewController.h"

@implementation KDMyWallView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDMyWallView" owner:nil options:nil] firstObject];
    }
    return self;
}
-(void)setDataDic:(NSDictionary *)dic{
    self.dangqianshouru.text = [NSString stringWithFormat:@"%.3f",[dic[@"balance"] doubleValue]];
    self.lishitixian.text = [NSString stringWithFormat:@"%.3f",[dic[@"totalCommission"] doubleValue]];
    self.ketixian.text = [NSString stringWithFormat:@"%.3f",[dic[@"availableAmount"] doubleValue]];
}

- (void)drawRect:(CGRect)rect {
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTixiantView:)];
    [self.tixianView addGestureRecognizer:tap];
    
    
    UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickzhifushouyiView:)];
    [self.zhifushouyiView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickjianglishouyiView:)];
    [self.jianglishouyiView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer* tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickqianbaomingxiView:)];
    [self.qianbaomingxiView addGestureRecognizer:tap3];
}

-(void)clickTixiantView:(id)tap{
    KDTiXianViewController * vc = [[KDTiXianViewController alloc]init];
    [MCLATESTCONTROLLER.navigationController pushViewController:vc animated:YES];
//    [MCLATESTCONTROLLER.navigationController pushViewController:[KDTiXianViewController new] animated:YES];

//    [MCLATESTCONTROLLER.navigationController pushViewController:[MCWithdrawController new] animated:YES];
}
-(void)clickzhifushouyiView:(id)tap{
    
    [MCLATESTCONTROLLER.navigationController pushViewController:[KDZhiFuShouYiViewController new] animated:YES];

    
}
-(void)clickjianglishouyiView:(id)tap{
    
    [MCLATESTCONTROLLER.navigationController pushViewController:[KDJiangLiShouYiViewController new] animated:YES];

    
}
-(void)clickqianbaomingxiView:(id)tap{
    [MCLATESTCONTROLLER.navigationController pushViewController:[KDWallDetailViewController new] animated:YES];
    
}
@end
