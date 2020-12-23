//
//  SIMPayHistoryModel.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/16.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMPayHistoryModel.h"

@implementation SIMPayHistoryModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"payid"];
    }
    //    NSLog(@"%@",key);
}
@end
