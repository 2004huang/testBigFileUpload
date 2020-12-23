//
//  NSObject+User.m
//  Tictalk
//
//  Created by Draveness on 6/5/16.
//  Copyright © 2016 Tictalkin. All rights reserved.
//

#import "NSObject+User.h"
#import <objc/runtime.h>

NSString * const RVNCurrentUserKey = @"com.oral.xferris.current.user1";

static CCUser *kCurrentUser;

@implementation NSObject (User)

+ (void)load {
    NSData *daa  = [[NSUserDefaults standardUserDefaults] objectForKey:RVNCurrentUserKey];
    NSString *strin = [[NSString alloc] initWithData:daa encoding:NSUTF8StringEncoding];
    NSData *datastr = [strin dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dd = [NSJSONSerialization JSONObjectWithData:datastr options:NSJSONReadingMutableLeaves error:nil];
    kCurrentUser = dd?[MTLJSONAdapter modelOfClass:[CCUser class] fromJSONDictionary:dd error:nil]:nil;
}

- (void)setCurrentUser:(CCUser *)currentUser {
    @synchronized (kCurrentUser) {
        //        if (!currentUser.token) {
        //            currentUser.token = self.currentUser.token;
        //        }
        objc_setAssociatedObject(self, @selector(currentUser), currentUser, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        kCurrentUser = currentUser;
        [self synchroinzeCurrentUser];
    }
}
- (CCUser *)currentUser {
    @synchronized (kCurrentUser) {
        if (!kCurrentUser) {
            NSData *daa  = [[NSUserDefaults standardUserDefaults] objectForKey:RVNCurrentUserKey];
            NSString *strin = [[NSString alloc] initWithData:daa encoding:NSUTF8StringEncoding];
            NSData *datastr = [strin dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dd = [NSJSONSerialization JSONObjectWithData:datastr options:NSJSONReadingMutableLeaves error:nil];

            kCurrentUser = [MTLJSONAdapter modelOfClass:CCUser.class fromJSONDictionary:dd error:nil];
        }
        
        return kCurrentUser;
    }
}


- (void)synchroinzeCurrentUser {
    NSDictionary *dict = nil;
    if (kCurrentUser) {
        dict = [MTLJSONAdapter JSONDictionaryFromModel:kCurrentUser error:nil];

        NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
        for (NSString *key in [dict allKeys]) {
//            if (![[dict objectForKey:key] isKindOfClass:[NSNull class]])
                [prunedDictionary setValue:[dict objectForKey:key] forKey:key];
        
        }
        dict = prunedDictionary;
//        NSLog(@"NSObject+User:%@",dict);
    }
    NSData * dataa = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:dataa forKey:RVNCurrentUserKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
@end
