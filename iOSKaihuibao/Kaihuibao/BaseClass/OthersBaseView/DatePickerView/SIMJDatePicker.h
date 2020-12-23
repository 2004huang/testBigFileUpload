//
//  SIMJDatePicker.h
//  JianshenBao
//
//  Created by mac126 on 2019/3/20.
//  Copyright © 2019年 Ferris. All rights reserved.
//
//weakSelf
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define KDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//height=226 无遮盖(可替代键盘使用)
typedef void(^dateSelected)(NSString*date,NSDate *dateOne);
typedef void(^changeSelected)(NSString*date,NSDate *dateOne);
typedef void(^cancelSelected)();

@interface SIMJDatePicker : UIView
/**
 *  单例创建
 */
+(SIMJDatePicker*)shareDatePicker;
/**
 *  实例创建
 */
+(instancetype)datePicker;

/**
 *  选中日期回调
 */
-(void)datePickerDidSelected:(dateSelected)dateSelected;
-(void)changePickerDidSelected:(changeSelected)changeSelected;
-(void)cancelPickerDidSelected:(cancelSelected)cancelSelected;
@end

NS_ASSUME_NONNULL_END
