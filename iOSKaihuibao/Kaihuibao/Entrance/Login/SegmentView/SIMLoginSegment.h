//
//  SIMLoginSegment.h
//  Kaihuibao
//
//  Created by mac126 on 2019/4/26.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^SegmentDidClickAtIndex)(NSInteger buttonIndex);

@interface SIMLoginSegment : UIView
@property(nonatomic, copy)SegmentDidClickAtIndex didClickAtIndex;


-(void)scrollToIndex:(CGFloat)index;
- (void)canSelectedWidthIndex:(CGFloat)index;
- (instancetype)initWithTitles:(NSArray *)titles frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
