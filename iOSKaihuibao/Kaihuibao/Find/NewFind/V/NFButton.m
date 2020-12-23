//
//  NFButton.m
//  Kaihuibao
//
//  Created by mac126 on 2018/6/7.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "NFButton.h"

@implementation NFButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

//重新布局button的子视图
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat h = 40.0;
    CGFloat w = 40.0;
    CGFloat x = 20;
    CGFloat y = (self.frame.size.height - h)/2.0;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(80, 0, self.frame.size.width - 80.0, self.frame.size.height);
}

@end
