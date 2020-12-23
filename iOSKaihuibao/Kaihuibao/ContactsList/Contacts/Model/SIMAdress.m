//
//  SIMAdress.m
//  Kaihuibao
//
//  Created by mac126 on 2017/12/26.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMAdress.h"

@implementation SIMAdress
-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
