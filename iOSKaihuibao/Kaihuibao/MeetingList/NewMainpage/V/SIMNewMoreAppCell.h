//
//  SIMNewMoreAppCell.h
//  Kaihuibao
//
//  Created by mac126 on 2018/10/18.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMNModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SIMNewMoreAppCell : UITableViewCell
@property (nonatomic, strong) SIMNModel *model;
@property (nonatomic, copy) void(^indexTagBlock)(NSInteger btnserial);

@end

NS_ASSUME_NONNULL_END
