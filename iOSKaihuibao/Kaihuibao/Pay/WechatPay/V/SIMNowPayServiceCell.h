//
//  SIMNowPayServiceCell.h
//  Kaihuibao
//
//  Created by mac126 on 2019/9/18.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMNowServiceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SIMNowPayServiceCell : UITableViewCell
@property (nonatomic, strong) SIMNowServiceModel *model;
@property (nonatomic, copy) void(^buttonCilckBlock)(NSInteger btnserial);
@end

NS_ASSUME_NONNULL_END
