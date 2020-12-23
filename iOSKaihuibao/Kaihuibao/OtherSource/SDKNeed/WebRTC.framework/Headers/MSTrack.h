//
//  MSTrack.h
//  sources
//
//  Created by 刘金丰 on 2019/7/2.
//

#import <Foundation/Foundation.h>
#import "RTCMacros.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MSTrackState) {
    MSTrackStateLive,
    MSTrackStateEnded
};

typedef NS_ENUM(NSInteger, MSTrackType) {
    MSTrackTypeUnknow,
    MSTrackTypeAudio,
    MSTrackTypeVideo
};

@class RTCMediaStreamTrack;

RTC_OBJC_EXPORT
@interface MSTrack : NSObject

@property(nonatomic, readonly) NSString *kind;

@property(nonatomic, readonly) MSTrackType type;

@property(nonatomic, readonly) NSString *trackId;

@property(nonatomic, assign) BOOL isEnabled;

@property(nonatomic, readonly) MSTrackState readyState;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithTrack:(RTCMediaStreamTrack *)rtcTrack;

- (id)getRtcTrack;

@end

NS_ASSUME_NONNULL_END
