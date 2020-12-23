//
//  MSHandler.h
//  framework_objc
//
//  Created by 刘金丰 on 2019/7/2.
//

#import <Foundation/Foundation.h>

#import "RTCRtpEncodingParameters.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MSHandlerConnectionState) {
    MSHandlerConnectionStateNew,
    MSHandlerConnectionStateChecking,
    MSHandlerConnectionStateConnected,
    MSHandlerConnectionStateCompleted,
    MSHandlerConnectionStateFailed,
    MSHandlerConnectionStateDisconnected,
    MSHandlerConnectionStateClosed,
    MSHandlerConnectionStateCount,
};

@class MSHandler;

@protocol MSHandlerDelegate <NSObject>

- (void)OnConnect:(NSDictionary *)dtlsParameters;
- (void)OnConnectionStateChange:(MSHandlerConnectionState)connectionState;


@end

@interface MSHandler : NSObject

+ (instancetype)handler:(id <MSHandlerDelegate>)delegate iceParameters:(NSDictionary *)iceParameters iceCandidates:(NSDictionary *)iceCandidates dtlsParameters:(NSDictionary *)dtlsParameters;

- (void)restartIce:(NSDictionary *)iceParameters;
- (NSDictionary *)getStats;
- (void)updateIceServers:(NSDictionary *)iceServerUris;
- (void)close;
- (void)OnIceConnectionChange:(MSHandlerConnectionState)newState;
+ (NSDictionary *)GetNativeRtpCapabilities;

@end

@interface MSSendHandler : MSHandler

+ (instancetype)handler:(id <MSHandlerDelegate>)delegate
          iceParameters:(NSDictionary *)iceParameters
          iceCandidates:(NSDictionary *)iceCandidates
         dtlsParameters:(NSDictionary *)dtlsParameters
sendingRtpParametersByKind:(NSDictionary *)sendingRtpParametersByKind
sendingRemoteRtpParametersByKind:(NSDictionary *)sendingRemoteRtpParametersByKind;



@end

NS_ASSUME_NONNULL_END
