//
//  MCBrandInfo.m
//  MCOEM
//
//  Created by wza on 2020/3/4.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCBrandConfiguration.h"



@implementation MCBrandConfiguration

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static MCBrandConfiguration *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
        
        //初始化
        instance.tab_iscenter = NO;
        instance.tab_selected_index = 0;
        
        instance.is_dairen_buy = NO;
        instance.is_bank_card_ocr = NO;
        instance.is_location_banner = NO;
        instance.is_guide_page = YES;
        instance.is_notify_sound = NO;
        instance.is_share_conin = NO;
        instance.color_main = [UIColor qmui_randomColor];
        instance.safe_title = @"账户安全";
        instance.api_version = @"v1.0";
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (NSString *)brand_company {
    if (!_brand_company) {
        return _brand_name;
    }
    return _brand_company;
}
- (void)registerURLPattern:(NSString *)url toObjectHandler:(MGJRouterObjectHandler)handler {
    [MGJRouter registerURLPattern:url toObjectHandler:handler];
}

+ (void)load {
    
    #pragma mark - 通知
    [MGJRouter registerURLPattern:rt_notice_list toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCMessageController new];
    }];
    
    #pragma mark - tabbar
    [MGJRouter registerURLPattern:rt_tabbar_list toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCTabBarViewController new];
    }];
    
    #pragma mark - 新闻分类
    [MGJRouter registerURLPattern:rt_news_list toObjectHandler:^id(NSDictionary *routerParameters) {
        NSDictionary *info = routerParameters[MGJRouterParameterUserInfo];
        NSString *classification = info[@"classification"];
        return [[MCNewsListController alloc] initWithClassification:classification?:@"信用秘籍"];
    }];
 
    
    
 
    [MGJRouter registerURLPattern:rt_share_article toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCArticlesController new];
    }];
    
    

    
    #pragma mark - 用户
    [MGJRouter registerURLPattern:rt_user_info toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCUserInfoViewController new];
    }];

   
    #pragma mark - 银行卡管理
    [MGJRouter registerURLPattern:rt_card_list toObjectHandler:^id(NSDictionary *routerParameters) {
        return [MCCardManagerController new];
    }];
    [MGJRouter registerURLPattern:rt_card_edit toObjectHandler:^id(NSDictionary *routerParameters) {
        NSDictionary *info = [routerParameters objectForKey:MGJRouterParameterUserInfo];
        MCBankCardType type = [[info objectForKey:@"type"] intValue];
        MCBankCardModel *model = [info objectForKey:@"model"];
        BOOL login = [[info objectForKey:@"isLogin"] boolValue];
        MCEditBankCardController *vc = [[MCEditBankCardController alloc] initWithType:type cardModel:model];
        vc.loginVC = login;
        vc.whereCome = [info objectForKey:@"whereCome"];
        return vc;
    }];
    
    #pragma mark - 设置
    [MGJRouter registerURLPattern:rt_setting_list toObjectHandler:^id(NSDictionary *routerParameters) {
        MCSettingViewController *vc = [[MCSettingViewController alloc] initWithSettingItems:@[MCSettingItemVersionCheck,MCSettingItemClearCache,MCSettingItemCountSafe,MCSettingItemAboutUs]];
        return vc;
    }];



    
    #pragma mark - webVc
    [MGJRouter registerURLPattern:rt_web_controller toObjectHandler:^id(NSDictionary *routerParameters) {
        NSDictionary *info = [routerParameters objectForKey:MGJRouterParameterUserInfo];
        NSString *urlString = [info objectForKey:@"url"];
        NSString *title = [info objectForKey:@"title"];
        NSString *classification = [info objectForKey:@"classification"];
        MCWebViewController *web = [[MCWebViewController alloc] init];
        web.urlString = urlString;
        if (title) {
            web.title = title;
        }
        if (classification) {        
            web.classifty = classification;
        }
        return web;
    }];
    
    #pragma mark - 鉴权和收款确认
    [MGJRouter registerURLPattern:rt_card_add toObjectHandler:^id(NSDictionary *routerParameters) {
        NSDictionary *info = routerParameters[MGJRouterParameterUserInfo];
        MCBankCardModel * cardModel = info[@"param"];
        return [[KDPayGatherViewController alloc] initWithClassification:cardModel];
    }];

    
    
 
    #pragma mark - 重置忘记密码
    [MGJRouter registerURLPattern:rt_user_restPwd toObjectHandler:^id(NSDictionary *routerParameters) {
        return [KDForgetPwdViewController new];
    }];
    


    
}

- (NSString *)pureHost {
    NSString *h = @"";
    //  截取baseUrl中 :// 到 / 中间的内容
    if ([SharedDefaults.host hasPrefix:@"https://"]) {
        if ([SharedDefaults.host hasSuffix:@"/"]) {
            h = [SharedDefaults.host substringWithRange:NSMakeRange(8, SharedDefaults.host.length - 9)];
        } else {
            h = [SharedDefaults.host substringWithRange:NSMakeRange(8, SharedDefaults.host.length - 8)];
        }
    }
    if ([SharedDefaults.host hasPrefix:@"http://"]) {
        if ([SharedDefaults.host hasSuffix:@"/"]) {
            h = [SharedDefaults.host substringWithRange:NSMakeRange(7, SharedDefaults.host.length - 8)];
        } else {
            h = [SharedDefaults.host substringWithRange:NSMakeRange(7, SharedDefaults.host.length - 7)];
        }
    }
    return h;
}


@end
