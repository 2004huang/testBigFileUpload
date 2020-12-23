//
//  ESAppAuthorization.m
//  XCLive
//
//  Created by Elvis on 2017/11/7.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "ESAppAuthorization.h"
#import <CoreTelephony/CTCellularData.h>

@implementation ESAppAuthorization

+ (void)getCellularNetworkAuthorizationWithBlcok:(void (^)(int state))block{
//    dispatch_async(dispatch_get_main_queue(), ^{
        CTCellularData *cellular = [[CTCellularData alloc] init];
        cellular.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState cellularState) {
            int state = 0;
            switch (cellularState) {
                case kCTCellularDataNotRestricted:
                {
                    NSLog(@"not restricted");
                    state = 1;
                }
                    break;
                case kCTCellularDataRestricted:
                {
                    NSLog(@"restricted");
                }
                    break;
                case kCTCellularDataRestrictedStateUnknown:
                {
                    NSLog(@"unknown");
                    state = 2;
                }
                    break;
                default:
                    break;
            }
            block(state);
        };
//    });
}
@end
