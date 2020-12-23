//
//  SIMCloudVersion.h
//  Kaihuibao
//
//  Created by mac126 on 2019/6/14.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMCloudVersion : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSString *version; // 是私有还是公有
@property (nonatomic, copy) NSString *join_meeting;// 加入会议开关
@property (nonatomic, copy) NSString *im;// 聊天开关
@property (nonatomic, copy) NSString *start_meeting;// 开始会议按钮开关
@property (nonatomic, copy) NSString *arrange_meeting;// 安排会议开关
@property (nonatomic, copy) NSString *map_position;// 地图开关
@property (nonatomic, copy) NSString *address_book;// 通讯录整个模块开关
@property (nonatomic, copy) NSString *about;// 关于只显示版本号开关
@property (nonatomic, copy) NSString *captcha_login; // 验证码登录开关
@property (nonatomic, copy) NSString *password_login; // 密码登录开关
@property (nonatomic, copy) NSString *registerBtn; // 注册开关
@property (nonatomic, copy) NSString *third_login; // 三方登录开关
@property (nonatomic, copy) NSString *change_company;// 有没有切换公司这样的开关
@property (nonatomic, copy) NSString *forget_password; // 忘记密码开关
@property (nonatomic, copy) NSString *online_experience; // 在线体验室开关
@property (nonatomic, copy) NSString *plan;// 支付相关开关
@property (nonatomic, copy) NSString *start_img;// 首页一个图片开关
@property (nonatomic, copy) NSString *contacts;// 通讯录里手机联系人开关
@property (nonatomic, copy) NSString *myfriend;// 通讯录里我的好友开关
@property (nonatomic, copy) NSString *invite; // 通讯录里邀请使用开关
@property (nonatomic, copy) NSString *wechat; // 微信分享开关
@property (nonatomic, copy) NSString *email;// 邮件分享开关
@property (nonatomic, copy) NSString *message;// 短信分享开关
@property (nonatomic, copy) NSString *pasteBoard;// 复制到开关
@property (nonatomic, copy) NSString *username_type;// 账号还是手机字样显示开关
@property (nonatomic, copy) NSString *webFileUrl;// 文档上传的服务器地址
@property (nonatomic, copy) NSString *shareDocument;// 有没有文档共享的开关 暂时如果这是里no那么把webfileurl手动清空即可
@property (nonatomic, copy) NSString *shorthand;// 有没有会议速记的开关
@property (nonatomic, copy) NSString *find;// 有没有发现的开关
// 会议模式开关
@property (nonatomic, copy) NSString *freeCamera;// 自由讨论会议的开关
@property (nonatomic, copy) NSString *mainBroadcast;// 网络广播会议的开关
@property (nonatomic, copy) NSString *mainCamera;// 网络研讨会的开关
@property (nonatomic, copy) NSString *intercom;// 对讲机模式会议的开关
@property (nonatomic, copy) NSString *EHSfieldOperation;// EHS现场作业的开关
@property (nonatomic, copy) NSString *voiceSeminar;// 语音电话会议的开关
@property (nonatomic, copy) NSString *trainingConference;// 在线培训会议的开关
@property (nonatomic, copy) NSString *live;// 直播会议的开关
@property (nonatomic, copy) NSString *many_languages;// 多语言的开关
@property (nonatomic, copy) NSString *cloud_server;// 设置服务器的开关
// 我的页面
@property (nonatomic, copy) NSString *avatar_show;// 头像显示的开关
@property (nonatomic, copy) NSString *avatar_update;// 头像修改的开关
@property (nonatomic, copy) NSString *nickname_show;// 昵称显示的开关
@property (nonatomic, copy) NSString *nickname_update;// 昵称修改的开关
@property (nonatomic, copy) NSString *companyname_show;// 公司显示的开关
@property (nonatomic, copy) NSString *companyname_update;// 公司修改的开关
@property (nonatomic, copy) NSString *update_password;// 密码显示和修改的开关
@property (nonatomic, copy) NSString *username_prompt;// 是账号account登录还是手机号mobile登录的开关
@property (nonatomic, copy) NSString *cloud_space;// 云空间的开关
// 关于里面的开关
@property (nonatomic, copy) NSString *feedback;// 发送反馈的开关
@property (nonatomic, copy) NSString *recommend_show;// 向他人推荐的开关
@property (nonatomic, copy) NSString *recommend_content;// 向他人推荐的内容文案后台提供
@property (nonatomic, copy) NSString *homeurl_show;// 访问官网的开关
@property (nonatomic, copy) NSString *homeurl;// 访问官网网址的内容后台提供

@property (nonatomic, copy) NSString *defaultConfMode;// 用于默认进入的会议模式

@property (nonatomic, copy) NSString *privacy_path;   // 隐私政策路径
@property (nonatomic, copy) NSString *terms_path;     // 服务条款路径
@property (nonatomic, copy) NSString *special_note;   // 首页底部是否显示的开关
@property (nonatomic, copy) NSString *specialnote_content;     // 首页底部内容文字
@property (nonatomic, copy) NSString *specialnote_link;   // 首页底部链接内容

@property (nonatomic, copy) NSString *teaching_model;   // 教学模式
@property (nonatomic, copy) NSString *telemedicine;   // 远程医疗
@property (nonatomic, copy) NSString *field_operation;   // 现场作业
@property (nonatomic, copy) NSString *video_playback;   // 录像回放
@property (nonatomic, copy) NSString *learning_center;   // 学习中心
@property (nonatomic, copy) NSString *video_home;   // 视频主页




// 字典转模型方法
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initWithDeflaut;
@end

NS_ASSUME_NONNULL_END
