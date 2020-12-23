//
//  SIMLocalListViewController.h
//  Kaihuibao
//
//  Created by mac126 on 2019/9/26.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol SIMLocalListDelegate <NSObject>

// 这里我代理传递的是字符串 以后可能服务器给的参数是type
- (void)countryString:(NSString *)textStr index:(NSInteger)indexTag;
@end

@interface SIMLocalListViewController : SIMBaseViewController
@property (nonatomic, weak) id <SIMLocalListDelegate>delegate;
@property (nonatomic, strong) NSString *tagStr;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray *arr;
@end

NS_ASSUME_NONNULL_END
