//
//  NSString+SIMColor.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/6/18.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "NSString+SIMColor.h"

@implementation NSString (SIMColor)
+(NSString*)toStrByUIColor:(UIColor*)color{
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    int rgb = (int) (r * 255.0f)<<16 | (int) (g * 255.0f)<<8 | (int) (b * 255.0f)<<0;
    return [NSString stringWithFormat:@"%06x", rgb];
}
@end
