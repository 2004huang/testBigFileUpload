//
//  SIMSegmentView.h
//  Kaihuibao
//
//  Created by mac126 on 2018/6/14.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TabBarDidClickAtIndex)(NSInteger buttonIndex);

@interface SIMSegmentView : UIView
@property(nonatomic,copy)TabBarDidClickAtIndex didClickAtIndex;

@property (nonatomic, strong) NSString *titleStr;

-(void)scrollToIndex:(CGFloat)index;
- (void)canSelectedWidthIndex:(CGFloat)index;
- (instancetype)initWithTitles:(NSArray *)titles frame:(CGRect)frame;

@end
