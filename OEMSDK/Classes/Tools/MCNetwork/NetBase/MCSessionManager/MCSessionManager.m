//
//  MCSessionManager.m
//  MCOEM
//
//  Created by wza on 2020/3/16.
//  Copyright © 2020 MingChe. All rights reserved.
//
#import "MCSessionManager.h"
#import "MCRequestMannager.h"
#import "KDCommonAlert.h"
#import "MCSessionManagerMessageModel.h"
#import "MCApp.h"
static MCSessionManager *_singleManager = nil;
@interface MCSessionManager()
//  记录一个controller的sessionManager创建的网络任务
@property (nonatomic, strong) NSMutableArray <MCSessionManagerMessageModel *>* tempActions;
// 调用过reload方法证明任务数组已经加好了
@property (nonatomic, assign) BOOL isReloaded;
@end
@implementation MCSessionManager
- (NSURLSessionDataTask *)mc_GET:(NSString *)shortURLString parameters:(id)parameters ok:(MCSMNormalHandler)okResp other:(MCSMNormalHandler)otherResp failure:(MCSMErrorHandler)failure {
    if (TOKEN) {    //每次都添加为了及时变化
        [self.requestSerializer setValue:TOKEN forHTTPHeaderField:@"Authorization"];
    }
    __weak typeof(self) weakSelf = self;
    [MCLoading show];
    NSString *full = [self getFullUrlWithShort:shortURLString];
    NSLog(@"\n\n-------------【请求接口】-------------\n%@\n-------------请求参数-------------\n%@\n-------------请求Token-------------\n%@\n",full, parameters,TOKEN);
    NSURLSessionDataTask *task = [self GET:full parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"\n------------【返回结果】--------------%@\n",responseObject);
        [MCLoading hidden];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (responseObject[@"message"]) {
                [MCToast showMessage:responseObject[@"messege"]];
            }else{
                okResp(responseObject);
            }
        }else{
            okResp(responseObject);
        }
    
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MCLoading hidden];
        [self handleHTTPError:error failureHandler:failure];
        if (self.delegate) {
            [self.delegate mc_session:self.session task:task didReceiveResponse:error];
        }
    }];
    
    return task;
}
- (nullable NSURLSessionDataTask *)mc_Post_QingQiuTi:(NSString *)shortURLString
  parameters:(nullable id)parameters
          ok:(nullable MCSMNormalHandler)okResp
       other:(nullable MCSMNormalHandler)otherResp
     failure:(nullable MCSMErrorHandler)failure {
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest * request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[self getFullUrlWithShort:shortURLString] parameters:parameters error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:TOKEN forHTTPHeaderField:@"Authorization"];
    [request setValue:SharedDefaults.deviceid forHTTPHeaderField:@"deviceId"];
    [request setValue:@"ios" forHTTPHeaderField:@"platform"];
    [request setValue:SharedAppInfo.version forHTTPHeaderField:@"version"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    NSLog(@"%@",TOKEN);
 
    if ([shortURLString isEqualToString:@"/api/v1/player/facePay/confirm"]) {
        
    }else{
        [MCLoading show];
    }
    NSString * full= [self getFullUrlWithShort:shortURLString];
    
    NSLog(@"\n\n-------------【请求接口】-------------\n%@\n-------------【请求参数】-------------\n%@\n",full, parameters);
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"\n------------【返回结果】--------------%@\n",responseObject);
        if ([shortURLString isEqualToString:@"/api/v1/player/facePay/confirm"]) {
            
        }else{
            [MCLoading hidden];
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        NSInteger code = [httpResponse statusCode];
        if (!error) {
     
            if (code == 200) {
                if (responseObject[@"message"]) {
                    [MCToast showMessage:responseObject[@"messege"]];
                }else{
                    okResp(responseObject);
                }
            }else if (code == 204){
                [MCToast showMessage:@"操作成功"];
                okResp(@{});
            }else if (code == 401){
                [MCToast showMessage:@"请重新登陆"];
                [MCApp userLogout];
            }else if (code == 404){
                [MCToast showMessage:@"请重新登陆"];
                [MCApp userLogout];
            }else{
                [MCToast showMessage:responseObject[@"messege"]];
            }
        } else {
            if (code == 401){
                [MCApp userLogout];
            }else if (code == 404){
                [MCApp userLogout];
            }else if (code == 400){
                [MCToast showMessage:responseObject[@"message"]];
            }else{
                [MCToast showMessage:responseObject[@"message"]];
            }
//            [MCToast showMessage:responseObject[@"message"]];
            NSLog(@"请求失败error=%@", error);
        }
    }];
    [task resume];
    return task;
}
- (nullable NSURLSessionDataTask *)mc_put:(NSString *)shortURLString
  parameters:(nullable id)parameters
          ok:(nullable MCSMNormalHandler)okResp
       other:(nullable MCSMNormalHandler)otherResp
     failure:(nullable MCSMErrorHandler)failure {
//
    if (TOKEN) {    //每次都添加为了及时变化
        [self.requestSerializer setValue:TOKEN forHTTPHeaderField:@"Authorization"];
    }
//
    
  
    
    // 设置HTTPBody
    
//    __weak typeof(self) weakSelf = self;
//    [MCLoading show];
//    NSString *full = [self getFullUrlWithShort:shortURLString];
//    if ([full containsString:@"player/user/modify/pwd"]) {
//        [self.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error){
//            return [self convertToJsonData:parameters];
//         }];
//
//    }
//    NSLog(@"\n\n-------------【请求接口】-------------\n%@\n-------------请求参数-------------\n%@\n-------------请求Token-------------\n%@\n-------------请求DeviceId-------------\n%@\n",full, parameters,TOKEN, SharedDefaults.deviceid);
//
//    NSURLSessionDataTask *task = [self PUT:full parameters:nil headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"\n------------【返回结果】--------------%@\n",responseObject);
//        [MCLoading hidden];
//        okResp(@{});
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [MCLoading hidden];
//        [self handleHTTPError:error failureHandler:failure];
//        if (self.delegate) {
//            [self.delegate mc_session:self.session task:task didReceiveResponse:error];
//        }
//    }];
//
//    return task;
//
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest * request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:[self getFullUrlWithShort:shortURLString] parameters:parameters error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:TOKEN forHTTPHeaderField:@"Authorization"];
    [request setValue:SharedDefaults.deviceid forHTTPHeaderField:@"deviceId"];
    [request setValue:@"ios" forHTTPHeaderField:@"platform"];
    [request setValue:SharedAppInfo.version forHTTPHeaderField:@"version"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSData *data = [[self convertToJsonData:parameters] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSLog(@"%@",TOKEN);
 
    [MCLoading show];
    NSString * full= [self getFullUrlWithShort:shortURLString];
    
    NSLog(@"\n\n-------------【请求接口】-------------\n%@\n-------------【请求参数】-------------\n%@\n",full, parameters);
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"\n------------【返回结果】--------------%@\n",responseObject);
        [MCLoading hidden];
        if (!error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            NSInteger code = [httpResponse statusCode];
            if (code == 200) {
                if (responseObject[@"message"]) {
                    [MCToast showMessage:responseObject[@"messege"]];
                }else{
                    okResp(responseObject);
                }
            }else if (code == 204){
                [MCToast showMessage:@"操作成功"];
                okResp(@{});
            }else{
                [MCToast showMessage:responseObject[@"messege"]];
            }
        } else {
            
            [MCToast showMessage:responseObject[@"message"]];
            NSLog(@"请求失败error=%@", error);
        }
    }];
    [task resume];
    return task;
}
- (nullable NSURLSessionDataTask *)mc_UPLOAD:(NSString *)shortURLString
  parameters:(nullable id)parameters
      images:(nullable NSArray<UIImage*>*)images
