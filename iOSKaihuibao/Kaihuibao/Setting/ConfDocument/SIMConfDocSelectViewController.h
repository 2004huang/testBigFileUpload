//
//  SIMConfDocSelectViewController.h
//  Kaihuibao
//
//  Created by mac126 on 2019/9/9.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"
#import "SIMConfDocModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ConfDocSelectDelegate <NSObject>
// 这里我代理传递的是字符串 以后可能服务器给的参数是type
- (void)confDocSelectAlreadyArr:(NSArray *)seletArr;
@end

@interface SIMConfDocSelectViewController : SIMBaseViewController
@property (nonatomic, weak) id <ConfDocSelectDelegate>delegate;
@property (nonatomic, strong) NSArray *docIDArr;
@end

NS_ASSUME_NONNULL_END
