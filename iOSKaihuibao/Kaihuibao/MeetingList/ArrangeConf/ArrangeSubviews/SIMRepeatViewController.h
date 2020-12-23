//
//  SIMRepeatViewController.h
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/24.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"

@protocol SIMRepeatViewDelegate <NSObject>

// 这里我代理传递的是字符串 以后可能服务器给的参数是type
- (void)inputString:(NSString *)textStr index:(NSInteger)indexTag;
@end

@interface SIMRepeatViewController : SIMBaseViewController
@property (nonatomic, weak) id <SIMRepeatViewDelegate>delegate;
@property (nonatomic, strong) NSString *tagStr;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray *arr;
@end
