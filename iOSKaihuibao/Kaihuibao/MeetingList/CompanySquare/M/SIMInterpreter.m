//
//  SIMInterpreter.m
//  Kaihuibao
//
//  Created by mac126 on 2020/6/21.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "SIMInterpreter.h"

@implementation SIMInterpreter
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //    NSLog(@"%@",key);
}
@end
