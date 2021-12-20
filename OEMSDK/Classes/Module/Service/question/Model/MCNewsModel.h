//
//  MCNewsModel.h
//  MCOEM
//
//  Created by SS001 on 2020/4/8.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCNewsModel : NSObject
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *lowSourceId;
@property (nonatomic, copy) NSString *spare2;
@property (nonatomic, copy) NSString *lowSource;
@property (nonatomic, copy) NSString *spare1;

@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *previewNumber;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *publisher;
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *brandId;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *onOff;
@property (nonatomic, copy) NSString *classifiCation;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *describe;

@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *background;
@property (nonatomic, copy) NSString *link;

@end

NS_ASSUME_NONNULL_END
