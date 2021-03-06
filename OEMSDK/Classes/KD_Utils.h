//
//  define.h
//  MiAiApp
//
//  Created by 王沛 on 2017/5/18.
//  Copyright © 2015年 王沛. All rights reserved.
//

// 全局工具类宏定义

#ifndef define_h
#define define_h
//获取屏幕宽高
#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreen_Bounds [UIScreen mainScreen].bounds
//获取系统对象
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kAppDelegate        [AppDelegate shareAppDelegate]
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)
/*底部安全区域远离高度*/
#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX kScreenWidth >=375.0f && kScreenHeight >=812.0f&& kIs_iphone
#define kBottomSafeHeight (CGFloat)(kIs_iPhoneX?(34.0):(0))



#define Iphone6ScaleWidth KScreenWidth/375.0
#define Iphone6ScaleHeight KScreenHeight/667.0
//根据ip6的屏幕来拉伸
#define kRealWidthValue(with) ((with)*(KScreenWidth/375.0f))
#define kRealHeightValue(height) ((height)*(KScreenHeight/667.0f))
#define kGet_width(view) view.frame.size.width
#define kGet_height(view) view.frame.size.height
//强弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;

//View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//property 属性快速声明 别用宏定义了，使用代码块+快捷键实现吧

// 当前系统版本
#define CurrentSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]
//当前语言
#define CurrentLanguage (［NSLocale preferredLanguages] objectAtIndex:0])

//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif



//颜色
#define KClearColor [UIColor clearColor]
#define KWhiteColor [UIColor whiteColor]
#define KBlackColor [UIColor blackColor]
#define KGrayColor [UIColor grayColor]
#define KGray2Color [UIColor lightGrayColor]
#define KBlueColor [UIColor blueColor]
#define KRedColor [UIColor redColor]
#define kRandomColor    KRGBColor(arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)        //随机色生成

//字体
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]

#define Font_System(FONTSIZE)      [UIFont systemFontOfSize:FONTSIZE weight:UIFontWeightRegular]
#define Font_Medium(FONTSIZE)      [UIFont systemFontOfSize:FONTSIZE weight:UIFontWeightMedium]


#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]
#define FONT_AUTO(FONTSIZE, WEIGHT) [UIFont systemFontOfSize:FONTSIZE weight:WEIGHT];

//定义UIImage对象
#define ImageWithFile(_pointer) [UIImage imageWithContentsOfFile:([[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%dx", _pointer, (int)[UIScreen mainScreen].nativeScale] ofType:@"png"])]
#define IMAGE_NAMED(name) [UIImage imageNamed:name]

//数据验证
#define StrValid(f) (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define SafeStr(f) (StrValid(f) ? f:@"")
#define HasString(str,key) ([str rangeOfString:key].location!=NSNotFound)

#define ValidStr(f) StrValid(f)
#define ValidDict(f) (f!=nil && [f isKindOfClass:[NSDictionary class]])
#define ValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define ValidNum(f) (f!=nil && [f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls) (f!=nil && [f isKindOfClass:[cls class]])
#define ValidData(f) (f!=nil && [f isKindOfClass:[NSData class]])



//获取一段时间间隔
#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTime  NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)
//打印当前方法名
#define ITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)
//请求参数
#define SetParameter(value,key) [_parameterDic setValue:(value) forKey:(key)]
//发送通知
#define KPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];
//弹框
#define HXShow(str) [XWHUDManager showTipHUD:(str) isLineFeed:NO];
#define HXHiden(str) [XWHUDManager hide];
/**
 * 数据类型转 NSString
 */
#define intToNSString(x) [NSString stringWithFormat:@"%d", (x)]
#define floatToNSString(x) [NSString stringWithFormat:@"%f", (x)]
#define nsstringToFloat(x) [[NSString stringWithFormat:@"%@",x] floatValue]

#define doubleToNSString(x) [NSString stringWithFormat:@"%.3f", (x)]
#define CGFloatToNSString(x) [NSString stringWithFormat:@"%f", (x)]
#define NSUIntegerToNSString(x) [NSString stringWithFormat:@"%lu", (long)(x)]
#define NSIntegerToNSString(x) [NSString stringWithFormat:@"%ld", (long)(x)]
#define kGetString(NSNumber)  [NSString stringWithFormat:@"%@",NSNumber]
#define kGetNSInteger(NSInteger) [NSString stringWithFormat:@"%ld",NSInteger]
#define kGet2fDouble(Double) [NSString stringWithFormat:@"%.3f",Double]

//单例化一个类
#define SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

#endif /* define_h */
