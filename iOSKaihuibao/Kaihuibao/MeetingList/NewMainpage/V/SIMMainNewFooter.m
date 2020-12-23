//
//  SIMMainNewFooter.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/13.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#define Start_Y 5.0f          // 第一个按钮的Y坐标
#define Height_Space 10.0f      // 竖间距


#import "SIMMainNewFooter.h"
@interface SIMMainNewFooter()
@property (nonatomic, assign) CGFloat lastHei;

@end
@implementation SIMMainNewFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _lastHei = 0.00;
        
    }return self;
}
- (void)setArr:(NSArray *)arr {
    _arr = arr;
    
    NSInteger rowNum = _arr.count;
    
    for (int i = 0 ; i < rowNum; i++) {
        NSDictionary *dic = _arr[i];
        
        CGFloat hei = [[dic objectForKey:@"height"] floatValue]/2;
        
        // 圆角按钮
        UIButton *aBt = [[UIButton alloc] init];
        aBt.frame = CGRectMake(0, i  * (kWidthScale(_lastHei) + Height_Space)+Start_Y, screen_width, kWidthScale(hei));
        [aBt sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,dic[@"image"]]] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
        [self addSubview:aBt];
        
        aBt.tag = i;
        [aBt addTarget:self action:@selector(aBtClick:) forControlEvents:UIControlEventTouchUpInside];
    
        _lastHei = hei;
        
    
    }
}

// 图标按钮点击方法
- (void)aBtClick:(UIButton *)sender {
    if (self.picIndexBlock) {
        self.picIndexBlock(sender.tag);
    }
}

@end
