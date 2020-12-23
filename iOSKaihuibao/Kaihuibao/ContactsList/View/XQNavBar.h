//
//  XQNavBar.h
//  ZAKER
//
//  Created by 王小琪 on 17/1/26.
//  Copyright © 2017年 王小琪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TabBarDidClickAtIndex)(NSInteger buttonIndex);

@interface XQNavBar : UIView
@property(nonatomic,copy)TabBarDidClickAtIndex didClickAtIndex;

@property (nonatomic, strong) NSString *titleStr;


//- (instancetype)initWithTitles:(NSArray *)titles frame:(CGRect)frame titleColor:(UIColor *)titleColor;
-(void)scrollToIndex:(CGFloat)index;
- (void)canSelectedWidthIndex:(CGFloat)index;
- (instancetype)initWithTitles:(NSArray *)titles frame:(CGRect)frame titleColor:(UIColor *)titleColor isDev:(BOOL)isDev;

@end
