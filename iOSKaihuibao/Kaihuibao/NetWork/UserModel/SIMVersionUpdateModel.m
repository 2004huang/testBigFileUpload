//
//  SIMVersionUpdateModel.m
//  Kaihuibao
//
//  Created by mac126 on 2019/7/17.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMVersionUpdateModel.h"

@implementation SIMVersionUpdateModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
