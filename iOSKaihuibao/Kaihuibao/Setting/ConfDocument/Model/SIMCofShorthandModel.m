//
//  SIMCofShorthandModel.m
//  Kaihuibao
//
//  Created by mac126 on 2019/12/3.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMCofShorthandModel.h"

@implementation SIMCofShorthandModel
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
