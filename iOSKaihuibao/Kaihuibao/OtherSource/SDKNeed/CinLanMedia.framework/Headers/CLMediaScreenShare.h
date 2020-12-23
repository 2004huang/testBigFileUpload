//
//  CLMediaScreenShare.h
//  CinLanMedia
//
//  Created by 刘金丰 on 2019/7/17.
//  Copyright © 2019 Liujinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReplayKit/ReplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLMediaScreenShare : NSObject

+ (instancetype)share;
- (void)startWithGroupIdentifier:(NSString *)identifier delegate:(RPBroadcastSampleHandler *)delegate API_AVAILABLE(ios(12.0));
- (void)stop;
- (void)pause;
- (void)resume;

- (void)inputVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end

NS_ASSUME_NONNULL_END
