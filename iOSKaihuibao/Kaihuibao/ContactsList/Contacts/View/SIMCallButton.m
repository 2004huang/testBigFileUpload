//
//  SIMCallButton.m
//  Kaihuibao
//
//  Created by mac126 on 2018/4/24.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMCallButton.h"

@implementation SIMCallButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        //         self.backgroundColor = [UIColor whiteColor];
        //        [self setTitleColor:TableViewHeaderColor forState:UIControlStateNormal];
        //        self.titleLabel.font = FontRegularName(13];
        //        self.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        //        self.layer.borderWidth = 0.5;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

//重新布局button的子视图
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    //    CGFloat h = 40.0;
    //    CGFloat w = 40.0;
    //    CGFloat x = (self.frame.size.width - w)/2.0;
    //    CGFloat y = self.frame.size.height * 0.5 - h;
    CGFloat h = 30.0;
    CGFloat w = 40.0;
    CGFloat x = (self.frame.size.width - w)/2.0;
    CGFloat y = 10.0;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, self.frame.size.height - 15, self.frame.size.width, 10);
}

@end
