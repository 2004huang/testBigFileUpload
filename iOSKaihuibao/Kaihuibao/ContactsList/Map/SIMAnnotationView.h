//
//  SIMAnnotationView.h
//  Kaihuibao
//
//  Created by 王小琪 on 17/7/6.
//  Copyright © 2017年 Ferris. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^InviteClick)();
@interface SIMAnnotationView : UIView
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *confId;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UIButton *inviteBtn;

@property (copy, nonatomic) InviteClick inviteClick;
@end
