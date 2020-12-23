//
//  SIMInternationalController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/5/21.
//  Copyright © 2018年 Ferris. All rights reserved.
//


#import "SIMInternationalController.h"
#import <UIKit/UIKit.h>
#import "SIMTabBarViewController.h"

@implementation SIMInternationalController
//创建静态变量bundle，以及获取方法bundle（此处不要使用getBundle).
static NSBundle *bundle = nil;

+ (NSBundle *)bundle {
    return bundle;
}
//初始化方法:
+ (void)initUserLanguage {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (![def objectForKey:kLanguage]) {
        // 如果本地没有值 那么默认为跟随系统
        [def setObject:@"followSystem" forKey:kLanguage];
        [def synchronize];
    }
    NSString *string = [self userLanguage];
//    else if ([[def objectForKey:kLanguage] isEqualToString:@"followSystem"]) {
//        NSArray  *languages = [NSLocale preferredLanguages];
//        NSString *language = [languages objectAtIndex:0];
//        if ([language hasPrefix:@"zh-Hans"]) {
//            // 简体中文
//            string = @"zh-Hans";
//        }else if ([language hasPrefix:@"zh-Hant"]) {
//            // 繁体中文
//            string = @"zh-Hant";
//        }else if ([language hasPrefix:@"ja"]) {
//            // 日语
//            string = @"ja";
//        }else {
//            string = @"en";
//        }
//    }else {
//        string = [def valueForKey:kLanguage];
//    }
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
//    NSLog(@"%@",path);
    bundle = [NSBundle bundleWithPath:path];    //生成bundle
}

//获得当前语言的方法
+ (NSString *)userLanguage {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *string;
    if ([[def objectForKey:kLanguage] isEqualToString:@"followSystem"]) {
        NSArray  *languages = [NSLocale preferredLanguages];
        NSString *language = [languages objectAtIndex:0];
        NSLog(@"languagesarr %@",languages);
        NSArray *arr = @[@"zh-Hans",@"zh-Hant",@"ja",@"en"];
        for (NSString *str in arr) {
            if ([language hasPrefix:str]) {
                string = str;
                break ;
            }
        }
        if (!string) {
            string = @"en";
        }
        
    }else {
        string = [def objectForKey:kLanguage];
    }
    NSLog(@"当前国际化语言值 %@",string);
    
    return string;
}

//跟随系统清除语言
//+ (void)cleanUserLanguage {
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLanguage];
//    [self resetRootViewController];
//}

//设置语言
+ (void)setUserLanguage:(NSString *)languageStr {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    //1.持久化
    [def setObject:languageStr forKey:kLanguage];
    [def synchronize];
    NSString *string = [self userLanguage];
//    NSString *string;
//    if ([languageStr isEqualToString:@"followSystem"]) {
//        NSArray  *languages = [NSLocale preferredLanguages];
//        NSString *language = [languages objectAtIndex:0];
//        if ([language hasPrefix:@"zh-Hans"]) {
//            // 简体中文
//            string = @"zh-Hans";
//        }else if ([language hasPrefix:@"zh-Hant"]) {
//            // 繁体中文
//            string = @"zh-Hant";
//        }else if ([language hasPrefix:@"ja"]) {
//            // 日语
//            string = @"ja";
//        }else {
//            string = @"en";
//        }
//    }else {
//        string = languageStr;
//    }
    
    //2.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
    
}
//重新设置
+ (void)resetRootViewController
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SIMTabBarViewController *tabVC = [[SIMTabBarViewController alloc] init];
    delegate.window.rootViewController = tabVC;
    NSArray *arrControllers = tabVC.viewControllers;
    tabVC.selectedIndex = arrControllers.count - 1;
}


// 图片国际化 即可根据系统也可以手动切换的方法
+ (NSString *)getLanPicNameWithPicName:(NSString *)picName {
    NSString *string = [self userLanguage];
//    NSString *string;
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:kLanguage]) {
//        NSArray  *languages = [NSLocale preferredLanguages];
//        NSString *language = [languages objectAtIndex:0];
//        if ([language hasPrefix:@"zh"]) {
//            string = @"zh-Hans";
//        }else {
//            string = @"en";
//        }
//    }else {
//        string = [[NSUserDefaults standardUserDefaults] objectForKey:kLanguage];
//    }
    if ([string hasPrefix:@"zh"]) {
        // 是汉语的都不管繁体还是啥 图片资源暂时用一个
        return [NSString stringWithFormat:@"%@_hans",picName];
    }else {
        // 其他语言的 都暂时用英文的
        return [NSString stringWithFormat:@"%@_en",picName];
    }
}

+ (NSArray *)getLanguageArr {
    NSArray *arr = @[@{@"type":@"followSystem",@"name":@"系统语言"},
    @{@"type":@"zh-Hans",@"name":@"简体中文"},
     @{@"type":@"zh-Hant",@"name":@"繁体中文"},
    @{@"type":@"en",@"name":@"English"},
    @{@"type":@"ja",@"name":@"Japanese"}];
    return arr;
}


@end
