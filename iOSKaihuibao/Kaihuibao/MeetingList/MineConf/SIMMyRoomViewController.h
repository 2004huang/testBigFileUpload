//
//  SIMMyRoomViewController.h
//  Kaihuibao
//
//  Created by mac126 on 2018/9/6.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"


@interface SIMMyRoomViewController : SIMBaseViewController

@property (nonatomic, assign) BOOL isLive;
@property (nonatomic, strong) NSString * signType;// 区分是会议 会议室  1 营销客服是4 视频客服是3 直播是4 会议就不传了默认是1
@end
