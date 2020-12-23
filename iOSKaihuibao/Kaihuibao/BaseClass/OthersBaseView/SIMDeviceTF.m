//
//  SIMDeviceTF.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/10/25.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMDeviceTF.h"

@implementation SIMDeviceTF

//控制文本所在的的位置，左右缩 25
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 0);
}
//控制编辑文本时所在的位置，左右缩 25
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 0);
}
@end
