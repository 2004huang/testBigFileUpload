//
//  CLOwn.h
//  CinLanMedia
//
//  Created by 刘金丰 on 2019/3/25.
//  Copyright © 2019 Liujinfeng. All rights reserved.
//

#import "CLUser.h"

NS_ASSUME_NONNULL_BEGIN
@class RTCTrack;
@interface CLOwn : CLUser

@property (nonatomic, assign) BOOL forceH264;

@property (nonatomic, strong, readonly) NSString *aid;

/**
 创建 Own数据对象

 @param uid 用户ID
 @param nick 昵称
 @param forceH264 是否强制H264编码
 @return own对象
 */
+ (instancetype)createOwn:(NSString *)uid nick:(NSString *)nick forceH264:(BOOL)forceH264;

/**
 是否需要打开本地视频 default NO;
 */
@property (nonatomic, assign, readonly) BOOL needOpenLocalVideo;
@property (nonatomic, assign, readonly) BOOL needOpenLocalAudio;

@property (nonatomic, assign, readonly) BOOL audioOnly;
@property (nonatomic, assign, readonly) BOOL isFront;

@property (nonatomic, strong, readonly, nullable) RTCTrack *vTrack;
@property (nonatomic, strong, readonly, nullable) RTCTrack *aTrack;


@end

NS_ASSUME_NONNULL_END
