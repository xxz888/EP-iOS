//
//  MCMessageModel.h
//  MCOEM
//
//  Created by wza on 2020/4/30.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCMessageModel : NSObject


@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *btype;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *_id;

@property (nonatomic, copy) NSString *brandId;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *createdTime;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) NSString *noticeType;


//status = Normal,
//id = 11,
//title = 激发开始发售,
//content = 发大水发的说法,
//noticeType = Normal,
//createdTime = 2021-12-13T20:11:20
@end

NS_ASSUME_NONNULL_END
