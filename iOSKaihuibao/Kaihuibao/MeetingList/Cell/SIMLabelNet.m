//
//  SIMLabelNet.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/11/20.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMLabelNet.h"


@implementation SIMLabelNet

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        _labBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _labBtn.titleLabel.font = FontRegularName(12);
        [_labBtn setTitle:SIMLocalizedString(@"AllAlertTitleNetWork", nil) forState:UIControlStateNormal];
        [_labBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_labBtn setBackgroundColor:ZJYColorHex(@"#f16973")];
        [_labBtn addTarget:self action:@selector(labNetClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_labBtn];
        
    }return self;
}

- (void)labNetClick {
    if (self.netClick) {
        self.netClick();
    }
}


@end
