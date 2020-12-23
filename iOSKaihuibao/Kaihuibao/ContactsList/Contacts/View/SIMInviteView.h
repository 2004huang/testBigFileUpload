//
//  SIMInviteView.h
//  Kaihuibao
//
//  Created by 王小琪 on 17/6/23.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CancelClick)();
typedef void(^InviteClick)();
@interface SIMInviteView : UIView
@property (nonatomic, strong) UIButton *cancel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIButton *inviteBtn;

@property (copy, nonatomic) CancelClick cancelClick;
@property (copy, nonatomic) InviteClick inviteClick;

@end
