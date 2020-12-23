//
//  MSDevice.h
//  framework_objc
//
//  Created by 刘金丰 on 2019/7/2.
//

#import <Foundation/Foundation.h>
#import "RTCMacros.h"

NS_ASSUME_NONNULL_BEGIN

@class MSTransport;
@class MSSendTransport;
@class MSRecvTransport;

RTC_OBJC_EXPORT
@interface MSDevice : NSObject

@property (nonatomic, assign, readonly) BOOL isLoaded;

+ (instancetype)device;

- (void)load:(NSDictionary *)routerRtpCapabilities error:(NSError * _Nullable __autoreleasing *)error;

- (NSDictionary *)GetRtpCapabilities;
- (BOOL)canProduce:(NSString *)kind;

- (MSSendTransport *)CreateSendTransport:(NSString *)tid
                           iceParameters:(NSDictionary *)iceParameters
                           iceCandidates:(NSDictionary *)iceCandidates
                          dtlsParameters:(NSDictionary *)dtlsParameters
                                 appData:(NSDictionary *)appData
                                   error:(NSError * _Nullable __autoreleasing *)error;

- (MSRecvTransport *)CreateRecvTransport:(NSString *)tid
                           iceParameters:(NSDictionary *)iceParameters
                           iceCandidates:(NSDictionary *)iceCandidates
                          dtlsParameters:(NSDictionary *)dtlsParameters
                                 appData:(NSDictionary *)appData
                                   error:(NSError * _Nullable __autoreleasing *)error;


@end

NS_ASSUME_NONNULL_END
