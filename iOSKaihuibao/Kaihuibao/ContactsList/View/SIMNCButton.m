//
//  SIMNCButton.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/8.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMNCButton.h"

@implementation SIMNCButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self.imageView.backgroundColor = [UIColor yellowColor];
        self.backgroundColor = [UIColor whiteColor];
        
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
    return CGRectMake(0, self.frame.size.height-70, self.frame.size.width, 26);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, self.frame.size.height-35, self.frame.size.width, 15);
}


@end
