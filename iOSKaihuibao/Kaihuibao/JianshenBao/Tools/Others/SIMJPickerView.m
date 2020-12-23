//
//  SIMJPickerView.m
//  Kaihuibao
//
//  Created by mac126 on 2019/3/20.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMJPickerView.h"
@interface SIMJPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIToolbar *pickerDateToolbar;
@property (nonatomic, copy) NSString *selectPick;
//@property (nonatomic, strong) UIView *backView;
@end

@implementation SIMJPickerView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _dataSource = [[NSMutableArray alloc] init];
//        self.selectPick = self.dataSource[0];
        
    }
    return self;
}

#pragma mark -- Event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hidden];
}
- (void)toolBarDoneClick {
    
    if (self.selectPick.length == 0) {
        self.selectPick = self.dataSource[0];
    }
    self.callBlock(self.selectPick);
    
    [self hidden];
}
- (void)toolBarCanelClick {
    [self hidden];
}
-(void)show{
    if (_pickerView == nil) {
        self.selectPick = self.selectStr;
        
        //    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, StatusNavH, screen_width, screen_height-StatusNavH)];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        
        // 选择框
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screen_height - 216, screen_width, 216)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        // 显示选中框
        _pickerView.showsSelectionIndicator=YES;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        //    [_pickerView selectRow:0 inComponent:0 animated:YES];
        NSInteger index = [self.dataSource indexOfObject:self.selectStr];
        [_pickerView selectRow:index inComponent:0 animated:NO];
        // 添加按钮
        _pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, screen_height - 216 - 44, screen_width, 44)];
        [_pickerDateToolbar sizeToFit];
        _pickerDateToolbar.barTintColor = [UIColor whiteColor];
        _pickerDateToolbar.tintColor = [UIColor blueColor];
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"PickViewCancelJoin", nil) style:UIBarButtonItemStylePlain target:self action:@selector(toolBarCanelClick)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"PickViewOkJoin", nil) style:UIBarButtonItemStylePlain target:self action:@selector(toolBarDoneClick)];
        [barItems addObject:cancelBtn];
        [barItems addObject:flexSpace];
        [barItems addObject:doneBtn];
        [_pickerDateToolbar setItems:barItems animated:NO];
        [window addSubview:_pickerView];
        //    [_backView addSubview:_pickerView];
        [window addSubview:_pickerDateToolbar];
        [UIView animateWithDuration:0.25f animations:^{
            _pickerDateToolbar.frame = CGRectMake(0, screen_height - 216 - 44, screen_width, 44);
            _pickerView.frame = CGRectMake(0, screen_height - 216, screen_width, 216);
        }];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"pickviewWillChange" object:nil userInfo:@{@"picktype":@"show"}];
    }
    
}
-(void)hidden{
    if (_pickerView != nil) {
        [UIView animateWithDuration:0.25f animations:^{
            _pickerView.frame=CGRectMake(0, screen_height, screen_width, 216);
            _pickerDateToolbar.frame = CGRectMake(0, screen_height, screen_width, 44);
        } completion:^(BOOL finished) {
            //        [_backView removeFromSuperview];
            [_pickerView removeFromSuperview];
            [_pickerDateToolbar removeFromSuperview];
            _pickerView = nil;
            _pickerDateToolbar = nil;
        }];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"pickviewWillChange" object:nil userInfo:@{@"picktype":@"hide"}];
    }
}

#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return screen_width;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataSource.count;
}
#pragma Mark -- UIPickerViewDelegate
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.dataSource objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectPick = self.dataSource[row];
}


@end
