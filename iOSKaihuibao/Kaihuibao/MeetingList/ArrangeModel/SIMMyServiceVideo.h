//
//  SIMMyServiceVideo.h
//  Kaihuibao
//
//  Created by mac126 on 2018/11/5.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMMyServiceVideo : NSObject
// 个人会议编辑
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *normal_password;
@property (nonatomic, strong) NSString *main_password;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
