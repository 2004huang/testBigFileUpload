//
//  SIMNowServiceModel.m
//  Kaihuibao
//
//  Created by mac126 on 2019/9/19.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMNowServiceModel.h"

@implementation SIMNowServiceModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"pid"];
    }
    //    NSLog(@"%@",key);
}
@end
