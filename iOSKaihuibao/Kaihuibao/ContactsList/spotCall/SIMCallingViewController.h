//
//  SIMCallingViewController.h
//  Kaihuibao
//
//  Created by mac126 on 2018/4/12.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"
#import "SIMContants.h"
#import "SIMAdress.h"
@interface SIMCallingViewController : SIMBaseViewController
@property (nonatomic, strong) SIMContants *person;
@property (nonatomic, strong) TIMMessage * msg;

//@property (nonatomic, strong) SIMAdress *adress;
@property (nonatomic, strong) NSString *kindOfCall;// 标记呼叫的类型是语音还是视频
@end
