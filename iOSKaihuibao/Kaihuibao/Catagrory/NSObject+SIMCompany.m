//
//  NSObject+SIMCompany.m
//  Kaihuibao
//
//  Created by 王小琪 on 2019/4/1.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "NSObject+SIMCompany.h"
#import <objc/runtime.h>

NSString * const RVNCurrentCompanyKey = @"com.oral.xferris.current.company1";

static SIMCompany *kCurrentCompany;

@implementation NSObject (SIMCompany)

+ (void)load {
    
    
    NSData *daa  = [[NSUserDefaults standardUserDefaults] objectForKey:RVNCurrentCompanyKey];
    NSString *strin = [[NSString alloc] initWithData:daa encoding:NSUTF8StringEncoding];
    NSData *datastr = [strin dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dd = [NSJSONSerialization JSONObjectWithData:datastr options:NSJSONReadingMutableLeaves error:nil];
    kCurrentCompany = dd?[MTLJSONAdapter modelOfClass:[SIMCompany class] fromJSONDictionary:dd error:nil]:nil;
}
- (void)setCurrentCompany:(SIMCompany *)currentCompany {
    @synchronized (kCurrentCompany) {
        objc_setAssociatedObject(self, @selector(currentCompany), currentCompany, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        kCurrentCompany = currentCompany;
        [self synchroinzeCurrentCompany];
    }
}
- (SIMCompany *)currentCompany {
    @synchronized (kCurrentCompany) {
        if (!kCurrentCompany) {
            NSData *daa  = [[NSUserDefaults standardUserDefaults] objectForKey:RVNCurrentCompanyKey];
            NSString *strin = [[NSString alloc] initWithData:daa encoding:NSUTF8StringEncoding];
            NSData *datastr = [strin dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dd = [NSJSONSerialization JSONObjectWithData:datastr options:NSJSONReadingMutableLeaves error:nil];
            
            kCurrentCompany = [MTLJSONAdapter modelOfClass:SIMCompany.class fromJSONDictionary:dd error:nil];
        }
        
        return kCurrentCompany;
    }
}


- (void)synchroinzeCurrentCompany {
    NSDictionary *dict = nil;
    if (kCurrentCompany) {
        dict = [MTLJSONAdapter JSONDictionaryFromModel:kCurrentCompany error:nil];
        
        NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
        for (NSString *key in [dict allKeys]) {
            //            if (![[dict objectForKey:key] isKindOfClass:[NSNull class]])
            [prunedDictionary setValue:[dict objectForKey:key] forKey:key];
            
        }
        dict = prunedDictionary;
        //        NSLog(@"NSObject+User:%@",dict);
    }
    NSData * dataa = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:dataa forKey:RVNCurrentCompanyKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
@end
