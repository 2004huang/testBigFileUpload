//
//  SIMSendMapViewController.h
//  Kaihuibao
//
//  Created by mac126 on 2019/8/9.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol SIMSendMapViewDelegate <NSObject>

- (void)buttonNowLoactionWithLat:(double)latitude andLon:(double)longitude locationStr:(NSString *)locationStr;
@end

@interface SIMSendMapViewController : SIMBaseViewController
@property (nonatomic, assign) id <SIMSendMapViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
