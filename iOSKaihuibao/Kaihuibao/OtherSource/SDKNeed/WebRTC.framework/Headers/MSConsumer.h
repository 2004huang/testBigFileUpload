//
//  MSConsumer.h
//  framework_objc
//
//  Created by 刘金丰 on 2019/7/2.
//

#import <Foundation/Foundation.h>
#import "RTCMacros.h"


NS_ASSUME_NONNULL_BEGIN

@class MSTrack;

RTC_OBJC_EXPORT
@interface MSConsumer : NSObject

@property (nonatomic, copy) void (^OnTransportClose)(MSConsumer* consumer);

@property (nonatomic, assign) BOOL isClosed;
@property (nonatomic, assign) BOOL isPaused;

- (instancetype)init NS_UNAVAILABLE;

- (NSString *)getId;
- (NSString *)getLocalId;
- (NSString *)getProducerId;
- (NSString *)getKind;
- (MSTrack *)getTrack;
- (NSDictionary *)getRtpParameters;
- (NSDictionary *)getAppData;
- (NSDictionary *)getStats;

- (void)close;
- (void)pause;
- (void)resume;

@end

NS_ASSUME_NONNULL_END
