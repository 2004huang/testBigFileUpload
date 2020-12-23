//
//  SIMDepartment.h
//  Kaihuibao
//
//  Created by 王小琪 on 2017/8/3.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIMDepartment : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *did;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSArray *members;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface SIMDepartment_member : NSObject
/** 名字*/
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *face;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *premium;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *role_id;
@property (nonatomic, copy) NSString *role_name;
@property (nonatomic, copy) NSString *uid;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
