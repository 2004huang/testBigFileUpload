//
//  SIMInternationalController.h
//  Kaihuibao
//
//  Created by mac126 on 2018/5/21.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIMInternationalController : NSObject
+ (NSBundle *)bundle;   //获取当前资源文件
+ (void)initUserLanguage;   //初始化语言文件
+ (NSString *)userLanguage; //获取应用当前语言
//+ (void)cleanUserLanguage;//跟随系统清除语言
+ (void)setUserLanguage:(NSString *)language;   //设置当前语言
+ (void)resetRootViewController;//重新设置

+ (NSArray *)getLanguageArr; //获取应用当前语言的数组

// 图片国际化 即可根据系统也可以手动切换的方法
+ (NSString *)getLanPicNameWithPicName:(NSString *)picName;
@end
