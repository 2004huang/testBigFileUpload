//
//  BaseNetworking.h
//  kaihuibao
//
//  Created by wangxiaoqi on 2017/2/10.
//  Copyright © 2017年 wangxiaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
*  请求任务
*/
typedef NSURLSessionTask URLSessionTask;

typedef void(^SuccessBlock) (id success);
typedef void(^FailureBlock) (id failure);
typedef void(^ProgressBlock) (id progress);
typedef void(^BodysBlock) (id bodys);

@interface BaseNetworking: NSObject<NSMutableCopying,NSCopying>

/**
 单例初始化

 @return 实体
 */
+ (instancetype)shareInstance;

/**
 判断网络状态
 */
- (void)getReach;


/**
 不带token的get
 
 @param url 请求地址
 @param params 请求参数
 @param successBase 成功回调
 @param failureBase 失败回调
 */
- (void)startWithGetURL:(NSString *)url
                 params:(NSDictionary *)params
                success:(SuccessBlock)successBase
                failure:(FailureBlock)failureBase;

/**
 带token请求头的get
 
 @param url 请求地址
 @param params 请求参数
 @param successBase 成功回调
 @param failureBase 失败回调
 */

- (void)startWithHeaderGetURL:(NSString *)url
                       params:(NSDictionary *)params
                      success:(SuccessBlock)successBase
                      failure:(FailureBlock)failureBase;


/**
 不带token的post

 @param url 请求地址
 @param params 请求参数
 @param successBase 成功回调
 @param failureBase 失败回调
 */
- (void)startWithPostURL:(NSString *)url
                  params:(NSDictionary *)params
                 success:(SuccessBlock)successBase
                 failure:(FailureBlock)failureBase;

/**
 带token请求头的post

 @param url 请求地址
 @param params 请求参数
 @param successBase 成功回调
 @param failureBase 失败回调
 */
- (void)startWithHeaderPostURL:(NSString *)url
                        params:(NSDictionary *)params
                       success:(SuccessBlock)successBase
                       failure:(FailureBlock)failureBase;

/**
 删除Delegete请求 用于删除接口的

 @param url 请求地址
 @param params 请求参数
 @param successBase 成功回调
 @param failureBase 失败回调
 */
- (void)requestDELETEDataWithUrl:(NSString *)url
                   withParamters:(NSDictionary *)params
                         success:(SuccessBlock)successBase
                         failure:(FailureBlock)failureBase;


/**
 头像图片上传

 @param url 请求地址
 @param params 请求参数
 @param bodysBase 上传图片的请求体
 @param progressBase 进度条
 @param successBase 成功回调
 @param failureBase 失败回调
 */
- (void)startPicWithHeaderPostURL:(NSString *)url
                           params:(NSDictionary *)params
                            bodys:(BodysBlock)bodysBase
                         progress:(ProgressBlock)progressBase
                          success:(SuccessBlock)successBase
                          failure:(FailureBlock)failureBase;


/**
 *  取消所有请求
 */
- (void)cancleAllRequest;

@end
