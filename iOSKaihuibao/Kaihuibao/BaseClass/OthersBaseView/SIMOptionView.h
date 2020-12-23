//
//  SIMOptionView.h
//  Kaihuibao
//
//  Created by mac126 on 2019/9/17.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMNewPlanListModel.h"
NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE

@class SIMOptionView;

@protocol SIMOptionViewDelegate <NSObject>

@optional

- (void)optionView:(SIMOptionView *)optionView selectedModel:(SIMOptionList *)listmodel;
//
//- (void)optionView:(SIMOptionView *)optionView chooseArr:(NSString *)choosePidArr;

@end

@interface SIMOptionView : UIView
/**
 标题名
 */
@property (nonatomic, strong) IBInspectable NSString *title;

@property (nonatomic, strong) IBInspectable NSString *imagename;

/**
 标题颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *titleColor;

/**
 标题字体大小
 */
@property (nonatomic, assign) IBInspectable CGFloat titleFontSize;

/**
 视图圆角
 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

/**
 视图边框颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

/**
 边框宽度
 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

/**
 cell高度
 */
@property (nonatomic, assign) CGFloat rowHeigt;

/**
 数据源
 */
@property (nonatomic, strong) NSArray *dataSource;
/**
 是否支持多选 默认是不支持 手动设置为yes可以多选
 */
@property (nonatomic, assign) BOOL isMoreChoose;

@property (nonatomic, weak) id<SIMOptionViewDelegate> delegate;

@property (nonatomic,copy) void(^selectedBlock)(SIMOptionView *optionView,NSInteger selectedIndex);

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource;
@end

NS_ASSUME_NONNULL_END
