//
//  SIMConfHeader.h
//  Kaihuibao
//
//  Created by 王小琪 on 2017/7/13.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BtnClick)();
typedef void(^EditClick)();
typedef void(^SendClick)();
typedef void(^ThreeBackClick)();
typedef void(^OneBtn)();
typedef void(^TwoBtn)();
typedef void(^ThreeBtn)();
typedef void(^FourBtn)();
typedef void(^FiveBtn)();
typedef void(^SixBtn)();
typedef void(^StartClick)();
typedef void(^FiveVideoBtn)();
typedef void(^SixVideoBtn)();

@interface SIMConfVideoHeader : UIView
@property (copy, nonatomic) BtnClick btnClick;
@property (copy, nonatomic) EditClick editClick;
@property (copy, nonatomic) SendClick sendClick;
@property (copy, nonatomic) ThreeBackClick threeBackClick;
@property (copy, nonatomic) OneBtn oneBtn;
@property (copy, nonatomic) TwoBtn twoBtn;
@property (copy, nonatomic) ThreeBtn threeBtn;
@property (copy, nonatomic) FourBtn fourBtn;
@property (copy, nonatomic) FiveBtn fiveBtn;
@property (copy, nonatomic) SixBtn sixBtn;
@property (copy, nonatomic) StartClick startClick;
@property (copy, nonatomic) FiveBtn fiveVideoBtn;
@property (copy, nonatomic) SixBtn sixVideoBtn;

@property (nonatomic, strong) UIButton *convenceBtn;
@property (nonatomic, strong) UIButton *send;
@property (nonatomic, strong) UIButton *edit;
@property (nonatomic, strong) UIButton *start;//新增的视频咨询点击进入按钮
@property (nonatomic, strong) UIButton *start2;//原有的支持中心点击进入按钮
@end
