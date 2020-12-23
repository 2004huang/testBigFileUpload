//
//  BJDatePicker.h
//  BJDatePicker
//
//  Created by apple-mac on 17/5/23.
//  Copyright © 2017年 wxq. All rights reserved.
//

#import "BJDatePickerView.h"
@interface BJDatePickerView()
@property (nonatomic, strong) BJDatePicker *datePicker;
@property (nonatomic, strong) BJHourPicker *hourPicker;
@property (nonatomic, strong) SIMJDatePicker *birthPicker;

/**
 *  选中回调
 */
@property(nonatomic,copy)dateSelected dateSelected;
@end
@implementation BJDatePickerView

-(BJDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker=[BJDatePicker datePicker];
        WS(ws);
        [_datePicker datePickerDidSelected:^(NSString *date,NSDate *dateOne) {
         
            !ws.dateSelected?: ws.dateSelected(date,dateOne);
             [ws hidden];
        }];
        [_datePicker changePickerDidSelected:^(NSString *date,NSDate *dateOne) {
            !ws.dateSelected?: ws.dateSelected(date,dateOne);
        }];
    }
    return _datePicker;
}
- (BJHourPicker *)hourPicker{
    if (!_hourPicker) {
        _hourPicker=[BJHourPicker datePicker];
        WS(ws);
        [_hourPicker datePickerDidSelected:^(NSString *date,NSDate *dateOne) {
            
            !ws.dateSelected?: ws.dateSelected(date,dateOne);
            [ws hiddenHour];
        }];
        [_hourPicker changePickerDidSelected:^(NSString *date,NSDate *dateOne) {
            !ws.dateSelected?: ws.dateSelected(date,dateOne);
        }];
    }
    return _hourPicker;
}
-(SIMJDatePicker *)birthPicker{
    if (!_birthPicker) {
        _birthPicker = [SIMJDatePicker datePicker];
        WS(ws);
        [_birthPicker datePickerDidSelected:^(NSString *date,NSDate *dateOne) {
            
            !ws.dateSelected?: ws.dateSelected(date,dateOne);
            [ws hidden];
        }];
        [_birthPicker changePickerDidSelected:^(NSString *date,NSDate *dateOne) {
            !ws.dateSelected?: ws.dateSelected(date,dateOne);
        }];
        [_birthPicker cancelPickerDidSelected:^{
            [ws hidden];
        }];
    }
    return _birthPicker;
}

#pragma mark----创建-----
 static BJDatePickerView* instance;
+(BJDatePickerView*)shareDatePickerView{
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[BJDatePickerView alloc] init];
        });
    }
    return instance;
}

+(instancetype)datePickerView{
    return [[self alloc] init];
}
-(instancetype)init{
    if (self=[super init]) {
//        [self addSubview:self.datePicker];
//        [self addSubview:self.hourPicker];
  
    }
    return self;
}
-(void)datePickerViewDidSelected:(dateSelected)dateSelected{
    self.dateSelected=dateSelected;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hidden];
    [self hiddenHour];
    [self hiddenBirthPicker];
}

-(void)show{
    [self addSubview:self.datePicker];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    self.frame=self.superview.bounds;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.datePicker.frame=CGRectMake(0, KDeviceHeight-226, KDeviceWidth, 226);
    }];
}


-(void)hidden{
    [UIView animateWithDuration:0.25f animations:^{
        self.datePicker.frame=CGRectMake(0, KDeviceHeight, KDeviceWidth, 226);
       
    } completion:^(BOOL finished) {
        [self.datePicker removeFromSuperview];
        [self removeFromSuperview];
        
    }];
}


-(void)showHour{
    [self addSubview:self.hourPicker];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    self.frame=self.superview.bounds;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.hourPicker.frame=CGRectMake(0, KDeviceHeight-226, KDeviceWidth, 226);
    }];
}


-(void)hiddenHour{
    [UIView animateWithDuration:0.25f animations:^{
        self.hourPicker.frame=CGRectMake(0, KDeviceHeight, KDeviceWidth, 226);
        
    } completion:^(BOOL finished) {
        [self.hourPicker removeFromSuperview];
        [self removeFromSuperview];
    }];
}

-(void)showBirthPicker{
    [self addSubview:self.birthPicker];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    self.frame=self.superview.bounds;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.birthPicker.frame=CGRectMake(0, KDeviceHeight-226, KDeviceWidth, 226);
    }];
}


-(void)hiddenBirthPicker{
    [UIView animateWithDuration:0.25f animations:^{
        self.birthPicker.frame=CGRectMake(0, KDeviceHeight, KDeviceWidth, 226);
        
    } completion:^(BOOL finished) {
        [self.birthPicker removeFromSuperview];
        [self removeFromSuperview];
        
    }];
}

@end
