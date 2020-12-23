//
//  CLConfConfiguration.h
//  CLMediaBundle
//
//  Created by 刘金丰 on 2019/5/10.
//  Copyright © 2019 Liujinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CLConfConfiguration : NSObject


/**
 会议主题
 */
@property (nonatomic, copy) NSString *title;

/**
 会议创建者ID
 */
@property (nonatomic, copy) NSString *creator_id;

/**
 会议ID
 */
@property (nonatomic, copy) NSString *conf_id;

/**
 token
 */
@property (nonatomic, copy) NSString *token;

/**
 会议开始时间
 */
@property (nonatomic, copy) NSString *startTime;

/**
 会议结束时间
 */
@property (nonatomic, copy) NSString *endTime;

/**
 会议地址
 */
@property (nonatomic, copy) NSString *conf_URL;

/**
文档服务器地址
*/
@property (nonatomic, copy) NSString *doc_URL;

/**
 邀请链接
 */
@property (nonatomic, copy) NSString *invite_URL;

/**
 会议视频清晰度
 */
@property (nonatomic, assign) ConfResolution resolution;

/**
 是否需要会议密码
 */
@property (nonatomic, assign) BOOL isNeedConfPassword;

/**
 是否打开本地音频
 */
@property (nonatomic, assign) BOOL isNeedOpenAudio;

/**
 是否打开本地视频
 */
@property (nonatomic, assign) BOOL isNeedOpenVideo;

/**
 是否需要多语同传功能
 */
@property (nonatomic, assign) BOOL isNeedMLST;

/**
 是否需要中文速记功能
 */
@property (nonatomic, assign) BOOL isNeedCS;

/**
 是否需要本地翻译功能
 */
@property (nonatomic, assign) BOOL isNeedLT;

/**
 会议是否被锁定
 */
@property (nonatomic, assign) BOOL isLock;

/**
是否扬声器播放, default NO
*/
@property (nonatomic, assign) BOOL isSpeaker;


/**
 是否需要邀请
 */
@property (nonatomic, assign) BOOL isNeedInvite;

/**
 会议模式 
 */
@property (nonatomic, assign) CLConfSchema confSchema;


// 如果使用屏幕共享, 下边两个属性必须赋值, 切要求iOS 系统 12.0 以上

/**
 屏幕广播扩展App BundleID
 */
@property (nonatomic, strong) NSString *broadcastExtensionBundleID;

/**
 Application Group Identifier
 */
@property (nonatomic, strong) NSString *appGroupIdentifier;


@end

