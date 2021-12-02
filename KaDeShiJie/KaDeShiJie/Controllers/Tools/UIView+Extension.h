//
//  UIView+Extension.h
//  LC
//
//  Created by Jint on 15/10/4.
//  Copyright (c) 2015年 Jint. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TapActionBlock)(UITapGestureRecognizer *gestureRecoginzer);

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic,assign) CGFloat width;

@property (nonatomic,assign) CGFloat height;

@property (nonatomic,assign,readonly) CGFloat bottom;

@property (nonatomic,assign,readonly) CGFloat maxX;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;
@property (nonatomic,assign) CGSize  size;
/**
 *  @brief  添加tap手势
 *
 *  @param block 代码块
 */
- (void)rf_addTapActionWithBlock:(TapActionBlock)block;
/**
 * 给UIView 设置圆角
 */
@property (assign,nonatomic) IBInspectable CGFloat cornerRadius;
@property (assign,nonatomic) IBInspectable BOOL  masksToBounds;

/**
 * 设置 view的 边框颜色(选择器和Hex颜色)
 * 以及 边框的宽度
 */
@property (assign,nonatomic) IBInspectable CGFloat borderWidth;
@property (strong,nonatomic) IBInspectable NSString  *borderHexRgb;
@property (strong,nonatomic) IBInspectable UIColor   *borderColor;

-(void)selectStatus:(UIView *)whoView cornerRadius:(NSInteger)cornerRadius;
@end
