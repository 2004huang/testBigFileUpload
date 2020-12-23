//
//  WebviewProgressLine.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/10/11.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "WebviewProgressLine.h"

@implementation WebviewProgressLine
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    self.backgroundColor = lineColor;
}

-(void)startLoadingAnimation{
    self.hidden = NO;
    self.width = 0.0;
    
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        weakSelf.width = screen_width * 0.6;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.width = screen_width * 0.8;
        }];
    }];
    
    
}

-(void)endLoadingAnimation{
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.width = screen_width;
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
}

@end
