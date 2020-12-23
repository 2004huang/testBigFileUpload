//
//  SIMButton.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/27.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMButton.h"

@implementation SIMButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:ZJYColorHex(@"#666666") forState:UIControlStateNormal];
        self.titleLabel.font = FontRegularName(12);
        
        self.imageView.layer.cornerRadius = (self.frame.size.width-20)/2.0;
        self.imageView.layer.masksToBounds = YES;
        
        
        
    }
    return self;
}



//重新布局button的子视图
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat w = self.frame.size.width-20;
    CGFloat h = w;
    CGFloat x = (self.frame.size.width - w)/2.0;
    CGFloat y = self.frame.size.height * 0.1;
    return CGRectMake(x, y, w, h);
    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(2, self.frame.size.height*0.75, self.frame.size.width-5, self.frame.size.height*0.2);
}

@end
