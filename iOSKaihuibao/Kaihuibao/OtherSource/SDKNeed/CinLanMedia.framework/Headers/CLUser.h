//
//  CLUser.h
//  CinLanMedia
//
//  Created by 刘金丰 on 2019/3/23.
//  Copyright © 2019 Liujinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLEnum.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, CLUserType) {
    CLUserTypeOwn       = 1 << 0,       // 自己
    CLUserTypeNormal    = 1 << 1,       // 普通用户
    CLUserTypeCreator   = 1 << 2,       // 会议创建者
    CLUserTypeHost      = 1 << 3,       // 主持人
    CLUserTypeCoHost    = 1 << 4,       // 联席主持人
    CLUserTypeShare     = 1 << 5,       // 共享人  
};

@interface CLUser : NSObject

/**
 用户uid-八位字符串
 */
@property (nonatomic, strong) NSString *uid;

/**
 用户原生ID
 */
@property (nonatomic, strong) NSString *ouid;


/**
 nickname
 */
@property (nonatomic, strong) NSString *nickName;

/**
 用户身份
 */
@property (nonatomic, assign, readonly) CLUserType uType;

/**
 举手 defaule NO
*/
@property (nonatomic, assign, readonly) BOOL raiseHand;

/**
 共享类型, NO 为非共享状态
 */
@property (nonatomic, assign, readonly) ConfShareType shareType;

/**
 是否是自己
 */
@property (nonatomic, assign, readonly) BOOL isOwn;

/**
 是否是会议创建者
 */
@property (nonatomic, assign, readonly) BOOL isCreator;

/**
 是否是共享人
 */
@property (nonatomic, assign, readonly) BOOL isShare;

/**
 是否是主持人
 */
@property (nonatomic, assign, readonly) BOOL isHost;

/**
 是否为主持人或者联席主持人
 */
@property (nonatomic, assign, readonly) BOOL isHostOrCoHost;

/**
 是否是联席主持人
 */
@property (nonatomic, assign, readonly) BOOL isCoHost;

/**
 第一个视频是否被广播
 */
@property (nonatomic, assign, readonly) BOOL isBroadcast;

/**
应用活跃状态
*/
@property (nonatomic, assign, readonly) CLAppActStatus appActStatus;


/**
 视频源个数, 只有一个视频源或者没有视频源的话都可以CLUser 这个基类来获取状态,
 (iOS 本地端只有一个视频源, 远端可能有多个, 如果多个视频源,
 就从具体类CLPeer 来获取每一个源的状态)
 */
@property (nonatomic, assign, readonly) NSInteger videoCount;


/**
音频源的 ID (PC端存在多音频源, 则为第一个视频ID)
*/
@property (nonatomic, strong, readonly) NSString *aid;


/**
 视频源的 ID (PC端存在多视频源, 则为第一个视频ID)
 */
@property (nonatomic, strong, readonly) NSString *vid;


/**
 音频设备ID (如果该用户有多个音频源, 则该状态为第一个音频设备ID)
 */
@property (nonatomic, strong) NSString *aDvid;

/**
 视频设备ID (如果该用户有多个视频源, 则该状态为第一个视频设备ID)
 */
@property (nonatomic, strong) NSString *vDvid;

/**
 扩展参数, 便于参数传递时使用
 */
@property (nonatomic, strong) NSDictionary *ext;

@property (nonatomic, assign, readonly) BOOL isAudioOpen;
@property (nonatomic, assign, readonly) BOOL isAudioPause;
@property (nonatomic, assign, readonly) BOOL isAudioEnable;

// *********************************** 如果该用户有多个视频源, 则该状态为第一个添加的视频状态 ***********************************//
@property (nonatomic, assign, readonly) BOOL isVideoOpen;
@property (nonatomic, assign, readonly) BOOL isVideoPause;

+ (instancetype)createUser:(NSString *)uid nickName:(NSString *)nickName;



@end

NS_ASSUME_NONNULL_END
