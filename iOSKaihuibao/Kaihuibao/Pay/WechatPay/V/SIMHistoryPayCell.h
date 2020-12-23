//
//  SIMHistoryPayCell.h
//  Kaihuibao
//
//  Created by mac126 on 2018/10/11.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMPayHistoryModel.h"
#import "SIMNewPlanListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SIMHistoryPayCell : UITableViewCell
@property (strong, nonatomic) SIMPayHistoryModel *hismodel;
@property (strong, nonatomic) SIMNewPlanCurrentModel *currentModel;

@end

NS_ASSUME_NONNULL_END
