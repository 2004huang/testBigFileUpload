//
//  NSObject+CloudVersion.h
//  Kaihuibao
//
//  Created by mac126 on 2019/6/14.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIMCloudVersion.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CloudVersion)
@property (nonatomic, strong) SIMCloudVersion *cloudVersion;

- (void)synchroinzeCloudVersion;
@end

NS_ASSUME_NONNULL_END
