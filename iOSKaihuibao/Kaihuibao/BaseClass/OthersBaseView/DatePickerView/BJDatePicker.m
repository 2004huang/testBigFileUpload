//
//  BJDatePicker.m
//  BJDatePicker
//
//  Created by 王小琪 on 17/5/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BJDatePicker.h"
#import "NSDate+SIMConvenient.h"
@interface BJDatePicker()
/**
 *  确认按钮size=(50，40)
 */
@property(nonatomic,strong)UIButton*confirmBtn;
/**
 *  datePicker height=186
 */
@property(nonatomic,strong)UIDatePicker*datePicker;
/**
 *  选中回调
 */
@property(nonatomic,copy)dateSelected dateSelected;
@property(nonatomic,copy)changeSelected changeSelected;

/**
 *  选中的时间串
 */
@property(nonatomic,copy)NSString*dateStr;
@end
@implementation BJDatePicker
#pragma mark-----这里修改控件属性-----
-(UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker=[[UIDatePicker alloc] init];
        _datePicker.frame=CGRectMake(0, 40, KDeviceWidth, 186);
        _datePicker.datePickerMode=UIDatePickerModeDateAndTime;
//        _datePicker.minuteInterval = 15;
        [_datePicker addTarget:self action:@selector(changeClicked) forControlEvents:UIControlEventValueChanged];
        
        //设置时间范围
        NSDate*minDate=[[NSDate alloc] initWithTimeIntervalSinceNow:60];
//        NSDate*maxDate=[[NSDate alloc] initWithTimeIntervalSince1970:60*60];
        _datePicker.minimumDate=minDate;
//        _datePicker.maximumDate=maxDate;
        _datePicker.backgroundColor=[UIColor lightGrayColor];
    }
    return _datePicker;
}
-(UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn=[[UIButton alloc] init];
        _confirmBtn.frame=CGRectMake(KDeviceWidth-70,0,50,40);
        [_confirmBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        _confirmBtn.titleLabel.font=FontRegularName(15);
        [_confirmBtn setTitle:SIMLocalizedString(@"NavBackComplete", nil) forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        _confirmBtn.layer.cornerRadius=5;
//        _confirmBtn.layer.masksToBounds=YES;
    }
    return _confirmBtn;
}
#pragma mark----创建-----
 static BJDatePicker* instance;
+(BJDatePicker*)shareDatePicker{
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[BJDatePicker alloc] init];
        });
    }
    return instance;
}
+(instancetype)datePicker{
    return [[self alloc] init];
}
-(instancetype)init{
    if (self=[super init]) {
        [self addSubview:self.datePicker];
        [self addSubview:self.confirmBtn];
        self.backgroundColor=[UIColor colorWithWhite:1 alpha:0.9];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.frame=CGRectMake(0, KDeviceHeight, KDeviceWidth, 226);
    }
    return self;
}

-(void)datePickerDidSelected:(dateSelected)dateSelected{
    self.dateSelected=dateSelected;
}
-(void)changePickerDidSelected:(changeSelected)changeSelected{
    self.changeSelected=changeSelected;
}
#pragma mark----点击事件-----
-(void)BtnClicked:(UIButton*)btn{
    
    
//    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//
//    if ([self.datePicker.date isToday]) {
//        if (self.datePicker.date.hour < 13) {
//           [outputFormatter setDateFormat:SIMLocalizedString(@"TimeTodayAM", nil)];
//        }else if (self.datePicker.date.hour >= 13) {
//            [outputFormatter setDateFormat:SIMLocalizedString(@"TimeTodayPM", nil)];
//        }
//    }else if ([self.datePicker.date isTomorrow]){
//        if (self.datePicker.date.hour < 13) {
//            [outputFormatter setDateFormat:SIMLocalizedString(@"TimeTomorrowAM", nil)];
//        }else if (self.datePicker.date.hour >= 13) {
//            [outputFormatter setDateFormat:SIMLocalizedString(@"TimeTomorrowPM", nil)];
//        }
//    }else if ([self.datePicker.date isAfterTomorrow]){
//        if (self.datePicker.date.hour < 13) {
//            [outputFormatter setDateFormat:SIMLocalizedString(@"TimeAfterTomorrowAM", nil)];
//        }else if (self.datePicker.date.hour >= 13) {
//            [outputFormatter setDateFormat:SIMLocalizedString(@"TimeAfterTomorrowPM", nil)];
//        }
//    }else {
//        if (self.datePicker.date.hour < 13) {
//            [outputFormatter setDateFormat:SIMLocalizedString(@"TimeYearANDdayAM", nil)];
//        }else if (self.datePicker.date.hour >= 13) {
//            [outputFormatter setDateFormat:SIMLocalizedString(@"TimeYearANDdayPM", nil)];
//        }
//    }
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//    [outputFormatter setLocale:locale];
//    self.dateStr=[outputFormatter stringFromDate:self.datePicker.date];
    self.dateStr = [NSString dateTranformDayTimeStrFromTimeStr:self.datePicker.date];
    !self.dateSelected ? :self.dateSelected(self.dateStr,self.datePicker.date);
}
-(void)changeClicked{
//    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//    if ([self.datePicker.date isToday]) {
//        if (self.datePicker.date.hour < 13) {
//            [outputFormatter setDateFormat:SIMLocalizedString(@"TimeTodayAM", nil)];
//        }else if (self.datePicker.date.hour >= 13) {
//            [outputFormatter setDateFormat:SIMLocalizedString(@"TimeTodayPM", nil)];
//        }
//    }else if ([self.datePicker.date isTomorrow]){
//        if (self.datePicker.date.hour < 13) {
//            [outputFormatter setDateFormat:SIMLocalizedString(@"TimeTomorrowAM", nil)];
//        }else if (self.datePicker.date.hour >= 13) {
//            [outputFormatter setDateFormat:SIMLocalizedString(@"TimeTomorrowPM", nil)];
//        }
//    }else if ([self.datePicker.date isAfterTomorrow]){
//        if (self.datePicker.date.hour < 13) {
//            [outputFormatter setDateFormat:SIMLocalizedString(@"TimeAfterTomorrowAM", nil)];
//        }else if (self.datePicker.date.hour >= 13) {
//            [outputFormatter setDateFormat:SIMLocalizedString(@"TimeAfterTomorrowPM", nil)];
//        }
//    }else {
//        if (self.datePicker.date.hour < 13) {
//            [outputFormatter setDateFormat:SIMLocalizedString(@"TimeYearANDdayAM", nil)];
//        }else if (self.datePicker.date.hour >= 13) {
//            [outputFormatter setDateFormat:SIMLocalizedString(@"TimeYearANDdayPM", nil)];
//        }
//    }
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//    [outputFormatter setLocale:locale];
//    self.dateStr=[outputFormatter stringFromDate:self.datePicker.date];
    self.dateStr = [NSString dateTranformDayTimeStrFromTimeStr:self.datePicker.date];
    !self.changeSelected ? :self.changeSelected(self.dateStr,self.datePicker.date);
    
    
}

@end

