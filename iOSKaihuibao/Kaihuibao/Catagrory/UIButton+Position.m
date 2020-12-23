//
//  UIButton+Position.m
//  Kaihuibao
//
//  Created by mac126 on 2018/2/6.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "UIButton+Position.h"

@implementation UIButton (Position)
- (void)verticalImageAndTitle:(CGFloat)spacing
{
//    self.titleLabel.backgroundColor = [UIColor greenColor];
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
//    CGSize textSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:self.titleLabel.text
     attributes:@
     {
     NSFontAttributeName: self.titleLabel.font
     }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){CGFLOAT_MAX, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize textSize = rect.size;
    
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    
}
@end
