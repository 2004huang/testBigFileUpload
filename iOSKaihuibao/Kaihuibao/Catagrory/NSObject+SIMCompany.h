//
//  NSObject+SIMCompany.h
//  Kaihuibao
//
//  Created by 王小琪 on 2019/4/1.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIMCompany.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SIMCompany)
@property (nonatomic, strong) SIMCompany *currentCompany;

- (void)synchroinzeCurrentCompany;

@end

NS_ASSUME_NONNULL_END
