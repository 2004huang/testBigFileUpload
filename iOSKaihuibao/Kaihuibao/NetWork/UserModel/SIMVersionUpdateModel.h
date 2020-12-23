//
//  SIMVersionUpdateModel.h
//  Kaihuibao
//
//  Created by mac126 on 2019/7/17.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMVersionUpdateModel : NSObject
@property (nonatomic, assign) BOOL needUpdate; // 是否需要更新（0：不需要更新，1需要更新）
@property (nonatomic, assign) BOOL enforce;// 是否强制更新（1：强制更新，0：不强制更新）
@property (nonatomic, copy) NSString *versionName;// 版本名
@property (nonatomic, copy) NSString *versionCode;// 版本号
@property (nonatomic, copy) NSString *appName;// 应用名
@property (nonatomic, copy) NSString *packageName;// 包名
@property (nonatomic, copy) NSString *downloadurl;// 下载地址
@property (nonatomic, copy) NSString *content;// 更新内容
@property (nonatomic, copy) NSString *updatetime;// 更新时间
@property (nonatomic, copy) NSString *device;// 终端设备（ios）
// 字典转模型方法
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
