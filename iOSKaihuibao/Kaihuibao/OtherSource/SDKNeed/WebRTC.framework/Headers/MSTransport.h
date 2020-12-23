//
//  MSTransport.h
//  framework_objc
//
//  Created by 刘金丰 on 2019/7/2.
//

#import <Foundation/Foundation.h>
#import "RTCMacros.h"

NS_ASSUME_NONNULL_BEGIN

RTC_OBJC_EXPORT

typedef void (^MSTransportCallback)(NSError *error);
typedef void (^MSSendTransportCallback)(NSString *pid);
@class RTCRtpEncodingParameters;
@class MSProducer;
@class MSConsumer;
@class MSTrack;

@interface MSTransport : NSObject

@property (nonatomic, copy) void (^OnConnect)(MSTransport *transport, NSDictionary *dtlsParameters, MSTransportCallback callback);
@property (nonatomic, copy) void (^OnConnectionStateChange)(MSTransport *transport, NSString *connectionState);

@property (nonatomic, readonly) BOOL isClosed;

- (NSString *)getId;
- (NSString *)getConnectionState;
- (NSDictionary *)getAppData;
- (NSDictionary *)getStats;

- (void)restartIce:(NSDictionary *)iceParameters;
- (void)updateIceServers:(NSDictionary *)iceServers;
- (void)close;

@end

RTC_OBJC_EXPORT
@interface MSSendTransport : MSTransport

@property (nonatomic, copy) void (^OnProduce)(MSSendTransport *transport, NSString *kind, NSDictionary *rtpParameters, NSDictionary *appData, MSSendTransportCallback callback);

- (MSProducer *)createProducer:(MSTrack *)track encodings:(NSArray <RTCRtpEncodingParameters *>* _Nullable)encodings codecOptions:(NSDictionary *)codecOptions appData:(NSDictionary *)appData error:(NSError * _Nullable __autoreleasing *)error;

@end

RTC_OBJC_EXPORT
@interface MSRecvTransport : MSTransport

- (MSConsumer *)createConsumer:(NSString *)cid pid:(NSString *)pid kind:(NSString *)kind rtpParameters:(NSDictionary *)rtpParameters appData:(NSDictionary *)appData error:(NSError * _Nullable __autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
