//
//  UIImage+Compression.h
//  AFN
//
//  Created by xiaoqi  on 16/8/11.
//  Copyright © 2016年 apple . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compression)

+(UIImage *)imageCompressed:(UIImage *)sourceImage withdefineWidth:(CGFloat)defineWidth ;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithOriginImage:(UIImage *)image scaleToWidth:(CGFloat)defineWidth;
@end
