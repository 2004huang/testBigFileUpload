//
//  SIMAlertView.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/15.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMAlertView.h"

@implementation SIMAlertView
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated{
    if (buttonIndex == 0) {
        [super dismissWithClickedButtonIndex:buttonIndex animated:animated]; // 消失
        // 不消失
        //[super dismissWithClickedButtonIndex:buttonIndex animated:animated]; // 消失
    }else{
        // 不消失
    }
}

@end
