//
//  MSProducer.h
//  framework_objc
//
//  Created by 刘金丰 on 2019/7/2.
//

#import <Foundation/Foundation.h>
#import "RTCMacros.h"

NS_ASSUME_NONNULL_BEGIN

@class MSTrack;

RTC_OBJC_EXPORT
@interface MSProducer : NSObject

@property (nonatomic, copy) void (^OnTransportClose)(MSProducer* producer);

@property (nonatomic, assign) BOOL isClosed;
@property (nonatomic, assign) BOOL isPaused;

- (instancetype)init NS_UNAVAILABLE;

- (NSString *)getId;
- (NSString *)getLocalId;
- (NSString *)getKind;
- (MSTrack *)getTrack;
- (NSDictionary *)GetRtpParameters;
- (NSInteger)GetMaxSpatialLayer;
- (NSDictionary *)getAppData;
- (NSDictionary *)getStats;

- (void)close;
- (void)pause;
- (void)resume;
- (void)replaceTrack:(MSTrack *)track;
- (void)setMaxSpatialLayer:(NSInteger)spatialLayer;

@end

NS_ASSUME_NONNULL_END
