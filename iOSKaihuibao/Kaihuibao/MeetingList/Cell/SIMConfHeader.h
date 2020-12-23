//
//  SIMConfHeader.h
//  Kaihuibao
//
//  Created by 王小琪 on 2017/7/13.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArrangeConfModel.h"
typedef void(^StartClick)();
typedef void(^EditClick)();
typedef void(^SendClick)();

@interface SIMConfHeader : UIView
@property (copy, nonatomic) StartClick startClick;
@property (copy, nonatomic) EditClick editClick;
@property (copy, nonatomic) SendClick sendClick;

@property (nonatomic, strong) UIButton *convenceBtn;
@property (nonatomic, strong) UIButton *send;
@property (nonatomic, strong) UIButton *edit;
@property (nonatomic, strong) ArrangeConfModel *model;
@end
