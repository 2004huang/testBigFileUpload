//
//  SIMMyServiceVideo.m
//  Kaihuibao
//
//  Created by mac126 on 2018/11/5.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMMyServiceVideo.h"

@implementation SIMMyServiceVideo

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
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
