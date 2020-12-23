//
//  SIMUserLocationAnnotationView.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/12.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMUserLocationAnnotationView.h"
@interface SIMUserLocationAnnotationView ()

@property (nonatomic, strong) CALayer *circleView;

@end

@implementation SIMUserLocationAnnotationView
- (CALayer *)circleView
{
    if (!_circleView) {
        _circleView = [CALayer layer];
        _circleView.frame = CGRectMake(0, 0, self.frame.size.width + 6, self.frame.size.height + 6);
        _circleView.position = self.imageView.center;
        _circleView.backgroundColor = ZJYColorHexWithAlpha(@"#55aaf8",0.4).CGColor;
        _circleView.cornerRadius = _circleView.frame.size.width / 2;
        [self.layer insertSublayer:_circleView below:self.imageView.layer];
    }
    return _circleView;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    [self startAnimate];
}

- (void)startAnimate
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:2.2f];
    animation.autoreverses = YES;
    animation.duration = 1.f;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.circleView addAnimation:animation forKey:nil];
}

- (void)dealloc
{
    NSLog(@"deallocVC %s",__func__);
}

@end
