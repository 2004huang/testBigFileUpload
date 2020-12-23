//
//  SIMJoinMeetingViewController.h
//  Kaihuibao
//
//  Created by Ferris on 2017/4/1.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"

@interface SIMJoinMeetingViewController : SIMBaseViewController
@property (nonatomic, assign) BOOL isLive;
@property (nonatomic, strong) NSString *testCidRoom;
@property (nonatomic, strong) NSString *webUrlStr; // 从web链接进入的 要更换服务器
@property (nonatomic, assign) BOOL isJoinPage; // 是不是登录之前进会的 是登录后yes 登录前 no
@property (nonatomic, assign) BOOL isVideoServce;// 是不是视频客服

@end
