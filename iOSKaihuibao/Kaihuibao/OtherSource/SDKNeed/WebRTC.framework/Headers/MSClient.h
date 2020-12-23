//
//  MSClient.h
//  framework_objc
//
//  Created by 刘金丰 on 2019/7/2.
//

#import <Foundation/Foundation.h>

#import "RTCMacros.h"

NS_ASSUME_NONNULL_BEGIN

RTC_OBJC_EXPORT
@interface MSClient : NSObject

+ (void)Initialize;
+ (void)Cleanup;
+ (NSString *)Version;
+ (NSDictionary *)GetParseScalabilityMode:(NSString *)scalabilityMode;

@end

NS_ASSUME_NONNULL_END
