//
//  SIMFootImageModel.m
//  Kaihuibao
//
//  Created by mac126 on 2020/6/12.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "SIMFootImageModel.h"

@implementation SIMFootImageModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        [self setValue:value forKey:@"descripStr"];
    }
}


@end
