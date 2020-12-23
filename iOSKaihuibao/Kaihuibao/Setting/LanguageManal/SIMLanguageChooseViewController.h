//
//  SIMLanguageChooseViewController.h
//  Kaihuibao
//
//  Created by mac126 on 2018/5/22.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"
@protocol SIMLanguageChooseViewDelegate <NSObject>

// 这里我代理传递的是字符串 以后可能服务器给的参数是type
//- (void)inputString:(NSString *)textStr index:(NSInteger)indexTag;
@end

@interface SIMLanguageChooseViewController : SIMBaseViewController
//@property (nonatomic, weak) id <SIMLanguageChooseViewDelegate>delegate;
@property (nonatomic, assign) NSInteger tags;
@property (nonatomic, strong) NSString *pageType;// 从那个页面进入是登录前还是后 登录前 unlog登录后login



@end
