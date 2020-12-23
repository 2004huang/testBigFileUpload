//
//  CLMediaLogger.h
//  CinLanMedia
//
//  Created by 刘金丰 on 2019/7/12.
//  Copyright © 2019 Liujinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CLMediaLoggerSeverity) {
    CLMediaLoggerSeverityNone,
    CLMediaLoggerSeverityInfo,
    CLMediaLoggerSeverityWarning,
    CLMediaLoggerSeverityError,
    CLMediaLoggerSeverityVerbose
};

@interface CLMediaLogger : NSObject

+ (instancetype)Logger;

- (void)setLoggerSeverity:(CLMediaLoggerSeverity)severity;




@end

NS_ASSUME_NONNULL_END
