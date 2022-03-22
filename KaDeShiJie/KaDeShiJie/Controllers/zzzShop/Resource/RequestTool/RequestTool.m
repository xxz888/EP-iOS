//
//  RequestTool.m
//  LeakDemo
//
//  Created by Insect on 2016/12/26.
//  Copyright © 2016年 Insect. All rights reserved.
//

#import "RequestTool.h"
#import "NetworkUnit.h"
#import "EGOCache.h"

@implementation RequestTool

static AFHTTPSessionManager *_manager;

+ (AFHTTPSessionManager *)tool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _manager = [AFHTTPSessionManager manager];
    });
    return _manager;
}

+ (AFHTTPSessionManager *)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript" , @"text/plain" ,@"text/html",@"application/xml",@"image/jpeg",nil];
//        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.timeoutInterval = 5.0f;
        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//         [_manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //***************** HTTPS 设置 *****************************//
        // 设置非校验证书模式
        _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        // 客户端是否信任非法证书
        _manager.securityPolicy.allowInvalidCertificates = YES;
        // 是否在证书域字段中验证域名
        _manager.securityPolicy.validatesDomainName = NO;
    });
    return _manager;
}

+ (void)requestWithType:(requestType)type
                    URL:(NSString *)URL
              parameter:(NSDictionary *)parameter
        successComplete:(void(^)(id responseObject))success
        failureComplete:(void(^)(NSError *error))failure {
    
    _manager = [self sharedManager];

}

+ (void)requestWithType:(requestType )type
                    URL:(NSString *)URL
              parameter:(NSDictionary *)parameter
               progress:(void(^)(NSProgress *progess))progess
        successComplete:(void(^)(id responseObject))success
        failureComplete:(void(^)(NSError *error))failure {
    
    _manager = [self sharedManager];

}

+ (void)requestCacheWithType:(requestType)type
                         URL:(NSString *)URL
                   parameter:(NSDictionary *)parameter
             successComplete:(void(^)(id responseObject))success
             failureComplete:(void(^)(NSError *error))failure {
    
    _manager = [self sharedManager];
    

}

+ (void)requestCacheWithType:(requestType)type
                         URL:(NSString *)URL
                   parameter:(NSDictionary *)parameter
                    progress:(void(^)(NSProgress *progess))progess
             successComplete:(void(^)(id responseObject))success
             failureComplete:(void(^)(NSError *error))failure {
    
    _manager = [self sharedManager];
    
   
}

+ (void)cancelAllRequest {
    
    [[self sharedManager].tasks makeObjectsPerformSelector:@selector(cancel)];
}



@end
