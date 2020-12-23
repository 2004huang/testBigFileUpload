//
//  ChatViewController.h
//  TUIKitDemo
//
//  Created by kennethmiao on 2018/10/10.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "SIMBaseViewController.h"
#import "TChatController.h"

@interface ChatViewController : SIMBaseViewController
@property (nonatomic, assign) BOOL isConfVC;
@property (nonatomic, strong) TConversationCellData *conversation;
@end
