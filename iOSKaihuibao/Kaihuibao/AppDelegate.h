//
//  AppDelegate.h
//  Kaihuibao
//
//  Created by Ferris on 2017/3/28.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SIMTabBarViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL isShareEnter;// app在tabbar页面如果是被web唤起时候的标识
@property (nonatomic, strong) NSDictionary *shareTheConfEnter;// app被web唤起时候的接受参数
@property (nonatomic, strong) NSString *cidstr;// app被web唤起时候的接受参数
@property (nonatomic, strong) NSString *weburlstr;// app被web唤起时候的接受参数
@property (nonatomic, strong) NSData *deviceToken;

@end

