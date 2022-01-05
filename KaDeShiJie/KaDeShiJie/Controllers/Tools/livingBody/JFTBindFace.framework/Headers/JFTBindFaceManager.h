//
//  JFTBindFaceManager.h
//  JFTBindFace
//
//  Created by LuKane on 2020/9/14.
//  Copyright © 2020 LuKane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JFTBindFaceManagerDelegate <NSObject>

@optional
/// face auth success callback
/// @param token current token --> user to auth
- (void)bindFaceMgrDidFinishWithToken:(NSString *)token;

@optional
/// face auth failure callback
/// @param errCode error code
/// @param sequenceId sequence No
- (void)bindFaceMgrDidFinishWithError:(NSString *)errCode sequence_id:(NSString *)sequenceId;

@optional
/// call back
/// @param index index 0: unknow  1:success  2:failure
- (void)bindFaceSDKControllerWillGoBack:(NSInteger)index;

@end


@interface JFTBindFaceManager : NSObject

/// delegate
@property (nonatomic,weak  ) id<JFTBindFaceManagerDelegate> delegate;

/****************************** == only face Auth ↓ == ********************************/
/// start face auth
/// @param vc current vc
- (void)bindFaceAuthPresentController:(UIViewController *)vc;
/****************************** == only face Auth ↑ == ********************************/


/****************************** == union web content + face auth ↓ == ********************************/
/// url  -> show union content
@property (nonatomic,copy  ) NSString *url;

/// function 1: push vc with navigationController
/// @param navigationVc navigationVc
- (void)bindFaceSDKPushControllerWithNavigationVc:(UINavigationController * _Nullable)navigationVc;

/// function 2: present vc with target vc
/// @param vc vc
/// @param navigationVc navigationVc
- (void)bindFaceSDKPresentController:(UIViewController * _Nullable)vc navigationVc:(UINavigationController * _Nullable)navigationVc;

/****************************** == union web content + face auth ↑ == ********************************/

@end

NS_ASSUME_NONNULL_END
