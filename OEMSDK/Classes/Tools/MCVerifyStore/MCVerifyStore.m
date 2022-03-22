//
//  MCVerifyStore.m
//  MCOEM
//
//  Created by wza on 2020/5/8.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "MCVerifyStore.h"
#import "MCUpdateAlertView.h"
#import "KDCommonAlert.h"
@implementation MCVerifyStore

+ (void)verifyRealName:(void (^)(MCUserInfo * _Nonnull))handler {
    [MCModelStore.shared reloadUserInfo:^(MCUserInfo * _Nonnull userInfo) {
     

    }];
}

+ (void)verifyVersionShowToast:(BOOL)show {
    
    [MCModelStore.shared reloadBrandInfo:^(MCBrandInfo * _Nonnull brandInfo) {
        NSString *remoteVersion = brandInfo.iosVersion;
        NSString *localVersion = SharedAppInfo.version;
        NSComparisonResult result = [remoteVersion compare:localVersion options:NSNumericSearch];
        if (result == NSOrderedDescending) {
            MCUpdateAlertView *updateView = [[[NSBundle OEMSDKBundle] loadNibNamed:@"MCUpdateAlertView" owner:nil options:nil] firstObject];
            NSString * str = [brandInfo.iosContent stringByReplacingOccurrencesOfString:@"，" withString:@"\n"];
            [updateView showWithVersion:remoteVersion content:str downloadUrl:brandInfo.iosDownload isForce:YES];
        } else {
            if (show) {
                [MCToast showMessage:@"当前已是最新版本"];
            }
        }
    }];
}

+ (NSString *)verifyURL:(NSString *)url {
    
    BeginIgnoreClangWarning(-Wdeprecated-declarations)
    NSString *encodedUrlPath = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)url,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
    EndIgnoreClangWarning
    
    return encodedUrlPath;
}
@end
