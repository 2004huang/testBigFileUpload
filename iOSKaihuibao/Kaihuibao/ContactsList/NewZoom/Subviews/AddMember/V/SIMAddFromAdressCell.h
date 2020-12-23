//
//  SIMAddFromAdressCell.h
//  Kaihuibao
//
//  Created by mac126 on 2019/7/9.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SIMContants.h"

NS_ASSUME_NONNULL_BEGIN
//typedef void(^AddBnClick)();
@interface SIMAddFromAdressCell : UITableViewCell
//@property (copy, nonatomic) AddBnClick addBnClick;
@property (nonatomic, strong) SIMContants *contants;// 人员模型

@end

NS_ASSUME_NONNULL_END
