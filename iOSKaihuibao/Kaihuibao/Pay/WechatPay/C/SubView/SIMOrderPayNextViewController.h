//
//  SIMOrderPayNextViewController.h
//  Kaihuibao
//
//  Created by mac126 on 2018/10/12.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"
#import "SIMPayPlanModel.h"
#import "SIMNewPlanListModel.h"
#import "SIMNowServiceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SIMOrderPayNextViewController : SIMBaseViewController
//@property (nonatomic, strong) SIMPayPlanModel*model;
@property (nonatomic, strong) SIMNewPlanListModel *model;
@property (nonatomic, strong) SIMNowServiceModel *nowSModel; // 如果是续费的话 那么用这个订单id请求详情
@property (nonatomic, strong) NSString *type; // 类型计划是plan device是device
@property (nonatomic, strong) NSString *teachID; // 教学模式

@end

NS_ASSUME_NONNULL_END
