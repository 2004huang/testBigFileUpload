//
//  SIMNewDepartMent.h
//  Kaihuibao
//
//  Created by mac126 on 2018/9/21.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIMNewDepartMent : NSObject
@property (nonatomic, strong) NSNumber *did;
@property (nonatomic, strong) NSNumber *pid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, strong) NSNumber *company_id;
@property (nonatomic, strong) NSNumber *userCount;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
