//
//  SIMConfHeader.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/7/13.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#define Start_X  (screen_width - Button_Width * 3)/6   // 第一个按钮的X坐标
#define Start_Y 15.0f          // 第一个按钮的Y坐标

#define Button_Height 75.0f    // 高
#define Button_Width 70.0f      // 宽

#define Width_Space (screen_width - Button_Width * 3)/6  // 2个按钮之间的横间距
#define Height_Space 15.0f      // 竖间距

#define One_count 3      // 一行有几个按钮

//const float abc = 123.2;// 

#import "SIMConfVideoHeader.h"
#import "SIMMeetBtn.h"

typedef NS_ENUM(NSInteger, MyButtonType) {
    MyButtonTypeJoinMeet = 1000,
    MyButtonTypeArrangeMeet,
    MyButtonTypeNewLive,
    MyButtonTypeUserManger,
    MyButtonTypeConfManager,
    MyButtonTypeAccountManger,
};

@interface SIMConfVideoHeader()

// 标题 会议号  发送按钮 编辑按钮 背景视图 召开按钮
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *confNumber;

// 自定义视图的父视图 每个白色模块都是一个背景白色主view
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *backView2;
@property (nonatomic, strong) UIView *backView3;
@property (nonatomic, strong) UIView *backView4;

// 时间 标题 会议ID 开始会议按钮 （这个是新增的视频咨询条目的）
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *title2;
@property (nonatomic, strong) UILabel *detail;

// 时间 标题 会议ID 开始会议按钮 （这个是原有的的支持中心的）
@property (nonatomic, strong) UIImageView *icon2;
@property (nonatomic, strong) UILabel *title3;
@property (nonatomic, strong) UILabel *detail2;


@end

@implementation SIMConfVideoHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = TableViewBackgroundColor;

        [self twoBackView];
        
        [self threeBackView];
        
        [self fourBackView];
        
    }return self;
}

- (void)twoBackView {
    // 白色背景
    _backView2 = [[UIView alloc] init];
    _backView2.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backView2];
    
    NSArray *image = @[@"main视频",@"main添加",@"main时间",@"main日历",@"main圆角矩形",@"main通讯录"];
    
    NSArray *textLabel = @[SIMLocalizedString(@"MMainConfHeaderStartAMeeting", nil),SIMLocalizedString(@"MMainConfHeaderJoin", nil),SIMLocalizedString(@"MMainConfHeaderMineConf", nil),SIMLocalizedString(@"MMainConfHeaderSchedule", nil),SIMLocalizedString(@"MMainConfHeaderLive", nil),SIMLocalizedString(@"MMainConfHeaderAdress", nil)];

    NSUInteger rowNum = (textLabel.count + 2) / One_count;
    _backView2.sd_layout.leftEqualToView(self).rightEqualToView(self).topEqualToView(self).heightIs((Button_Height + Height_Space) * rowNum + Start_Y);
    for (int i = 0 ; i < textLabel.count; i++) {
        NSInteger index = i % One_count;
        NSInteger page = i / One_count;
        
        // 圆角按钮
        SIMMeetBtn *aBt = [[SIMMeetBtn alloc] init];
        [aBt setTitle:textLabel[i] forState:UIControlStateNormal];
        [aBt setImage:[UIImage imageNamed:image[i]] forState:UIControlStateNormal];
        aBt.frame = CGRectMake(index * (Button_Width + Width_Space *2) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        
        aBt.titleLabel.font = FontRegularName(13);
        aBt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [aBt setTitleColor:ZJYColorHex(@"#333333") forState:UIControlStateNormal];
        [_backView2 addSubview:aBt];
        aBt.tag = i + MyButtonTypeJoinMeet;
        [aBt addTarget:self action:@selector(aBtClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)threeBackView {
    // 白色背景
    _backView3 = [[UIView alloc] init];
    _backView3.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backView3];
    _backView3.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(_backView2,10).heightIs(60);
    _backView3.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackThree)];
    [_backView3 addGestureRecognizer:tap];
    
    _icon = [[UIImageView alloc] init];
    _icon.layer.cornerRadius = 20;
    _icon.layer.masksToBounds = YES;
    _icon.image = [UIImage imageNamed:@"mainPageView_VideoServer"];
    _icon.backgroundColor = ZJYColorHex(@"#E8E8E8");
    [_backView3 addSubview:_icon];
    // 主标题label
    _title2 = [[UILabel alloc] init];
    _title2.text = SIMLocalizedString(@"MMainConfVideoSupport", nil);
    _title2.font =FontRegularName(16);
    _title2.textColor = ZJYColorHex(@"#333333");
    _title2.textAlignment = NSTextAlignmentLeft;
    [_backView3 addSubview:self.title2];
    // 会议号label
    _detail = [[UILabel alloc] init];
    _detail.textColor = ZJYColorHex(@"#666666");
    _detail.font = FontRegularName(13);
    _detail.text = @"275-7823-1060";
    _detail.textAlignment = NSTextAlignmentLeft;
    [_backView3 addSubview:self.detail];
    
    // 开始进入支持中心按钮
    _start = [UIButton buttonWithType:UIButtonTypeCustom];
    [_start setTitle:SIMLocalizedString(@"MMessSupportINConf", nil) forState:UIControlStateNormal];
    _start.titleLabel.font = FontRegularName(13);
    [_start setBackgroundColor:[UIColor whiteColor]];
    [_start setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_start setBackgroundImage:[UIImage imageWithColor:GrayPromptTextColor] forState:UIControlStateHighlighted];
    [_start setTitleColor:BlueButtonColor forState:UIControlStateNormal];
    _start.layer.borderWidth = 1;
    _start.layer.borderColor = BlueButtonColor.CGColor;
    _start.layer.cornerRadius = 7;
    _start.layer.masksToBounds = YES;
    [self addSubview:self.start];
    [_start addTarget:self action:@selector(enterBtn) forControlEvents:UIControlEventTouchUpInside];
    
    _icon.sd_layout.leftSpaceToView(self.backView3,15).centerYEqualToView(self.backView3).widthIs(40).heightIs(40);
    _title2.sd_layout.leftSpaceToView(_icon,15).topSpaceToView(_backView3,8).heightIs(20).rightSpaceToView(_backView3,90);
    _detail.sd_layout.heightIs(15).topSpaceToView(_title2,8).leftEqualToView(_title2).rightSpaceToView(self.backView3,80);
    _start.sd_layout.rightSpaceToView(self,20).heightIs(28).widthIs(55).centerYEqualToView(_backView3);
    
}

