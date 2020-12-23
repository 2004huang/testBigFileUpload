//
//  SIMNewLiveViewController.h
//  Kaihuibao
//
//  Created by 王小琪 on 2017/10/11.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"
#import "ArrangeConfModel.h"

@interface SIMNewLiveViewController : SIMBaseViewController
@property (nonatomic, strong) NSString *cidStr;
@property (nonatomic, strong) ArrangeConfModel *arrangeConf;
@property (nonatomic, copy) void(^refreshBlock)();
@property (nonatomic, assign) BOOL isTabbar;
@end
