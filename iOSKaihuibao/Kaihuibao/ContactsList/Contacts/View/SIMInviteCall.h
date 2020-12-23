//
//  SIMInviteCall.h
//  Kaihuibao
//
//  Created by mac126 on 2018/4/23.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^VoiceClick)();
typedef void(^VideoClick)();
typedef void(^JoinClick)();
typedef void(^AfterClick)();
typedef void(^IgnorClick)();

@interface SIMInviteCall : UIView
@property (copy, nonatomic) VoiceClick voiceClick;
@property (copy, nonatomic) VideoClick videoClick;
@property (copy, nonatomic) JoinClick joinClick;
@property (copy, nonatomic) AfterClick afterClick;
@property (copy, nonatomic) IgnorClick ignorClick;

@end
