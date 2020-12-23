//
//  SIMNewPlanListCell.h
//  Kaihuibao
//
//  Created by mac126 on 2019/5/21.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMNewPlanListModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^BtnClick)();
@interface SIMNewPlanListCell : UITableViewCell
@property (copy, nonatomic) BtnClick btnClick; // 点击了查看计划按钮
@property (strong, nonatomic)SIMNewPlanListModel *model;
@end

NS_ASSUME_NONNULL_END
