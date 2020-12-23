//
//  EditMyConfViewController.h
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/24.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"
#import "ArrangeConfModel.h"
@interface EditMyConfViewController : SIMBaseViewController
@property (nonatomic, strong) ArrangeConfModel *myConf;
@property (nonatomic, assign) BOOL isLive;
@end
