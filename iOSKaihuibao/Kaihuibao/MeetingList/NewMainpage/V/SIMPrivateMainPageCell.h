//
//  SIMPrivateMainPageCell.h
//  Kaihuibao
//
//  Created by mac126 on 2019/6/17.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMNModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SIMPrivateMainPageCell : UITableViewCell
@property (nonatomic, strong) SIMNModel *model;

@property (nonatomic, copy) void(^indexTagBlock)(NSInteger btnserial);// 图标按钮点击方法


@end

NS_ASSUME_NONNULL_END
