//
//  SIMNewIMHelper.h
//  Kaihuibao
//
//  Created by mac126 on 2019/6/3.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <ImSDK/ImSDK.h>

NS_ASSUME_NONNULL_BEGIN
//typedef void(^PushCancelBlock)(BOOL cancel);
typedef void(^PDDelayedBlockHandle)(BOOL cancel);
@interface SIMNewIMHelper : NSObject<TIMMessageListener>
/**
 *  获取DeviceDelegateHelper 单例句柄
 *
 *  @return 单例handleblock
 */
@property (copy, nonatomic) PDDelayedBlockHandle pdDelayedBlockHandle;
+ (instancetype)shareInstance;
- (void)addMessageListener;
@end

NS_ASSUME_NONNULL_END
