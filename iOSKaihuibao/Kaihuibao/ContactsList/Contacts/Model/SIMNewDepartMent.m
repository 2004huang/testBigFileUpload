//
//  SIMNewDepartMent.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/21.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMNewDepartMent.h"

@implementation SIMNewDepartMent
-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"did"];
    }
}
@end
