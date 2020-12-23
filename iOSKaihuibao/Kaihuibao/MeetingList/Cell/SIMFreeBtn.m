//
//  SIMFreeBtn.m
//  Kaihuibao
//
//  Created by mac126 on 2018/11/2.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMFreeBtn.h"

@implementation SIMFreeBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

//重新布局button的子视图
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(10, 0, self.frame.size.width-20, self.frame.size.width-20);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    //    return CGRectMake(0, self.frame.size.width-12, self.frame.size.width, 20);
    return CGRectMake(0, self.frame.size.width-10, self.frame.size.width, self.frame.size.height-self.frame.size.width+10);
}

@end
