//
//  SIMTextField.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/6/5.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMTextField.h"

@implementation SIMTextField
//控制文本所在的的位置，左右缩 25
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 15, 0);
}
//控制编辑文本时所在的位置，左右缩 25
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 15, 0);
}


@end
