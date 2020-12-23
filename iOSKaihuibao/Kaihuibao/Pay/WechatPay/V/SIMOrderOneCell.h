//
//  SIMOrderOneCell.h
//  Kaihuibao
//
//  Created by mac126 on 2018/10/12.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMPayPlanModel.h"
#import "SIMNewPlanListModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^TabBarDidClickAtIndex)(NSInteger buttonIndex);
@interface SIMOrderOneCell : UITableViewCell
@property (nonatomic, strong) SIMPayPlanModel*model;
@property (strong, nonatomic) SIMNewPlanDetailModel *detailModel;
@property (nonatomic, strong) SIMOptionList *listmodel;
@property(nonatomic,copy)TabBarDidClickAtIndex didClickAtIndex;
@end

NS_ASSUME_NONNULL_END
