//
//  MLEngine_Base.m
//  MeeLike
//
//  Created by mac126 on 2020/9/16.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "MLEngine_Base.h"


@implementation MLEngine_Base

+ (id)objectWithDictionary:(NSDictionary *)dic {
    if (!dic||![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return nil;
}

- (void)initializeWithDic:(NSDictionary*)dic {
    
}

@end
