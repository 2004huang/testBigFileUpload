//
//  SIMSendView.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/6.
//  Copyright © 2018年 Ferris. All rights reserved.
//
#define Start_X 10.0f + (screen_width - Button_Width * 5 - 20)/6           // 第一个按钮的X坐标
#define Start_Y 60.0f          // 第一个按钮的Y坐标
#define Width_Space (screen_width - Button_Width * 5 - 20)/6        // 2个按钮之间的横间距
#define Height_Space 15.0f      // 竖间距
#define Button_Height kWidthS(75)    // 高
#define Button_Width kWidthS(70)      // 宽

#import "SIMSendView.h"
#import "SIMMeetBtn.h"

@interface SIMSendView()
@property (nonatomic, strong) UILabel *mytitle;

@end

@implementation SIMSendView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubViews];
        
    }return self;
}
- (void)setArray:(NSArray *)array {
    _array = array;
    _mytitle.text = SIMLocalizedString(@"MMainConfSendMineIDtitle", nil); // 发送会议邀请
    for (int i = 0 ; i < _array.count; i++) {
        NSInteger index = i % 5;
        NSInteger page = i / 5;
        
        // 按钮
        SIMMeetBtn *aBt = [[SIMMeetBtn alloc] init];
        [aBt setTitle:[_array[i] objectForKey:@"title"] forState:UIControlStateNormal];
        [aBt setImage:[UIImage imageNamed:[_array[i] objectForKey:@"icon"]] forState:UIControlStateNormal];
        aBt.imageView.contentMode = UIViewContentModeCenter;
        aBt.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        
        aBt.titleLabel.font = FontRegularName(14);
        aBt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [aBt setTitleColor:ZJYColorHex(@"#6b6868") forState:UIControlStateNormal];
        [self addSubview:aBt];
        aBt.tag = [[_array[i] objectForKey:@"serial"] integerValue];
        [aBt addTarget:self action:@selector(aBtClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)addSubViews {
    // 我的会议室label
    _mytitle = [[UILabel alloc] init];
    _mytitle.textAlignment = NSTextAlignmentCenter;
    _mytitle.font = FontRegularName(17);
    _mytitle.textColor = ZJYColorHex(@"#6b6868");;
    [self addSubview:_mytitle];
    _mytitle.sd_layout.centerXEqualToView(self).topSpaceToView(self,20).widthIs(screen_width).heightIs(20);
    
}

- (void)aBtClick:(UIButton *)sender {
    if (self.indexTagBlock) {
        self.indexTagBlock(sender.tag);
    }
}

@end
