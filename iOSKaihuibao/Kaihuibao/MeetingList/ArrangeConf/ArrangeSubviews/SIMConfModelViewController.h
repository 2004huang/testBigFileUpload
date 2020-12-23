//
//  SIMConfModelViewController.h
//  Kaihuibao
//
//  Created by mac126 on 2019/7/3.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"
#import "ArrangeConfModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ConfModelDelegate <NSObject>

// 这里我代理传递的是字符串 以后可能服务器给的参数是type
- (void)confModeModel:(ConfModelModel *)modelModel type:(NSInteger)type;
@end

@interface SIMConfModelViewController : SIMBaseViewController
@property (nonatomic, weak) id <ConfModelDelegate>delegate;
@property (nonatomic, copy) NSString *tagStr;
@property (nonatomic, copy) NSArray *confArr;
@end

NS_ASSUME_NONNULL_END
