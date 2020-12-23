//
//  SampleHandler.m
//  ScreenRecorder
//
//  Created by mac126 on 2019/7/26.
//  Copyright © 2019 Ferris. All rights reserved.
//


#import "SampleHandler.h"
#import <CinLanMedia/CinLanMedia.h>


@implementation SampleHandler

- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo {
    // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
    [[CLMediaScreenShare share] startWithGroupIdentifier:@"group.kaihuibao.screenrecorder" delegate:self];
}

- (void)broadcastPaused {
    // User has requested to pause the broadcast. Samples will stop being delivered.
    [[CLMediaScreenShare share] pause];
}

- (void)broadcastResumed {
    // User has requested to resume the broadcast. Samples delivery will resume.
    [[CLMediaScreenShare share] resume];
}

- (void)broadcastFinished {
    // User has requested to finish the broadcast.
    [[CLMediaScreenShare share] stop];
}

- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    
    switch (sampleBufferType) {
        case RPSampleBufferTypeVideo:
            // Handle video sample buffer
            [[CLMediaScreenShare share] inputVideoSampleBuffer:sampleBuffer];
            break;
        case RPSampleBufferTypeAudioApp:
            // Handle audio sample buffer for app audio
            break;
        case RPSampleBufferTypeAudioMic:
            // Handle audio sample buffer for mic audio
            break;
            
        default:
            break;
    }
}

@end
