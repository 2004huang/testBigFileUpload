//
//  SIMPayNewSegment.h
//  Kaihuibao
//
//  Created by mac126 on 2018/10/11.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TabBarDidClickAtIndex)(NSInteger buttonIndex);


@interface SIMPayNewSegment : UIScrollView
@property(nonatomic,copy)TabBarDidClickAtIndex didClickAtIndex;


-(void)scrollToIndex:(CGFloat)index;
- (void)canSelectedWidthIndex:(CGFloat)index;
- (instancetype)initWithTitles:(NSArray *)titles frame:(CGRect)frame selectIndex:(NSInteger)index hasLine:(BOOL)ishas;

@end

NS_ASSUME_NONNULL_END
