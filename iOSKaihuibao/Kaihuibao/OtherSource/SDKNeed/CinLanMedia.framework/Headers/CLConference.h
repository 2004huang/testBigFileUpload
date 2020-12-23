//
//  CLConference.h
//  CinLanMedia
//
//  Created by 刘金丰 on 2019/3/19.
//  Copyright © 2019 Liujinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLEnum.h"
#import "CLConfConfiguration.h"

NS_ASSUME_NONNULL_BEGIN
@class CLOwn;

@protocol CLConferenceDelegate <NSObject>

/**
 退会回调

 @param error 退会原因 (正常退会为nil)
 */
- (void)exitConference:(NSError * _Nullable)error;

/**
 会议邀请回调

 @param vc 当前控制器
 @param invatationType 邀请类型
 @param url url
 */
- (void)confInviteWithVC:(UIViewController *)vc invatationType:(ConfInvitationType)invatationType url:(NSString *)url;

/**
 会议清晰度修改回调

 @param resolution 会议视频清晰度
 */
- (void)confResolutionChanged:(ConfResolution)resolution;


/**
速记内容回调

@param content 内容
 seq_id;     // 会议序列号
 cap_id;        // 字幕ID
 conf_id;       // 会议ID
 user_id;       // 用户ID
 nickname;      // 用户昵称
 srcText;       // 源文本
 srcLanCode;    // 源语言简码
 tarText;       // 目标语言文本
 tarLanCode;    // 目标语言简码
 ts;            // 时间戳
*/
- (void)confShorthandContent:(id)content;

@end

@interface CLConference : NSObject

+ (instancetype)conference;

@property (nonatomic, weak, readonly) CLConfConfiguration *confConfig;

/**
 设置会议配置

 @param confConfig 会议配置
 */
- (void)configurationConference:(CLConfConfiguration *)confConfig;

/**
 入会接口

 @param user 入会人数据
 @param delegate 入会代理
 @param callback 入会回调
 */
- (void)enterConf:(CLOwn *_Nonnull)user delegate:(UIViewController <CLConferenceDelegate>*_Nonnull)delegate callback:(void (^)(NSError *error))callback;


/**
 EHS 入口
 
 @param user 入会人数据
 @param delegate 入会代理
 @param callback 入会回调
 */
- (void)enterEHS:(CLOwn *_Nonnull)user delegate:(UIViewController <CLConferenceDelegate>*_Nonnull)delegate callback:(void (^)(NSError *error))callback;

/**
 Remote-Control Unit 入口
 
 @param user 入会人数据
 @param delegate 入会代理
 @param callback 入会回调
 */
- (void)enterRCU:(CLOwn *)user delegate:(UIViewController <CLConferenceDelegate>*_Nonnull)delegate callback:(void (^)(NSError *error))callback;

/**
 退出会议
 */
- (void)ExitConf;

@end

NS_ASSUME_NONNULL_END
