//
//  SIMHeaderConfView.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/6.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMHeaderConfView.h"
@interface SIMHeaderConfView()

// 标题 会议号  发送按钮 编辑按钮 背景视图 召开按钮
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *confNumber;
@property (nonatomic, strong) UILabel *mytitle;

@end

@implementation SIMHeaderConfView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        
    }return self;
}
- (void)addSubViews {
    // 我的会议室label
    _mytitle = [[UILabel alloc] init];
    _mytitle.textAlignment = NSTextAlignmentCenter;
    _mytitle.font = FontRegularName(17);
    _mytitle.textColor = ZJYColorHex(@"#6b6868");
    [self addSubview:_mytitle];
    
    // 会议号
    _confNumber = [[UILabel alloc] init];
    _confNumber.textColor = BlueButtonColor;
    _confNumber.font = FontRegularName(18);
    _confNumber.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.confNumber];
    
    // 召开会议按钮
    _convenceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _convenceBtn.titleLabel.font = FontRegularName(15);
    [_convenceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_convenceBtn setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_convenceBtn setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    [_convenceBtn setBackgroundColor:EnableButtonColor];
    _convenceBtn.layer.masksToBounds = YES;
    _convenceBtn.layer.cornerRadius = 10;
    _convenceBtn.enabled = NO;
    [self addSubview:self.convenceBtn];
    [_convenceBtn addTarget:self action:@selector(startBtn) forControlEvents:UIControlEventTouchUpInside];
   
    // 观看直播按钮
    _lookLiving = [UIButton buttonWithType:UIButtonTypeCustom];
    _lookLiving.titleLabel.font = FontRegularName(15);
    [_lookLiving setTitleColor:BlueButtonColor forState:UIControlStateNormal];
    [_lookLiving setBackgroundImage:[UIImage imageWithColor:GrayPromptTextColor] forState:UIControlStateHighlighted];
    _lookLiving.layer.borderColor = BlueButtonColor.CGColor;
    _lookLiving.layer.borderWidth = 1;
    _lookLiving.layer.masksToBounds = YES;
    _lookLiving.layer.cornerRadius = 10;
    _lookLiving.enabled = NO;
    [self addSubview:self.lookLiving];
    [_lookLiving addTarget:self action:@selector(lookLiveBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    _mytitle.sd_layout.centerXEqualToView(self).topSpaceToView(self,20).widthIs(screen_width).heightIs(20);
    _confNumber.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(_mytitle,15).heightIs(15);
    _convenceBtn.sd_layout.heightIs(40).topSpaceToView(_confNumber,15).leftSpaceToView(self, kWidthScale(40)).rightSpaceToView(self,kWidthScale(40));
    _lookLiving.sd_layout.heightIs(40).topSpaceToView(_convenceBtn,10).leftSpaceToView(self, kWidthScale(40)).rightSpaceToView(self,kWidthScale(40));
//    _edit.sd_layout.rightEqualToView(_convenceBtn).topSpaceToView(_convenceBtn,15).widthIs(60).heightIs(20);
    
    
}
- (void)videoServceSubviews {
    // 我的会议室label
    _mytitle = [[UILabel alloc] init];
    _mytitle.textAlignment = NSTextAlignmentCenter;
    _mytitle.font = FontRegularName(17);
    _mytitle.textColor = ZJYColorHex(@"#6b6868");;
    [self addSubview:_mytitle];
    
    // 会议号
    _confNumber = [[UILabel alloc] init];
    _confNumber.textColor = BlueButtonColor;
    _confNumber.font = FontRegularName(18);
    _confNumber.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.confNumber];
    
    // 召开会议按钮
    _convenceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _convenceBtn.titleLabel.font = FontRegularName(15);
    [_convenceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_convenceBtn setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_convenceBtn setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    [_convenceBtn setBackgroundColor:EnableButtonColor];
    _convenceBtn.layer.masksToBounds = YES;
    _convenceBtn.layer.cornerRadius = 10;
    _convenceBtn.enabled = NO;
    [self addSubview:self.convenceBtn];
    [_convenceBtn addTarget:self action:@selector(startBtn) forControlEvents:UIControlEventTouchUpInside];
    
    _mytitle.sd_layout.centerXEqualToView(self).topSpaceToView(self,20).widthIs(screen_width).heightIs(20);
    _confNumber.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(_mytitle,15).heightIs(15);
    _convenceBtn.sd_layout.heightIs(40).topSpaceToView(_confNumber,15).leftSpaceToView(self, kWidthScale(40)).rightSpaceToView(self,kWidthScale(40));
    
}
- (void)setSignType:(NSString *)signType {
    _signType = signType;
    // 区分是会议 会议室  1 营销客服是4 视频客服是3 直播是4 会议就不传了默认是1
    if ([_signType isEqualToString:@"3"]) {
        // 营销客服 3
    }else if ([_signType isEqualToString:@"2"]) {
        // 客服视频 2
        [self videoServceSubviews];
        _mytitle.text = SIMLocalizedString(@"MMainConfVideoSupport", nil); // 我的直播间
        [_convenceBtn setTitle:SIMLocalizedString(@"SConfSMessStartTheVideoSer", nil) forState:UIControlStateNormal]; // 开始客服
    }else {
        [self addSubViews];
        if ([_signType isEqualToString:@"4"]) {
            // 直播 4
            _mytitle.text = SIMLocalizedString(@"MMainConfLiveIDtitle", nil); // 我的直播间
            [_convenceBtn setTitle:SIMLocalizedString(@"MMainLiveStartNewBtn", nil) forState:UIControlStateNormal]; // 开始直播
            [_lookLiving setTitle:SIMLocalizedString(@"PLivingTileLookTheLive", nil) forState:UIControlStateNormal];// 观看直播
//            [_edit setTitle:SIMLocalizedString(@"MMessEditLiveTitle", nil) forState:UIControlStateNormal];
        }else {
            // 会议 1
            _mytitle.text = SIMLocalizedString(@"MMainConfMineIDtitle", nil);// 我的会议室
            
            [_lookLiving setTitle:SIMLocalizedString(@"PLivingTileLookTheLive", nil) forState:UIControlStateNormal];// 观看直播
            [_convenceBtn setTitle:SIMLocalizedString(@"MMainConfStartNewBtn", nil) forState:UIControlStateNormal];// 开始会议
//            [_edit setTitle:SIMLocalizedString(@"MMessEditConfTitle", nil) forState:UIControlStateNormal];
        }
    }
    
}
- (void)setMyServiceConf:(SIMMyServiceVideo *)myServiceConf {
    _myServiceConf = myServiceConf;
    // 截取会议号 变成带-的形式
    _confNumber.text = [NSString transTheConfIDToTheThreeApart:_myServiceConf.cid];
}
- (void)setConfM:(ArrangeConfModel *)confM {
    _confM = confM;
    NSString *string;
    // 截取会议号 变成带-的形式
    
//    if (_confM.live_id == nil) {
string = self.currentUser.self_conf;
//        string = _confM.live_id;
//    }else {
    
        //        string = _confM.conf_id;
//    }
    _confNumber.text = [NSString transTheConfIDToTheThreeApart:string];
}

// 召开会议按钮响应方法 block传值
- (void)startBtn {
    if (self.btnClick) {
        self.btnClick();
    }
}

// 编辑按钮响应方法 block传值
- (void)editBtn {
    if (self.editClick) {
        self.editClick();
    }
}
// 观看直播按钮响应
- (void)lookLiveBtn {
    if (self.lookClick) {
        self.lookClick();
    }
}

@end