remoteFields:(nullable NSArray<NSString *>*)fields
  imageNames:(nullable NSArray<NSString *>*)names
  imageScale:(CGFloat)scale
   imageType:(nullable NSString*)type
          ok:(nullable MCSMNormalHandler)okResp
       other:(nullable MCSMNormalHandler)otherResp
     failure:(nullable MCSMErrorHandler)failure {
    if (TOKEN) {    //每次都添加为了及时变化
        [self.requestSerializer setValue:TOKEN forHTTPHeaderField:@"Authorization"];
    }
    if (SharedDefaults.deviceid.length != 0) {
        [self.requestSerializer setValue:SharedDefaults.deviceid forHTTPHeaderField:@"deviceId"];
    }
    [self.requestSerializer setValue:@"ios" forHTTPHeaderField:@"platform"];
    [self.requestSerializer setValue:SharedAppInfo.version forHTTPHeaderField:@"version"];
    BOOL isSharedSession = (self == [MCSessionManager shareManager]);
    if (isSharedSession) {
        [MCLoading show];
    }
    NSString *full = [self getFullUrlWithShort:shortURLString];
        
    NSLog(@"\n\n-------------【请求接口】-------------\n%@\n-------------【请求参数】-------------\n%@\n",full, parameters);
    
    NSURLSessionDataTask *task = [self POST:full parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < images.count; i++) {
            // 图片经过等比压缩后得到的二进制文件
            NSData *imageData = UIImageJPEGRepresentation(images[i], scale ?: 1.f);
            NSString *field = fields ? fields[i] : [NSString stringWithFormat:@"ios%d",i];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *defaultImgName = [NSString stringWithFormat:@"%@%d.%@",str,i,type?:@"jpg"];
            NSString *fielName =  defaultImgName;
            
            [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fielName
                                mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MCLoading hidden];
        okResp(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MCLoading hidden];
        [self handleHTTPError:error failureHandler:failure];
        if (self.delegate) {
            [self.delegate mc_session:self.session task:task didReceiveResponse:error];
        }
    }];
    return task;
}
/// 去掉请求地址多余的斜杠
/// @param url url
- (NSString*)removeExtraSlashOfUrl:(NSString*)url{
    if(!url || url.length == 0){
        return url;
    }
    NSString*pattern = @"(?<!(http:|https:))/+";
    NSRegularExpression*expression = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    return [expression stringByReplacingMatchesInString:url options:0 range:NSMakeRange(0, url.length) withTemplate:@"/"];
}
- (NSString *)getFullUrlWithShort:(NSString *)url {
    NSString *full = [NSString stringWithFormat:@"%@%@",api_host,url];
    return [self removeExtraSlashOfUrl:full];
}
- (NSString *)getZhengShiFullUrlWithShort:(NSString *)url {
    NSString *full = [NSString stringWithFormat:@"%@/%@/%@",@"https://api.flyaworld.com",MCModelStore.shared.brandConfiguration.api_version,url];
    return [self removeExtraSlashOfUrl:full];
}
- (void)popLoginIfNeeded:(MCNetResponse *)resp {
    MCNavigationController *vc = (MCNavigationController *)[MGJRouter objectForURL:rt_user_signupin];
    if ([UIApplication.sharedApplication.keyWindow.rootViewController isKindOfClass:[QMUIModalPresentationViewController class]]) {
        return;
    }
    
    if (![NSStringFromClass(MCLATESTCONTROLLER.class) isEqualToString:@"KDLoginViewController"]) {
        [MCApp userLogout];
        
//        kWeakSelf(self);
//        KDCommonAlert * commonAlert = [KDCommonAlert newFromNib];
//        [commonAlert initKDCommonAlertContent:resp[@"messege"]  isShowClose:YES];
//        commonAlert.middleActionBlock = ^{
//            [MCApp userLogout];
//        };
        
        
//        [MCAlertStore showWithTittle:@"提示" message:resp[@"messege"] buttonTitles:@[@"立即重登"] sureBlock:^{
//            [MCApp userLogout];
//        }];
    }
    
}
- (void)handleHTTPError:(NSError *)error failureHandler:(MCSMErrorHandler)failure {
    if (error.userInfo) {
        NSDictionary *UserInfo = error.userInfo;
        NSHTTPURLResponse * responses = UserInfo[@"com.alamofire.serialization.response.error.response"];
                NSInteger code = [responses statusCode];
        
        if (UserInfo[@"com.alamofire.serialization.response.error.data"]) {
            NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:UserInfo[@"com.alamofire.serialization.response.error.data"] options:NSJSONReadingMutableContainers error:nil];
            NSString *errorStr = errorDict[@"message"];
            [MCToast showMessage:errorStr];
            NSLog(@"%@",errorStr);
            if ([errorStr isEqualToString:@"无法获得当前登陆用户"] || code == 401) {
                [MCApp userLogout];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MCToast showMessage:@"请重新登录"];
                });
            }
        }
     
        
    }
}
- (void)handleOther:(MCNetResponse *)resp {
//    [MCToast showMessage:resp[@"messege"] ];
}
//链接转字典  （参数）
+(NSMutableDictionary *)dictionaryWithUrlString:(NSString *)urlStr{
    if (urlStr && urlStr.length && [urlStr rangeOfString:@"?"].length == 1) {
        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
        if (array && array.count == 2) {
            NSString *paramsStr = array[1];
            if (paramsStr.length) {
                NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
                NSArray *paramArray = [paramsStr componentsSeparatedByString:@"&"];
                for (NSString *param in paramArray) {
                    if (param && param.length) {
                        NSArray *parArr = [param componentsSeparatedByString:@"="];
                        if (parArr.count == 2) {
                            [paramsDict setObject:parArr[1] forKey:parArr[0]];
                        }
                    }
                }
                return paramsDict;
            }else{
                return nil;
            }
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}
#pragma mark - /*********************POST请求*******************/
/// POST请求
/// @param shortURLString shortURLString
/// @param parameters 参数
/// @param okResp "000000"结果
- (nullable NSURLSessionDataTask *)mc_POST:(NSString *)shortURLString
                                parameters:(nullable id)parameters
                                        ok:(nullable MCSMNormalHandler)okResp{
    return [self mc_POST:shortURLString parameters:parameters ok:okResp other:nil];
}
/// POST请求
/// @param shortURLString shortURLString
/// @param parameters 参数
/// @param okResp "000000"结果
/// @param otherResp 其他结果
- (nullable NSURLSessionDataTask *)mc_POST:(NSString *)shortURLString
                                parameters:(nullable id)parameters
                                        ok:(nullable MCSMNormalHandler)okResp
                                     other:(nullable MCSMNormalHandler)otherResp{
    return [self mc_POST:shortURLString parameters:parameters ok:okResp other:otherResp failure:nil];
}
/// POST请求
/// @param shortURLString shortURLString
/// @param parameters 参数
/// @param okResp "000000"结果
/// @param otherResp 其他结果
/// @param failure 请求失败
- (nullable NSURLSessionDataTask *)mc_POST:(NSString *)shortURLString
                                parameters:(nullable id)parameters
                                        ok:(nullable MCSMNormalHandler)okResp
                                     other:(nullable MCSMNormalHandler)otherResp
                                   failure:(nullable MCSMErrorHandler)failure{
    return  nil;
    if (TOKEN) {    //每次都添加为了及时变化
        [self.requestSerializer setValue:TOKEN forHTTPHeaderField:@"authToken"];
    }
//    if (SharedDefaults.deviceid.length != 0) {
//        [self.requestSerializer setValue:SharedDefaults.deviceid forHTTPHeaderField:@"deviceId"];
//    }
//    [self.requestSerializer setValue:@"ios" forHTTPHeaderField:@"platform"];
//    [self.requestSerializer setValue:SharedAppInfo.version forHTTPHeaderField:@"version"];
    //如果url不包含1.0再拼接请求字符串,这个是区别通道用的，因为后台返回就返回的完整url
    NSString * full = [self getFullUrlWithShort:shortURLString];
    
   
    if (!self.isReloaded) {
        MCSessionManagerMessageModel *msgModel = [[MCSessionManagerMessageModel alloc] initWithTarget:self sel:_cmd shortURLString:shortURLString parameters:parameters okResp:okResp otherResp:otherResp failure:failure];
        
        [self.tempActions addObject:msgModel];
    }
    
    BOOL isSharedSession = (self == [MCSessionManager shareManager]);
    if (isSharedSession) {
        [MCLoading show];
    }
    NSLog(@"\n\n-------------【请求接口】-------------\n%@\n-------------【请求参数】-------------\n%@\n",full, parameters);
    NSURLSessionDataTask *task = [self POST:full parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"\n------------【返回结果】--------------%@\n",responseObject);
        
        //如果是收款轮询的查询，查询不成功就不要隐藏菊花
        //返回数据不一样的数据，需要在这里重新拼接数组,计算手续费
        if ([shortURLString containsString:@"/creditcardmanager/app/empty/card/calculate/reservedamount"]) {
                responseObject = @{@"resp_code":responseObject[@"resp_code"],
                                   @"result":responseObject,
                                   @"resp_message":responseObject[@"resp_message"]
                };
        }
        
        [MCLoading hidden];
        
        MCNetResponse *resp = [MCNetResponse mj_objectWithKeyValues:responseObject];
        if (responseObject[@"verify"]) {
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"verify"] forKey:@"verify"];
        }
//        if ([resp[@"code"] isEqualToString:@"000000"]) {  // ok
//            if (okResp) {
//                okResp(resp);
//            }
//
//        }else {    // other
//            if ([resp[@"code"] isEqualToString:@"401"] || [resp[@"code"] isEqualToString:@"000005"]) {
//                [self popLoginIfNeeded:resp];
//                //需要鉴权绑卡
//            }else {
//                if (otherResp) {
//                    otherResp(resp);
//                } else {
//                    [self handleOther:resp];
//                }
//            }
//        }
        if (self.delegate) {
            [self.delegate mc_session:self.session task:task didReceiveResponse:resp];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //MCLog(@"%@",error);
        if (isSharedSession) {
            [MCLoading hidden];
        }
        [self handleHTTPError:error failureHandler:failure];
        if (self.delegate) {
            [self.delegate mc_session:self.session task:task didReceiveResponse:error];
        }
    }];
    
    return task;
}
+ (instancetype)manager {
    MCSessionManager *m = [super manager];
    //自定义配置
    m.requestSerializer.timeoutInterval = 30.f;
    m.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/htLY", @"text/json", @"text/plain", @"text/javascript", @"text/xLY", @"image/*" ,nil];
    [m.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    return m;
}
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _singleManager = [MCSessionManager manager];
    });
    return _singleManager;
}
- (NSMutableArray<MCSessionManagerMessageModel *> *)tempActions {
    if (!_tempActions) {
        _tempActions = [NSMutableArray new];
    }
    return _tempActions;
}
- (void)mc_reloadTasks {
    self.isReloaded = YES;
    for (MCSessionManagerMessageModel *model in self.tempActions) {
        [model msgSend];
    }
}
#pragma mark - /*********************GET请求*******************/
- (NSURLSessionDataTask *)mc_GET:(NSString *)shortURLString parameters:(id)parameters ok:(MCSMNormalHandler)okResp {
    return [self mc_GET:shortURLString parameters:parameters ok:okResp other:nil];
}
- (NSURLSessionDataTask *)mc_GET:(NSString *)shortURLString parameters:(id)parameters ok:(MCSMNormalHandler)okResp other:(MCSMNormalHandler)otherResp {
    return [self mc_GET:shortURLString parameters:parameters ok:okResp other:otherResp failure:nil];
}
-(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}
@end
