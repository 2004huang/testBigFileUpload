//
//  BJHourPicker.h
//  Testdata
//
//  Created by 王小琪 on 17/5/23.
//  Copyright © 2017年 apple. All rights reserved.
//
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define KDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height

#import <UIKit/UIKit.h>

typedef void(^dateSelected)(NSString*date,NSDate *dateOne);
typedef void(^changeSelected)(NSString*date,NSDate *dateOne);

@interface BJHourPicker : UIView

@property (nonatomic, strong) NSDate *current;

/**
 *  单例创建
 */
+(BJHourPicker*)shareDatePicker;
/**
 *  实例创建
 */
+(instancetype)datePicker;

/**
 *  选中日期回调
 */
-(void)datePickerDidSelected:(dateSelected)dateSelected;
-(void)changePickerDidSelected:(changeSelected)changeSelected;

@end
