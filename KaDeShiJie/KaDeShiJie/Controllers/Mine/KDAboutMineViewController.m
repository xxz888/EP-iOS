//
//  KDAboutMineViewController.m
//  KaDeShiJie
//
//  Created by SS001 on 2020/9/14.
//  Copyright © 2020 SS001. All rights reserved.
//

#import "KDAboutMineViewController.h"

@interface KDAboutMineViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHigCons;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLbl;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end

@implementation KDAboutMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:@"关于我们" tintColor:nil];
    self.topImage.layer.cornerRadius = 10;
    
    self.versionLbl.text = [NSString stringWithFormat:@"v%@",SharedAppInfo.version];
    [self getData];
}

- (void)getData {
    
 
    //添加手势
    self.telLabel.text = [NSString stringWithFormat:@"客服电话:%@",SharedDefaults.servicePhone];
    self.telLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCall:)];
    [self.telLabel addGestureRecognizer:tap];
    
//    self.telLabel.text = [NSString stringWithFormat:@"电话：%@",SharedBrandInfo.brandPhone];
}
-(void)clickCall:(id)tap{
    [MCServiceStore call:SharedDefaults.servicePhone];

}
@end
