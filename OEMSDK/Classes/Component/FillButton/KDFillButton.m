//
//  KDFillButton.m
//  Pods
//
//  Created by wza on 2020/9/9.
//

#import "KDFillButton.h"
#import "MCGradientView.h"

@implementation KDFillButton




- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (self.userInteractionEnabled) {
            [self setupAppearance];

        }else{
            [self setupDisAppearance];

        }
    
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.userInteractionEnabled) {
        [self setupAppearance];

    }else{
        [self setupDisAppearance];

    }
}


- (void)setupAppearance {
    self.clipsToBounds  = YES;
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.bounds;
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:166/255.0 blue:88/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:173/255.0 blue:102/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];

    [bgView.layer insertSublayer:gl atIndex:0];
    
    [self setBackgroundImage:[UIImage qmui_imageWithView:bgView] forState:UIControlStateNormal];
    
    [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
}
- (void)setupDisAppearance {
    self.clipsToBounds  = YES;
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.bounds;
    gl.backgroundColor = [UIColor qmui_colorWithHexString:@"#E7E7E7"].CGColor;
    [bgView.layer insertSublayer:gl atIndex:0];
    
    [self setBackgroundImage:[UIImage qmui_imageWithView:bgView] forState:UIControlStateNormal];
    
    [self setTitleColor:UIColor.darkGrayColor forState:UIControlStateNormal];
}
@end
