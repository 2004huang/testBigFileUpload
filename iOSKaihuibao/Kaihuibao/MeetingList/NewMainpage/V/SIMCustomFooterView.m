//
//  SIMCustomFooterView.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/17.
//  Copyright © 2018年 Ferris. All rights reserved.
//
#define Button_Height 70.0f    // 高
#define Button_Width 80.0f      // 宽
#define Start_X  (screen_width - Button_Width * 3)/4           // 第一个按钮的X坐标
#define Start_Y 10.0f          // 第一个按钮的Y坐标
#define Width_Space (screen_width - Button_Width * 3)/4        // 2个按钮之间的横间距
#define Height_Space 10.0f      // 竖间距

#import "SIMCustomFooterView.h"
#import "SIMMeetBtn.h"

@interface SIMCustomFooterView()
@property (nonatomic, strong) NSMutableArray *tempButtonArray;

@end
@implementation SIMCustomFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
    }return self;
}
- (void)setArr:(NSArray *)arr {
    _arr = arr;
    // for循环创建的button加到arr里在每次布局前移除
    if (self.tempButtonArray.count > 0) {
        [self.tempButtonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    for (int i = 0 ; i < arr.count; i++) {
        NSInteger index = i % 3;
        NSInteger page = i / 3;
        NSDictionary *dic = arr[i];
        SIMMeetBtn *aBt = [[SIMMeetBtn alloc] init];
        [aBt setTitle:dic[@"titleName"] forState:UIControlStateNormal];
        [aBt setImage:[UIImage imageNamed:dic[@"bannerPic"]] forState:UIControlStateNormal];
        aBt.imageView.contentMode = UIViewContentModeCenter;
        aBt.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        aBt.tag = i;
        aBt.titleLabel.font = FontRegularName(12);
        aBt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [aBt setTitleColor:ZJYColorHex(@"#333333") forState:UIControlStateNormal];
        [self addSubview:aBt];
        [aBt addTarget:self action:@selector(aBtClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tempButtonArray addObject:aBt];
        
    }
    
}
// 图标按钮点击方法
- (void)aBtClick:(UIButton *)sender {
    if (self.indexTagBlock) {
        self.indexTagBlock(sender.tag);
    
    }
}


- (NSMutableArray *)tempButtonArray{
    if (!_tempButtonArray) {
        _tempButtonArray = [NSMutableArray array];
    }
    return _tempButtonArray;
}


@end
