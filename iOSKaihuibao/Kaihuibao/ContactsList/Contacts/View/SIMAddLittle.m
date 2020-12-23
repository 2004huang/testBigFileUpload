//
//  SIMAddLittle.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/27.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMAddLittle.h"
@interface SIMAddLittle()

@end
@implementation SIMAddLittle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancel setTitle:SIMLocalizedString(@"NavBackCancelTitle", nil) forState:UIControlStateNormal];
        _cancel.titleLabel.font = FontRegularName(14);
        [_cancel setTitleColor:BlueButtonColor forState:UIControlStateNormal];
        [_cancel addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancel];
        
        _label = [[UILabel alloc] init];
        _label.text = SIMLocalizedString(@"CCAddContantLittle", nil);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = FontRegularName(16);
        _label.textColor = BlackTextColor;
        [self addSubview:self.label];
        
        _save = [UIButton buttonWithType:UIButtonTypeCustom];
        [_save setTitle:SIMLocalizedString(@"NavBackSave", nil) forState:UIControlStateNormal];
        [_save setTitleColor:BlueButtonColor forState:UIControlStateNormal];
        _save.titleLabel.font = FontRegularName(14);
        [_save addTarget:self action:@selector(saveBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.save];
        
        _line = [[UILabel alloc] init];
        _line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_line];
        
        _input = [[UITextField alloc] init];
        _input.placeholder = SIMLocalizedString(@"KHBPhoneNumPlaceHolder", nil);
        _input.textAlignment = NSTextAlignmentCenter;
        _input.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:_input];
        
        _cancel.sd_layout.leftSpaceToView(self,15).topSpaceToView(self,10).heightIs(30).widthIs(50);
        _label.sd_layout.centerXIs(self.width/2).topEqualToView(_cancel).heightIs(30).widthIs(100);
        _save.sd_layout.heightIs(30).topEqualToView(_cancel).widthIs(50).rightSpaceToView(self,15);
        _line.sd_layout.leftSpaceToView(self,15).topSpaceToView(_cancel,10).heightIs(1).rightSpaceToView(self,15);
        _input.sd_layout.leftSpaceToView(self,20).topSpaceToView(_line,50).heightIs(30).rightSpaceToView(self,20);
        
    }return self;
}
#pragma mark -- Event
- (void)cancelBtn {
    if (self.cancelClick) {
        self.cancelClick();
    }
}
- (void)saveBtn {
    if (self.saveClick) {
        self.saveClick();
    }
}


@end
