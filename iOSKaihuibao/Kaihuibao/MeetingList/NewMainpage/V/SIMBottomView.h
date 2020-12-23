//
//  SIMBottomView.h
//  Kaihuibao
//
//  Created by mac126 on 2019/5/16.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMNewPlanListModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^BtnClick)();
typedef void(^WellBeingBtnClick)();

@interface SIMBottomView : UIView
@property (nonatomic, strong) NSString *buttonType;
@property (nonatomic, copy) BtnClick btnClick;
@property (nonatomic, copy) WellBeingBtnClick wellBeingBtnClick;
@property (nonatomic, strong) SIMNewPlanCurrentModel *model;
@property (nonatomic, strong) NSDictionary *dic;
@end

NS_ASSUME_NONNULL_END
