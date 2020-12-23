//
//  SIMNewPlanChossen.h
//  Kaihuibao
//
//  Created by mac126 on 2018/10/31.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TabBarDidClickAtIndex)(NSInteger buttonIndex);

@interface SIMNewPlanChossen : UIView
@property(nonatomic,copy)TabBarDidClickAtIndex didClickAtIndex;

@property (nonatomic, strong) NSString *titleStr;


//- (instancetype)initWithTitles:(NSArray *)titles frame:(CGRect)frame titleColor:(UIColor *)titleColor;
-(void)scrollToIndex:(CGFloat)index;
- (void)canSelectedWidthIndex:(CGFloat)index;
- (instancetype)initWithTitles:(NSArray *)titles frame:(CGRect)frame selectIndex:(NSInteger)index hasLine:(BOOL)ishas hasSlider:(BOOL)isslider;
@end

NS_ASSUME_NONNULL_END
