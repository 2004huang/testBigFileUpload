//
//  NSObject+SIMConveninet.m
//  OralSystem
//
//  Created by Ferris on 2017/2/26.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "NSObject+SIMConveninet.h"

@implementation NSObject (SIMConveninet)
+ (UIWindow *)cc_keyWindow {
    return [[UIApplication sharedApplication] keyWindow];
}

- (UIWindow *)cc_keyWindow {
    return [[UIApplication sharedApplication] keyWindow];
}

- (id<UIApplicationDelegate>)cc_applicationDelegate {
    return [UIApplication sharedApplication].delegate;
}

- (void)transitionToViewController:(UIViewController *)vc withAnmitionType:(SIMTransitionType)type
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;

    switch (type) {
        case SIMTransitionTypePop:
            animation.type = kCATransitionPush;
            animation.subtype = kCATransitionFromLeft;
            break;
        case SIMTransitionTypePush:
            animation.type = kCATransitionPush;
            animation.subtype = kCATransitionFromRight;
            break;
        case SIMTransitionTypePresent:
            animation.type = kCATransitionPush;
            animation.subtype = kCATransitionFromBottom;
            break;
        default:
            break;
    }
    
    [[self cc_keyWindow].layer addAnimation:animation forKey:nil];
    [self cc_keyWindow].rootViewController = vc;
}
+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return dateFormatter;
}

//+ (void)load{
//
//    SEL originalSelector = @selector(doesNotRecognizeSelector:);
//    SEL swizzledSelector = @selector(sw_doesNotRecognizeSelector:);
//
//    Method originalMethod = class_getClassMethod(self, originalSelector);
//    Method swizzledMethod = class_getClassMethod(self, swizzledSelector);
//
//    if(class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))){
//        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//    }else{
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//}
//
//+ (void)sw_doesNotRecognizeSelector:(SEL)aSelector{
//    //处理 _LSDefaults 崩溃问题
//    if([[self description] isEqualToString:@"_LSDefaults"] && (aSelector == @selector(sharedInstance))){
//        //冷处理...
//        return;
//    }
//    [self sw_doesNotRecognizeSelector:aSelector];
//}

@end
