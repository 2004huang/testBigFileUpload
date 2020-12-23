//
//  UIImage+Interpolated.h
//  TestErweima
//
//  Created by mac126 on 2018/11/9.
//  Copyright © 2018年 mac126. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Interpolated)
/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 *
 *  @return 生成的高清的UIImage
 */
+ (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
