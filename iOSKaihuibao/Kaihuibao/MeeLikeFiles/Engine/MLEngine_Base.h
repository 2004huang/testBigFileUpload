//
//  MLEngine_Base.h
//  MeeLike
//
//  Created by mac126 on 2020/9/16.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNetworking.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^EngineCallback)(BOOL succeed, NSString * __nullable info);
typedef void(^EngineCallbackWithInfo)(BOOL succeed, NSString * __nullable info, id __nullable responseData);

@interface MLEngine_Base : NSObject
+ (id)objectWithDictionary:(NSDictionary *)dict;
- (void)initializeWithDic:(NSDictionary*)dict;

@end

NS_ASSUME_NONNULL_END

