//
//  SIMMessNotiModel.m
//  Kaihuibao
//
//  Created by mac126 on 2019/10/29.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMMessNotiModel.h"

@implementation SIMMessNotiModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        [self setValue:value forKey:@"descriptionStr"];
    }
}
@end

@implementation SIMMessNotiDetailModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        [self setValue:value forKey:@"descriptionStr"];
    }
    if ([key isEqualToString:@"space_id"]) {
        [self setValue:value forKey:@"message_id"];
    }
}
@end
