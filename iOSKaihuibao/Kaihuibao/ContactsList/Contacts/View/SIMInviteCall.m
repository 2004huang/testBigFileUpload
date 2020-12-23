//
//  SIMInviteCall.m
//  Kaihuibao
//
//  Created by mac126 on 2018/4/23.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMInviteCall.h"
#import "XQButton.h"
#import "SIMCallButton.h"

@interface SIMInviteCall()
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *hostMan;
@property (nonatomic, strong) UILabel *confNumber;

@property (nonatomic, strong) SIMCallButton *vioceBtn;
@property (nonatomic, strong) XQButton *videoBtn;
@property (nonatomic, strong) UIButton *joinBtn;
@property (nonatomic, strong) UIButton *afterBtn;
@property (nonatomic, strong) UIButton *ignorBtn;

@end

@implementation SIMInviteCall

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        
        [self twoBackView];
        [self addBtns];
        
    }return self;
}

- (void)twoBackView {
    _title = [[UILabel alloc] init];
    _title.text = [NSString stringWithFormat:@"%@的会议",self.currentUser.nickname];
    _title.font =FontRegularName(16);
    _title.textColor = ZJYColorHex(@"#333333");
    _title.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.title];
    
    _timeLab = [[UILabel alloc] init];
    _timeLab.text = @"12:00-13:00";
    _timeLab.font =FontRegularName(15);
    _timeLab.textColor = ZJYColorHex(@"#828282");
    _timeLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.timeLab];
    
    _hostMan = [[UILabel alloc] init];
    _hostMan.text = [NSString stringWithFormat:@"主持人：%@",self.currentUser.nickname];
    _hostMan.font =FontRegularName(15);
    _hostMan.textColor = ZJYColorHex(@"#828282");
    _hostMan.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.hostMan];
    
    // 会议号
    _confNumber = [[UILabel alloc] init];
    _confNumber.textColor = ZJYColorHex(@"#828282");
    _confNumber.font = FontRegularName(16);
    _confNumber.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.confNumber];
    
    // 截取会议号 变成带-的形式
    _confNumber.text = [NSString stringWithFormat:@"会议ID：%@",[NSString transTheConfIDToTheThreeApart:self.currentUser.self_conf]];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(50);
        make.height.mas_equalTo(15);
    }];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(_title.mas_bottom).offset(15);
        make.height.mas_equalTo(15);
    }];
    [_hostMan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(_timeLab.mas_bottom).offset(15);
        make.height.mas_equalTo(15);
    }];
    [_confNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(_hostMan.mas_bottom).offset(15);
        make.height.mas_equalTo(15);
    }];
    
    
    
}
- (void)addBtns {
    // 音频
    _vioceBtn = [[SIMCallButton alloc] init];
    _vioceBtn.titleLabel.font = FontRegularName(12);
    [_vioceBtn setTitleColor:ZJYColorHex(@"#C6C6C6") forState:UIControlStateNormal];
    [_vioceBtn setTitle:@"自动连接音频" forState:UIControlStateNormal];
    [_vioceBtn setImage:[UIImage imageNamed:@"切换语音或者视频"] forState:UIControlStateNormal];
    [_vioceBtn setTitleColor:ZJYColorHex(@"#555555") forState:UIControlStateNormal];
    
    [_vioceBtn addTarget:self action:@selector(vioceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_vioceBtn];
    
    // 视频
    _videoBtn = [[XQButton alloc] init];
    _videoBtn.titleLabel.font = FontRegularName(12);
    [_videoBtn setTitleColor:ZJYColorHex(@"#C6C6C6") forState:UIControlStateNormal];
    [_videoBtn setTitle:@"视频" forState:UIControlStateNormal];
    [_videoBtn setImage:[UIImage imageNamed:@"视频-互动黑框"] forState:UIControlStateNormal];
    [_videoBtn setTitleColor:ZJYColorHex(@"#555555") forState:UIControlStateNormal];
    
    [_videoBtn addTarget:self action:@selector(videoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_videoBtn];
    
    // 加入
    _joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_joinBtn setTitle:@"加入会议" forState:UIControlStateNormal];
    [_joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_joinBtn setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_joinBtn setBackgroundColor:BlueButtonColor];
    [_joinBtn setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    
    [_joinBtn addTarget:self action:@selector(joinMeetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _joinBtn.titleLabel.font = FontRegularName(22);
    _joinBtn.layer.masksToBounds = YES;
    _joinBtn.layer.cornerRadius = 8;
    [self addSubview:_joinBtn];
    
    
    // 稍后提醒
    _afterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _afterBtn.titleLabel.font = FontRegularName(15);
    [_afterBtn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
    _afterBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    registerBT.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_afterBtn setTitle:@"稍后提醒" forState:UIControlStateNormal];
    [_afterBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_afterBtn addTarget:self action:@selector(afterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_afterBtn];
    
    // 忽略
    _ignorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ignorBtn.titleLabel.font = FontRegularName(15);
    [_ignorBtn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
    _ignorBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_ignorBtn setTitle:@"忽略" forState:UIControlStateNormal];
    [_ignorBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_ignorBtn addTarget:self action:@selector(ignoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_ignorBtn];
    
    
    
    [_joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-kWidthScale(80));
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
    }];
    
    [_ignorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_joinBtn.mas_bottom).offset(kWidthScale(15));
//        make.width.mas_equalTo((screen_width - 90)/3);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);
    }];
    
    [_afterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_joinBtn.mas_bottom).offset(kWidthScale(15));
        make.left.mas_equalTo(20);
//        make.width.mas_equalTo((screen_width - 90)/3);
        make.height.mas_equalTo(20);
        
    }];
    
    [_vioceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_joinBtn.mas_top).offset(-kWidthScale(30));
        make.right.mas_equalTo(self.mas_centerX).offset(-kWidthScale(45));
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(95);
    }];
    
    [_videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_joinBtn.mas_top).offset(-kWidthScale(30));
        make.left.mas_equalTo(self.mas_centerX).offset(kWidthScale(45));
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(100);
    }];
    
}


- (void)joinMeetBtnClick {
    if (self.joinClick) {
        self.joinClick();
    }
}
- (void)afterBtnClick {
    if (self.afterClick) {
        self.afterClick();
    }
}
- (void)ignoreBtnClick {
    if (self.ignorClick) {
        self.ignorClick();
    }
}
- (void)videoBtnClick {
    if (self.videoClick) {
        self.videoClick();
    }
}
- (void)vioceBtnClick {
    if (self.voiceClick) {
        self.voiceClick();
    }
}
@end
