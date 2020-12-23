//
//  SIMLabelNet.h
//  Kaihuibao
//
//  Created by 王小琪 on 2017/11/20.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NetClick)();

@interface SIMLabelNet : UIView
@property (nonatomic, strong) UIButton *labBtn;

@property (copy, nonatomic) NetClick netClick;


@end
