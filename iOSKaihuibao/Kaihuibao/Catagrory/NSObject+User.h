//
//  NSObject+User.h
//  Tictalk
//
//  Created by Draveness on 6/5/16.
//  Copyright © 2016 Tictalkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCUser.h"

@interface NSObject (User)

@property (nonatomic, strong) CCUser *currentUser;

- (void)synchroinzeCurrentUser;

@end
