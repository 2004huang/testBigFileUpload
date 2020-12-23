//
//  SIMConfConfig.m
//  Kaihuibao
//
//  Created by mac126 on 2019/5/21.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMConfConfig.h"

@implementation SIMConfConfig
-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
- (void)setConfMode:(NSString *)confMode {
    _confMode = confMode;
//    会议模式（freeCamera：自由视角，mainBroadcast：与主持人广播视频一致，mainCamera：与主持人视角一致,intercom:对讲模式）
    if ([confMode isEqualToString:@"freeCamera"]) {
        self.confSchema = CLConfSchemaFRE;
    }else if ([confMode isEqualToString:@"mainBroadcast"]) {
        self.confSchema = CLConfSchemaSWHB;
    }else if ([confMode isEqualToString:@"mainCamera"]) {
        self.confSchema = CLConfSchemaSWH;
    }else if ([confMode isEqualToString:@"intercom"]) {
        self.confSchema = CLConfSchemaIntercom;
    }else if ([confMode isEqualToString:@"EHSfieldOperation"]){
        self.confSchema = CLConfSchemaEHS;
    }else if ([confMode isEqualToString:@"voiceSeminar"]){
        self.confSchema = CLConfSchemaTLP;
    }else {
        self.confSchema = CLConfSchemaFRE;
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{    
    if ([key isEqualToString:@"name"]) {
        [self setValue:value forKey:@"title"];
    }
    if ([key isEqualToString:@"userId"]) {
        [self setValue:value forKey:@"creator_id"];
    }
    if ([key isEqualToString:@"stopTime"]) {
        [self setValue:value forKey:@"endTime"];
    }
    if ([key isEqualToString:@"address"]) {
        [self setValue:value forKey:@"conf_URL"];
    }
    if ([key isEqualToString:@"neednormalPassword"]) {
        [self setValue:value forKey:@"isNeedConfPassword"];
    }
    if ([key isEqualToString:@"lock"]) {
        [self setValue:value forKey:@"isLock"];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%ld %@ %@ %@ %@ %@ %d %d %d  ",self.confSchema,self.title,self.creator_id,self.conf_id,self.startTime,self.conf_URL,self.isNeedConfPassword,self.isNeedOpenVideo];
}
@end
