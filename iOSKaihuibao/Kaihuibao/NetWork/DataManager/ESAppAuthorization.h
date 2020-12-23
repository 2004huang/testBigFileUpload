//
//  ESAppAuthorization.h
//  XCLive
//
//  Created by Elvis on 2017/11/7.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESAppAuthorization : NSObject

+ (void)getCellularNetworkAuthorizationWithBlcok:(void(^)(int state))block;

@end
