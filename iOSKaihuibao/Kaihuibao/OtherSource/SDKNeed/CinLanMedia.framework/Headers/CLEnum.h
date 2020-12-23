//
//  CLEnum.h
//  CinLanMedia
//
//  Created by 刘金丰 on 2019/3/21.
//  Copyright © 2019 Liujinfeng. All rights reserved.
//

#ifndef CLEnum_h
#define CLEnum_h

typedef NS_ENUM(NSInteger, CLViewSchemaType) {
    CLViewSchemaTypeGallery = 1,
    CLViewSchemaTypeLecture,
    CLViewSchemaTypeThumbnail
};

typedef NS_ENUM(NSInteger, ConfInvitationType) {
    ConfInvitationTypeSMS,      //  短信
    ConfInvitationTypeWEC,      // WeChat
    ConfInvitationTypeURL,      // URL 拷贝
    ConfInvitationTypeCTC,      // The contact 联系人
};

typedef NS_ENUM(NSInteger, CLConfSchema) {
    CLConfSchemaFRE,        // Free 自由视角    (视频视图自由)
    CLConfSchemaSWH,        // Same With Host 与主持人一致    (视频视图一致)
    CLConfSchemaSWHB,       // Same With Host Broadcast 与主持人广播一致 (视频一致, 视图自由)
    CLConfSchemaIntercom,   // 对讲模式
    CLConfSchemaEHS,        // EHS 模式
    CLConfSchemaRCU,        // Remote Control Unit
    CLConfSchemaTLP         // Telephone
};

typedef NS_ENUM(NSInteger, CLAuthorityType) {
    CLAuthorityTypeNO,      // 无
    CLAuthorityTypeHost,    // 主持人权限
    CLAuthorityTypeCoHost   // 联席主持人权限
};

typedef NS_ENUM(NSInteger, CLScreenRecorderStatus) {
    CLScreenRecorderStatusStop,
    CLScreenRecorderStatusStart,
    CLScreenRecorderStatusPause,
    CLScreenRecorderStatusResume
};

/**
 视频分辨率
 - ConfResolution_360P:     360 * 280
 - ConfResolution_640P:     640 * 480
 - ConfResolution_960P:     960 * 540
 - ConfResolution_1280P:    1280 * 720
 */
typedef NS_ENUM(NSInteger, ConfResolution) {
    ConfResolution_360P = 0,
    ConfResolution_640P,
    ConfResolution_960P,
    ConfResolution_1280P
};



/**
  音频输出Rout 类型

 - CLAudioSessionOutRouteTypeReceiver: 听筒
 - CLAudioSessionOutRouteTypeSpeaker: 扬声器
 - CLAudioSessionOutRouteTypeHeadphone: 有线耳机
 - CLAudioSessionOutRouteTypeBluetooth: 蓝牙耳机
 - CLAudioSessionOutRouteTypeOther: 其他类型
 */
typedef NS_ENUM(NSInteger, CLAudioSessionOutRouteType) {
    CLAudioSessionOutRouteTypeReceiver,
    CLAudioSessionOutRouteTypeSpeaker,
    CLAudioSessionOutRouteTypeHeadphone,
    CLAudioSessionOutRouteTypeBluetooth,
    CLAudioSessionOutRouteTypeOther
};

typedef NS_ENUM(NSInteger, ConfVideoQuality) {
    ConfVideoQualityLow,
    ConfVideoQualityMedium,
    ConfVideoQualityHigh
};

typedef NS_OPTIONS(NSInteger, ConfShareType) {
    ConfShareTypeNO = 1 << 0,   // NO
    ConfShareTypeWB = 1 << 1,   // white board 共享白板
    ConfShareTypeSN = 1 << 2,   // screen 屏幕共享
    ConfShareTypeDM = 1 << 3,   // document 文档共享
    ConfShareTypeWP = 1 << 4,   // webpage 共享
    ConfShareTypePT = 1 << 5,   // photo    照片
    ConfShareTypeCD = 1 << 6    // cloud document 云端文件
};


typedef NS_ENUM(NSInteger, ConfCaptionShowType) {
    ConfCaptionShowTypeBottom,          // 底部显示
    ConfCaptionShowTypeTop,             // 顶部显示
    ConfCaptionShowTypeFullScreen       // 全屏显示
};


typedef NS_ENUM(NSInteger, MSMediaKind) {
    MSMediaKindUnknow,
    MSMediaKindAudio,
    MSMediaKindVideo
};

/**
  媒体数据源类型
 */
typedef NS_ENUM(NSInteger, MediaSourceType) {
    MediaSourceTypeUnknow = 1, // 未知
    MediaSourceTypeMic,        // 麦克风
    MediaSourceTypeCam,        // 摄像头
    MediaSourceTypeScreen,     // 屏幕
};

typedef NS_ENUM(NSInteger, CLAppActStatus) {
    CLAppActStatusBecomeActive,         // 已经活跃
    CLAppActStatusEnterBackground       // 进入后台
};

#endif /* CLEnum_h */
