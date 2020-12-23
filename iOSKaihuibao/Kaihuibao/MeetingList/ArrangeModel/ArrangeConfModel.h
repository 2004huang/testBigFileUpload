//
//  ArrangeConfModel.h
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/23.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ConfModelModel;

@interface ArrangeConfModel : NSObject

@property (nonatomic, assign) BOOL isPast;
@property (nonatomic, strong) NSString *live_id;

@property (nonatomic, assign) BOOL isChangeConf;

@property (nonatomic, assign) BOOL isLive;// 区分是直播还是会议 三个界面共用

// 创建会议
@property (nonatomic, strong) NSString *name;///
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *startTime;///
@property (nonatomic, strong) NSString *stopTime;///
@property (nonatomic, strong) NSString *normalPassword;///
@property (nonatomic, strong) NSString *mainPassword;///
@property (nonatomic, strong) NSString *repeat;
@property (nonatomic, strong) NSString *roomUrl;
@property (nonatomic, strong) NSArray *confdocList;

@property (nonatomic, assign) BOOL host_video;
@property (nonatomic, assign) BOOL member_video;
@property (nonatomic, assign) BOOL before_host;
@property (nonatomic, assign) BOOL user_only;
@property (nonatomic, assign) BOOL public_conf;
@property (nonatomic, assign) BOOL live_conf;

@property (nonatomic, assign) BOOL participantAudio;
@property (nonatomic, assign) BOOL participantVideo;
@property (nonatomic, assign) BOOL mainVideo;
@property (nonatomic, assign) BOOL mainAudio;
@property (nonatomic, strong) NSString *confMode;
@property (nonatomic, strong) NSString *confModeStr;

@property (nonatomic, assign) BOOL open_live;// 公开直播

// 参数 课程说明
//@property (nonatomic, strong) NSString *class_detail;

// 其他会议参数 留用  “///” 表示为会议列表用参数
@property (nonatomic, strong) NSNumber *conf_status;///
@property (nonatomic, strong) NSString *live_status;


@property (nonatomic, assign) BOOL file_transfer;
@property (nonatomic, assign) BOOL link_type;///


@property (nonatomic, strong) NSString *max_member;///
@property (nonatomic, assign) BOOL notify_cancel;
@property (nonatomic, assign) BOOL multi_camera;
@property (nonatomic, assign) BOOL remote_camera;
@property (nonatomic, assign) BOOL remote_support;
@property (nonatomic, strong) NSString *rotate;
@property (nonatomic, assign) BOOL schedule_type;///
@property (nonatomic, strong) NSString *share;
@property (nonatomic, strong) NSString *create_time;///
@property (nonatomic, strong) NSString *cid;///
@property (nonatomic, strong) NSString *member;///

@property (nonatomic, assign) BOOL text_broadcast;
@property (nonatomic, assign) BOOL text_chat;
@property (nonatomic, strong) NSArray *iconimgurl;


@property (nonatomic, strong) NSString *admin_id;// 新增


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface ConfModelModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *serial;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
