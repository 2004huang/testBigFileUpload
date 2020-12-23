//
//  SIMOrderThreeCell.h
//  Kaihuibao
//
//  Created by mac126 on 2018/10/12.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMPayPlanModel.h"
#import "SIMNewPlanListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SIMOrderThreeCell : UITableViewCell
@property (nonatomic, strong) NSString *types;
@property (nonatomic, strong) NSArray*arr;
@property (nonatomic, assign) BOOL isUpPlan;
@property (nonatomic, strong) SIMPayPlanModel*model;
@property (strong, nonatomic) SIMNewPlanDetailModel *detailModel;
@property (strong, nonatomic) SIMOptionList *listmodel;
@property (strong, nonatomic) NSString *nameStr;


@end

NS_ASSUME_NONNULL_END
