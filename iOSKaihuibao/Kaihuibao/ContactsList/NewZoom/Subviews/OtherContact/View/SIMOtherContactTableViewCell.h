//
//  SIMOtherContactTableViewCell.h
//  Kaihuibao
//
//  Created by mac126 on 2019/5/14.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SIMContants.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^AddBnClick)();

@interface SIMOtherContactTableViewCell : UITableViewCell
@property (nonatomic, strong) SIMContants *contants;
@property (nonatomic, copy) AddBnClick addBnClick;
@property (nonatomic, assign) BOOL ishaveBtn;// 有没有邀请按钮
@end

NS_ASSUME_NONNULL_END