- (void)fourBackView {
    // 白色背景
    _backView4 = [[UIView alloc] init];
    _backView4.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backView4];
    _backView4.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(_backView3,10).heightIs(60);
    _backView4.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackFour)];
    [_backView4 addGestureRecognizer:tap];
    
    _icon2 = [[UIImageView alloc] init];
    _icon2.layer.cornerRadius = 20;
    _icon2.layer.masksToBounds = YES;
    _icon2.image = [UIImage imageNamed:@"会议_21"];
    _icon2.backgroundColor = ZJYColorHex(@"#E8E8E8");
    [_backView4 addSubview:_icon2];
    // 主标题label
    _title3 = [[UILabel alloc] init];
    _title3.text = SIMLocalizedString(@"MMainConfSupport", nil);
    _title3.font =FontRegularName(16);
    _title3.textColor = ZJYColorHex(@"#333333");
    _title3.textAlignment = NSTextAlignmentLeft;
    [_backView4 addSubview:self.title3];
    // 会议号label
    _detail2 = [[UILabel alloc] init];
    _detail2.textColor = ZJYColorHex(@"#666666");
    _detail2.font = FontRegularName(13);
    _detail2.text = @"971-3535-4231";
    _detail2.textAlignment = NSTextAlignmentLeft;
    [_backView4 addSubview:self.detail2];
    
    // 开始进入支持中心按钮
    _start2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_start2 setTitle:SIMLocalizedString(@"MMessSupportINConf", nil) forState:UIControlStateNormal];
    _start2.titleLabel.font = FontRegularName(13);
    [_start2 setBackgroundColor:[UIColor whiteColor]];
    [_start2 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_start2 setBackgroundImage:[UIImage imageWithColor:GrayPromptTextColor] forState:UIControlStateHighlighted];
    [_start2 setTitleColor:BlueButtonColor forState:UIControlStateNormal];
    _start2.layer.borderWidth = 1;
    _start2.layer.borderColor = BlueButtonColor.CGColor;
    _start2.layer.cornerRadius = 7;
    _start2.layer.masksToBounds = YES;
    [self addSubview:self.start2];
    [_start2 addTarget:self action:@selector(enterVideoBtn) forControlEvents:UIControlEventTouchUpInside];
    
    _icon2.sd_layout.leftSpaceToView(self.backView4,15).centerYEqualToView(self.backView4).widthIs(40).heightIs(40);
    _title3.sd_layout.leftSpaceToView(_icon2,15).topSpaceToView(_backView4,8).heightIs(20).rightSpaceToView(_backView4,90);
    _detail2.sd_layout.heightIs(15).topSpaceToView(_title3,8).leftEqualToView(_title3).rightSpaceToView(self.backView4,80);
    _start2.sd_layout.rightSpaceToView(self,20).heightIs(28).widthIs(55).centerYEqualToView(_backView4);
    
}

// 编辑按钮响应方法 block传值
- (void)editBtn {
    if (self.editClick) {
        self.editClick();
    }
}
// 发送邀请按钮响应方法 block传值
- (void)sendBtn {
    if (self.sendClick) {
        self.sendClick();
    }
}

// 召开会议按钮响应方法 block传值
- (void)startBtn {
    if (self.btnClick) {
        self.btnClick();
    }
}
// 开始进入视频客服按钮block 一个是按钮一个是背景view点击手势
- (void)enterBtn {
    if (self.startClick) {
        self.startClick();
    }
}
- (void)tapBackThree {
    if (self.threeBackClick) {
        self.threeBackClick();
    }
}
// 开始进入支持中心按钮block 一个是按钮一个是背景view点击手势
- (void)enterVideoBtn {
    if (self.fiveVideoBtn) {
        self.fiveVideoBtn();
    }
}
- (void)tapBackFour {
    if (self.sixVideoBtn) {
        self.sixVideoBtn();
    }
}

- (void)aBtClick:(UIButton *)sender {
    if (sender.tag==MyButtonTypeJoinMeet) {
        if (self.oneBtn) {
            self.oneBtn();
        }
    }else if (sender.tag==MyButtonTypeArrangeMeet) {
        if (self.twoBtn) {
            self.twoBtn();
        }
    }else if (sender.tag==MyButtonTypeNewLive) {
        if (self.threeBtn) {
            self.threeBtn();
        }
    }else if (sender.tag==MyButtonTypeUserManger) {
        if (self.fourBtn) {
            self.fourBtn();
        }
    }else if (sender.tag==MyButtonTypeConfManager) {
        if (self.fiveBtn) {
            self.fiveBtn();
        }
    }else if (sender.tag==MyButtonTypeAccountManger) {
        if (self.sixBtn) {
            self.sixBtn();
        }
    }



}

@end
