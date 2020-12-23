//
//  NSObject+SIMConveninet.h
//  OralSystem
//
//  Created by Ferris on 2017/2/26.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SIMTransitionType) {
    SIMTransitionTypePush = 1,
    SIMTransitionTypePop = 2,
    SIMTransitionTypePresent = 3
};

@interface NSObject (SIMConveninet)
/**
 *  Return keyWindow with [[UIApplication sharedApplication] keyWindow]
 *
 *  @return keyWindow for app
 */
+ (UIWindow *)cc_keyWindow;

/**
 *  Return keyWindow with [[UIApplication sharedApplication] keyWindow]
 *
 *  @return keyWindow for app
 */


- (UIWindow *)cc_keyWindow;

- (id<UIApplicationDelegate>)cc_applicationDelegate;

- (void)transitionToViewController:(UIViewController*)vc withAnmitionType:(SIMTransitionType)type;

+ (NSDateFormatter *)dateFormatter ;
@end
