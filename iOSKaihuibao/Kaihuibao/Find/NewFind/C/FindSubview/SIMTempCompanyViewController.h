//
//  SIMTempCompanyViewController.h
//  Kaihuibao
//
//  Created by mac126 on 2018/10/18.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"
#import "SIMMessNotiModel.h"
#import "SIMFootImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SIMTempCompanyViewController : SIMBaseViewController
@property (nonatomic, assign) BOOL hasShare;
@property (nonatomic, assign) BOOL isPresent;
@property (nonatomic, strong) NSString *webStr;
@property (nonatomic, strong) SIMMessNotiDetailModel *model;
@property (nonatomic, assign) BOOL mainShare;
@property (nonatomic, strong) SIMFootImageModel *imageModel;

@end

NS_ASSUME_NONNULL_END
