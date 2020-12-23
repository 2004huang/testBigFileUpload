//
//  UITabBar+badge.h
//  Kaihuibao
//
//  Created by mac126 on 2018/7/4.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (badge)
- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
