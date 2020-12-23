//
//  ConfMessageViewController.h
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/23.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"
#import "ArrangeConfModel.h"
@interface ConfMessageViewController : SIMBaseViewController
@property (nonatomic, assign) BOOL popType;
@property (nonatomic, strong) NSString *confMessID;
@property (nonatomic, strong) ArrangeConfModel *confMess;
@property (nonatomic, strong) NSString * signType;// 区分是会议 会议室  1 营销客服是4 视频客服是3  会议就不传了默认是1
@property (nonatomic, strong) NSString *teachIDStr;// 教学的ID
@property (nonatomic, strong) NSString *teachorConfStr;// 教学列表里是显示教学还是会议
@property (nonatomic, copy) void(^refreshBlock)();
@end
