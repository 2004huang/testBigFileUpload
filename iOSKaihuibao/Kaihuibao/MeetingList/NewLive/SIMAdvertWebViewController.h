//
//  SIMLiveInterestingViewController.h
//  Kaihuibao
//
//  Created by 王小琪 on 2017/9/15.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"
#import "SIMPicture.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcDelegate <JSExport>
- (void)call;
- (void)getCall:(NSString *)callString;

@end

@interface SIMAdvertWebViewController : SIMBaseViewController<JSObjcDelegate>
@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, strong) NSString *webStr;
@property (nonatomic, assign) NSInteger webTypeShare;
@end
