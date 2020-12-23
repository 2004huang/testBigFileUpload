//
//  SIMMessNotifListViewController.h
//  Kaihuibao
//
//  Created by mac126 on 2019/10/29.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SIMMessNotifListViewController : SIMBaseViewController
@property (nonatomic, strong) NSString *classification_id;
@property (nonatomic, assign) BOOL isConfVC;
@property (nonatomic, assign) BOOL isCloudSpace;
@end

NS_ASSUME_NONNULL_END
