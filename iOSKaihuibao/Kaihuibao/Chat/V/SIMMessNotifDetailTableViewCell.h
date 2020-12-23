//
//  SIMMessNotifDetailTableViewCell.h
//  Kaihuibao
//
//  Created by mac126 on 2019/10/29.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMMessNotiModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^StartClick)();

@interface SIMMessNotifDetailTableViewCell : UITableViewCell
@property (copy, nonatomic) StartClick startClick;
@property (strong, nonatomic) SIMMessNotiDetailModel *model;
@end

NS_ASSUME_NONNULL_END
