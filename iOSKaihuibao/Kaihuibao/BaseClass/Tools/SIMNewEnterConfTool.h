//
//  SIMNewEnterConfTool.h
//  Kaihuibao
//
//  Created by mac126 on 2019/3/29.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>
#import <CinLanMedia/CLConference.h>
#import <CinLanMedia/CLOwn.h>
NS_ASSUME_NONNULL_BEGIN

// 我的会议1 直播2  视频客服3 视频营销4
typedef NS_ENUM(NSInteger, EnterConfType) {
    EnterConfTypeConf = 1,
    EnterConfTypeLive,
    EnterConfTypeServer,
    EnterConfTypeMarket,
};

typedef void(^SuccessBlock) (id success);
typedef void(^FailureBlock) (id failure);

typedef void(^SuccessConfigBlock) (id success);
typedef void(^FailureConfigBlock) (id failure);

typedef void(^SuccessVerifyBlock) (id success);
typedef void(^FailureVerifyBlock) (id failure);


typedef void(^SuccessBaseBlock) (id success);
typedef void(^FailureBaseBlock) (id failure);

typedef void(^ConfMessageBlock) (NSDictionary *confMessageDic);
typedef void(^getConfMessageBlock) (NSDictionary *confMessageDic);


@interface SIMNewEnterConfTool : NSObject


/**
 登录后 进入会议的方法

 @param cidStr 会议号
 @param psw 会议密码 但是现在新sdk不用密码也能进入 但是接口先保留
 @param confType 进会的类型 我的会议1 直播2  视频客服3 视频营销4
 @param isJoined 是否是被动入会 被动入会没有支付 主动入会会显示支付相关内容 yes即是被动入会  no为主动入会
 @param viewController 当前VC
 */
+ (void)enterTheMineConfWithCid:(NSString *)cidStr psw:(NSString *)psw confType:(EnterConfType)confType isJoined:(BOOL)isJoined viewController:(UIViewController<CLConferenceDelegate> *)viewController;


/**
 登录后 进入会议的方法 带回调block的方法

 @param cidStr 会议号
 @param psw 会议密码 但是现在新sdk不用密码也能进入 但是接口先保留
 @param confType 进会的类型 我的会议1 直播2  视频客服3 视频营销4
 @param isJoined 是否是被动入会 被动入会没有支付 主动入会会显示支付相关内容 yes即是被动入会  no为主动入会
 @param viewController 当前VC
 @param successBase 成功的回调
 @param failureBase 失败的回调
 @param confmessage 查询到的进入的会议的相关信息的回调
 */
+ (void)enterTheMineConfWithCid:(NSString *)cidStr webstr:(NSString *)psw nickname:(NSString *)nickname confType:(EnterConfType)confType isJoined:(BOOL)isJoined  needOpenLocalAudio:(BOOL)needOpenLocalAudio needOpenLocalVideo:(BOOL)needOpenLocalVideo viewController:(UIViewController<CLConferenceDelegate> *)viewController success:(SuccessBlock)successBase failure:(FailureBlock)failureBase  cidMessage:(getConfMessageBlock)confmessage;


/**
 快速入会
 
 @param cidStr 会议号
 @param psw 会议密码 但是现在新sdk不用密码也能进入 但是接口先保留
 @param nameStr 名字为必填
 @param confType 进会的类型 我的会议1 直播2  视频客服3 视频营销4
 @param viewController 当前VC
 */

+ (void)quickEnterTheMineConfWithCid:(NSString *)cidStr psw:(NSString *)psw name:(NSString *)nameStr  confType:(EnterConfType)confType viewController:(UIViewController<CLConferenceDelegate> *)viewController;

/**
 快速入会 带回调block的方法

 @param cidStr 会议号
 @param psw 会议密码 但是现在新sdk不用密码也能进入 但是接口先保留
 @param nameStr 名字为必填
 @param confType 进会的类型 我的会议1 直播2  视频客服3 视频营销4
 @param viewController 当前VC
 @param successBase 成功的回调
 @param failureBase 失败的回调
 @param confmessage 查询到的进入的会议的相关信息的回调
 */
+ (void)quickEnterTheMineConfWithCid:(NSString *)cidStr psw:(NSString *)psw name:(NSString *)nameStr confType:(EnterConfType)confType  needOpenLocalAudio:(BOOL)needOpenLocalAudio needOpenLocalVideo:(BOOL)needOpenLocalVideo viewController:(UIViewController<CLConferenceDelegate> *)viewController success:(SuccessBlock)successBase failure:(FailureBlock)failureBase  cidMessage:(getConfMessageBlock)confmessage;
+ (void)exitTheConf;



@end

NS_ASSUME_NONNULL_END
