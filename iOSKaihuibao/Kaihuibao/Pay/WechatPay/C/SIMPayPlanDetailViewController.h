//
//  SIMPayPlanDetailViewController.h
//  Kaihuibao
//
//  Created by mac126 on 2018/10/11.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"
#import "SIMPayPlanModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SIMPayPlanDetailViewController : SIMBaseViewController
@property (nonatomic, strong) SIMPayPlanModel *model;// 用于接受正常的model
@property (nonatomic, strong) SIMPayPlanModel *modelLast; // 用于接受多的那个vipmodel
@property (nonatomic, assign) NSInteger indexStr; // 用于默认选中那个 和上一页同步
@property (nonatomic, assign) NSInteger pageIndex; // 是视频会议还是直播还是客服和营销
@end

NS_ASSUME_NONNULL_END
