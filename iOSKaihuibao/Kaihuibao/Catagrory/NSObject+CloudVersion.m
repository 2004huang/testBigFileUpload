//
//  NSObject+CloudVersion.m
//  Kaihuibao
//
//  Created by mac126 on 2019/6/14.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "NSObject+CloudVersion.h"
#import <objc/runtime.h>

NSString * const RVNCloudVersionKey = @"com.oral.xferris.current.cloudVersion";

static SIMCloudVersion *kCloudVersion;
@implementation NSObject (CloudVersion)

+ (void)load {
    NSData *daa  = [[NSUserDefaults standardUserDefaults] objectForKey:RVNCloudVersionKey];
    NSString *strin = [[NSString alloc] initWithData:daa encoding:NSUTF8StringEncoding];
    NSData *datastr = [strin dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dd = [NSJSONSerialization JSONObjectWithData:datastr options:NSJSONReadingMutableLeaves error:nil];
    kCloudVersion = dd?[MTLJSONAdapter modelOfClass:[SIMCloudVersion class] fromJSONDictionary:dd error:nil]:nil;
}
- (void)setCloudVersion:(SIMCloudVersion *)cloudVersion {
    @synchronized (kCloudVersion) {
        objc_setAssociatedObject(self, @selector(cloudVersion), cloudVersion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        kCloudVersion = cloudVersion;
        [self synchroinzeCloudVersion];
    }
}
- (SIMCloudVersion *)cloudVersion {
    @synchronized (kCloudVersion) {
        if (!kCloudVersion) {
            NSData *daa  = [[NSUserDefaults standardUserDefaults] objectForKey:RVNCloudVersionKey];
            NSString *strin = [[NSString alloc] initWithData:daa encoding:NSUTF8StringEncoding];
            NSData *datastr = [strin dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dd = [NSJSONSerialization JSONObjectWithData:datastr options:NSJSONReadingMutableLeaves error:nil];
            
            kCloudVersion = [MTLJSONAdapter modelOfClass:SIMCloudVersion.class fromJSONDictionary:dd error:nil];
        }
        
        return kCloudVersion;
    }
}

- (void)synchroinzeCloudVersion {
    NSDictionary *dict = nil;
    if (kCloudVersion) {
        dict = [MTLJSONAdapter JSONDictionaryFromModel:kCloudVersion error:nil];
        
        NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
        for (NSString *key in [dict allKeys]) {
            //            if (![[dict objectForKey:key] isKindOfClass:[NSNull class]])
            [prunedDictionary setValue:[dict objectForKey:key] forKey:key];
            
        }
        dict = prunedDictionary;
        //        NSLog(@"NSObject+User:%@",dict);
    }
    NSData * dataa = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:dataa forKey:RVNCloudVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
@end
