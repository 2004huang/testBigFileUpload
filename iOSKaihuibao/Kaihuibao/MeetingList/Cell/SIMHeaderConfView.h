//
//  SIMHeaderConfView.h
//  Kaihuibao
//
//  Created by mac126 on 2018/9/6.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SIMMyConf.h"
#import "ArrangeConfModel.h"
#import "SIMMyServiceVideo.h"

typedef void(^BtnClick)();
typedef void(^EditClick)();
typedef void(^LookClick)();

@interface SIMHeaderConfView : UIView

@property (copy, nonatomic) BtnClick btnClick;
@property (copy, nonatomic) EditClick editClick;
@property (copy, nonatomic) LookClick lookClick;

//@property (nonatomic, strong) SIMMyConf *confM;
@property (nonatomic, strong) ArrangeConfModel *confM;

@property (nonatomic, strong) UIButton *convenceBtn;
@property (nonatomic, strong) UIButton *edit;

@property (nonatomic, strong) UIButton *lookLiving;

@property (nonatomic, strong) NSString * signType;// 区分是会议 会议室  1 营销客服是4 视频客服是3 直播是4 会议就不传了默认是1
@property (nonatomic, strong) SIMMyServiceVideo *myServiceConf;

@end
