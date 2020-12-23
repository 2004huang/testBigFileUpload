//
//  SIMOrderChooseCountCell.h
//  Kaihuibao
//
//  Created by mac126 on 2019/9/11.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMOptionView.h"
#import "SIMNewPlanListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SIMOrderChooseCountCell : UITableViewCell
@property (strong, nonatomic) SIMNewPlanDetailModel *detailModel;
@property (strong,nonatomic) SIMOptionView *optionView;
@property (strong,nonatomic) UITextField *textF;
@property (strong,nonatomic) NSArray *arr;

- (instancetype)initWithViewController:(UIViewController<SIMOptionViewDelegate> *)viewController;

@end

NS_ASSUME_NONNULL_END
