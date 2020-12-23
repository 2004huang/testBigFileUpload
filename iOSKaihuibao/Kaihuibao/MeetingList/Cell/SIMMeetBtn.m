//
//  SIMMeetBtn.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/8/3.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMMeetBtn.h"

@implementation SIMMeetBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
//        self.titleLabel.numberOfLines = 2;
    }
    return self;
}

//重新布局button的子视图
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
//    CGFloat w = self.frame.size.width-kWidthScale(16);
//    CGFloat h = w;
//    CGFloat x = (self.frame.size.width - w)/2.0;
//    CGFloat y = self.frame.size.height * 0.15;
//    return CGRectMake(10, 0, self.frame.size.width-20, self.frame.size.width-20);
    return CGRectMake(10, 0, self.frame.size.width-20, self.frame.size.width-20);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
//    return CGRectMake(0, self.frame.size.width-12, self.frame.size.width, 20);
    return CGRectMake(0, self.frame.size.height-15, self.frame.size.width, 15);
}

@end
