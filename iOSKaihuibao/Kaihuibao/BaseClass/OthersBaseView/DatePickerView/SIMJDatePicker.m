//
//  SIMJDatePicker.m
//  JianshenBao
//
//  Created by mac126 on 2019/3/20.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMJDatePicker.h"
#import "NSDate+SIMConvenient.h"

@interface SIMJDatePicker()
/**
 *  确认按钮size=(50，40)
 */
@property(nonatomic,strong)UIButton *confirmBtn;
@property(nonatomic,strong)UIButton *cancelBtn;
/**
 *  datePicker height=186
 */
@property(nonatomic,strong)UIDatePicker *datePicker;
/**
 *  选中回调
 */
@property(nonatomic,copy)dateSelected dateSelected;
@property(nonatomic,copy)changeSelected changeSelected;
@property(nonatomic,copy)cancelSelected cancelSelected;

/**
 *  选中的时间串
 */
@property(nonatomic,copy)NSString*dateStr;
@end

@implementation SIMJDatePicker
#pragma mark-----这里修改控件属性-----
-(UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker=[[UIDatePicker alloc] init];
        _datePicker.frame=CGRectMake(0, 40, KDeviceWidth, 186);
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(changeClicked) forControlEvents:UIControlEventValueChanged];
        
        NSCalendar *currentCalendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc]init];
        components.year = 1990;
        components.month = 05;
        components.day = 20;
        NSDate *aDate = [currentCalendar dateFromComponents:components];
        _datePicker.date = aDate; // 选择器默认选中在1990.05这一行
        //设置时间范围
//        NSDate*minDate=[[NSDate alloc] initWithTimeIntervalSinceNow:60];
//        NSDate*maxDate=[[NSDate alloc] initWithTimeIntervalSince1970:60*60];
//        _datePicker.minimumDate=minDate;
//        _datePicker.maximumDate = maxDate;
        _datePicker.backgroundColor=[UIColor whiteColor];
    }
    return _datePicker;
}
-(UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn=[[UIButton alloc] init];
        _confirmBtn.frame=CGRectMake(KDeviceWidth-70,0,50,40);
        [_confirmBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font=FontRegularName(15);
        [_confirmBtn setTitle:SIMLocalizedString(@"AlertCOk", nil) forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn=[[UIButton alloc] init];
        _cancelBtn.frame=CGRectMake(20,0,50,40);
        [_cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        _cancelBtn.titleLabel.font=FontRegularName(15);
        [_cancelBtn setTitle:SIMLocalizedString(@"AlertCCancel", nil) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
#pragma mark----创建-----
static SIMJDatePicker* instance;
+(SIMJDatePicker*)shareDatePicker{
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[SIMJDatePicker alloc] init];
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
        [self addSubview:self.cancelBtn];
//        self.backgroundColor=[UIColor colorWithWhite:1 alpha:0.9];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.frame=CGRectMake(0, KDeviceHeight, KDeviceWidth, 226);
    }
    return self;
}

-(void)datePickerDidSelected:(dateSelected)dateSelected{
    self.dateSelected = dateSelected;
}
-(void)changePickerDidSelected:(changeSelected)changeSelected{
    self.changeSelected = changeSelected;
}
-(void)cancelPickerDidSelected:(cancelSelected)cancelSelected {
    self.cancelSelected = cancelSelected;
}
#pragma mark----点击事件-----
-(void)BtnClicked:(UIButton*)btn{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];

    [outputFormatter setDateFormat:SIMLocalizedString(@"JSBTimeYearAndMonth", nil)];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [outputFormatter setLocale:locale];
    self.dateStr=[outputFormatter stringFromDate:self.datePicker.date];
    !self.dateSelected ? :self.dateSelected(self.dateStr,self.datePicker.date);
}
-(void)cancelBtnClicked:(UIButton*)btn{
    !self.cancelSelected ? :self.cancelSelected();
    
}
-(void)changeClicked{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:SIMLocalizedString(@"JSBTimeYearAndMonth", nil)];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [outputFormatter setLocale:locale];
    self.dateStr=[outputFormatter stringFromDate:self.datePicker.date];
    
    !self.changeSelected ? :self.changeSelected(self.dateStr,self.datePicker.date);
    
    
}

@end
