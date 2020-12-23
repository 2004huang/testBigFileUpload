//
//  SIMAppSettingViewController.h
//  Kaihuibao
//
//  Created by mac126 on 2019/9/25.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^RefreshClick)();
@interface SIMAppSettingViewController : SIMBaseViewController
@property (copy, nonatomic) RefreshClick refreshClick;
@end

NS_ASSUME_NONNULL_END
