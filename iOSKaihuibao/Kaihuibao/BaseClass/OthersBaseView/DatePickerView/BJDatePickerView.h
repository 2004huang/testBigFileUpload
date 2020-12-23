//
//  BJDatePicker.h
//  BJDatePicker
//
//  Created by apple-mac on 17/5/23.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BJDatePicker.h"
#import "BJHourPicker.h"
#import "SIMJDatePicker.h"
//有遮盖，添加在window
@interface BJDatePickerView : UIView
/**
 *  单例创建
 */
+(BJDatePickerView*)shareDatePickerView;
/**
 *  实例创建
 */
+(instancetype)datePickerView;
/**
 *  选中日期回调
 *
 *  @param dateSelected 回调
 */
-(void)datePickerViewDidSelected:(dateSelected)dateSelected ;

// 全日期格式的选择器 展示和移除
-(void)show;
-(void)hidden;

// 小时的选择器 展示和移除
-(void)showHour;
-(void)hiddenHour;

// 生日选择器 展示和移除
-(void)showBirthPicker;
-(void)hiddenBirthPicker;


@end
