//
//  MCBankStore.m
//  Project
//
//  Created by Li Ping on 2019/6/24.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCBankStore.h"

@implementation MCBankStore

+ (MCBankCardInfo *)getBankCellInfoWithName:(NSString *)name {

    if (name) {
        name = [name replaceAll:@"中国" target:@""];
        name = [name replaceAll:@"银行" target:@""];

        NSArray *localA = [MCBankStore getLocalJson:@"card_bankName"];
        NSString * localName = @"BANK_default";
        UIImage *logo = [UIImage mc_imageNamed:localName];
        UIColor * backGround = MAINCOLOR; //  默认主题色
        BOOL ishave = NO;
        for (NSDictionary *bankDic in localA) {// 添加本地logo
            
            NSString *ss = bankDic[@"bank_name"];
    //        BANK_HXBANK
            if ([ss containsString:name] || [name containsString:ss] ) {
                localName = [NSString stringWithFormat:@"BANK_%@", bankDic[@"bank_acronym"]];
                logo = [UIImage mc_imageNamed:localName];
                backGround = [MCBankStore getBankThemeColorWithLogo:logo];
                ishave = YES;
            }
        }
        if (!ishave) {
            localName = [NSString stringWithFormat:@"BANK_%@", @"BANK_default"];
               logo = [UIImage mc_imageNamed:localName];
               backGround = [MCBankStore getBankThemeColorWithLogo:logo];
        }
        return [[MCBankCardInfo alloc] initWithLogo:logo cardCellBackgroundColor:backGround];
    }else{
        NSString *  localName = [NSString stringWithFormat:@"BANK_%@", @"BANK_default"];
        NSString *   logo = [UIImage mc_imageNamed:localName];
        NSString *    backGround = [MCBankStore getBankThemeColorWithLogo:logo];
        return [[MCBankCardInfo alloc] initWithLogo:logo cardCellBackgroundColor:backGround];

    }
    

}
static inline int min(int a, int b) {
    return a < b ? a : b;
}
 
+(float)likePercentByCompareOriginText:(NSString *)originText targetText:(NSString *)targetText{
    
    //length
    int n = (int)originText.length;
    int m = (int)targetText.length;
    if (n == 0 || m == 0) {
        return 0.0;
    }
    
    //Construct a matrix, need C99 support
    int N = n+1;
    int **matrix;
    matrix = (int **)malloc(sizeof(int *)*N);
    
    int M = m+1;
    for (int i = 0; i < N; i++) {
        matrix[i] = (int *)malloc(sizeof(int)*M);
    }
    
    for (int i = 0; i<N; i++) {
        for (int j=0; j<M; j++) {
            matrix[i][j]=0;
        }
    }
    
    for(int i=1; i<=n; i++) {
        matrix[i][0]=i;
    }
    for(int i=1; i<=m; i++) {
        matrix[0][i]=i;
    }
    for(int i=1;i<=n;i++)
    {
        unichar si = [originText characterAtIndex:i-1];
        for(int j=1;j<=m;j++)
        {
            unichar dj = [targetText characterAtIndex:j-1];
            int cost;
            if(si==dj){
                cost=0;
            }
            else{
                cost=1;
            }
            const int above = matrix[i-1][j]+1;
            const int left = matrix[i][j-1]+1;
            const int diag = matrix[i-1][j-1]+cost;
            matrix[i][j] = min(above, min(left,diag));
        }
    }
    return 100.0 - 100.0*matrix[n][m]/MAX(m,n);
}
+ (NSArray *)getLocalJson:(NSString *)jsonName {
    
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle OEMSDKBundle] pathForResource:jsonName ofType:@"json"]];
    
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    
    NSMutableArray *newArray = [NSMutableArray array];
    
    for (NSDictionary *dict in dataArray) {
        
        [newArray addObject:dict];
    }
    return newArray;
}

+ (UIColor *)getBankThemeColorWithLogo:(UIImage *)logo {
    if (logo == nil) {
        return MAINCOLOR;
    }
    NSArray *colorSet  = [MCBankStore getThemeRGBAcolorArray:logo];
    int r = [colorSet[0] intValue];
    int g = [colorSet[1] intValue];
    int b = [colorSet[2] intValue];
    int a = [colorSet[3] intValue];
    if(r*0.299 + g*0.578 + b*0.114 >= 192){ //浅色则返回主题色
        return MAINCOLOR;
    }
    return [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a/255.0f)];
}

+ (NSArray *)getThemeRGBAcolorArray:(UIImage *)image {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(image.size.width / 2, image.size.height / 2);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width * 4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char *data = CGBitmapContextGetData(context);
    if (data == NULL) return nil;
    NSCountedSet *cls= [NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    
    for (int x = 0; x < thumbSize.width; x++) {
        
        for (int y = 0; y < thumbSize.height; y++) {
            
            int offset = 4 * (x * y);
            int red = data[offset];
            int green = data[offset + 1];
            int blue = data[offset + 2];
            int alpha =  data[offset + 3];
            if (alpha > 0) {//去除透明
                if (red == 255 && green == 255 && blue == 255) {//去除白色
                    
                }else{
                    
                    NSArray *clr = @[@(red), @(green), @(blue), @(alpha)];
                    [cls addObject:clr];
                }
            }
        }
    }
    CGContextRelease(context);
    
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *MaxColor = nil;
    NSUInteger MaxCount = 0;
    while ( (curColor = [enumerator nextObject]) != nil ) {
        
        NSUInteger tmpCount = [cls countForObject:curColor];
        if (tmpCount < MaxCount) continue;
        MaxCount = tmpCount;
        MaxColor = curColor;
    }
    return MaxColor;
}

@end


@implementation MCBankCardInfo

- (instancetype)initWithLogo:(UIImage *)logo cardCellBackgroundColor:(UIColor *)color {
    self = [super init];
    if (self) {
        self.logo = logo;
        self.cardCellBackgroundColor = color;
    }
    return self;
}

@end
