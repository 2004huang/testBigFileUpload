//
//  SIMUserContants.h
//  Kaihuibao
//
//  Created by 王小琪 on 2017/7/10.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIMUserContants : NSObject

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *premium;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSArray *group;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface SIMUserContants_group : NSObject
/** 名字*/
@property (nonatomic, copy) NSString *group;
@property (nonatomic, copy) NSString *rid;
@property (nonatomic, copy) NSString *role;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
