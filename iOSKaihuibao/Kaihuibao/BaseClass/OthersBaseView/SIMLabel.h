//
//  SIMLabel.h
//  Kaihuibao
//
//  Created by 王小琪 on 2017/7/11.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;
@interface SIMLabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}
@property (nonatomic) VerticalAlignment verticalAlignment;  

//两端对齐

- (void)textAlignmentLeftAndRight;



//指定Label的width两端对齐

- (void)textAlignmentLeftAndRightWith:(CGFloat)labelWidth;

@end
