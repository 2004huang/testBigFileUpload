//
//  SIMNetSettingViewController.h
//  Kaihuibao
//
//  Created by 王小琪 on 2017/8/25.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"
typedef void(^RefreshClick)();
@interface SIMNetSettingViewController : SIMBaseViewController
@property (copy, nonatomic) RefreshClick refreshClick;
@end
