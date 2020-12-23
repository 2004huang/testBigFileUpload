//
//  SIMAddLittle.h
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/27.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CancelClick)();
typedef void(^SaveClick)();
@interface SIMAddLittle : UIView
@property (nonatomic, strong) UIButton *cancel;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *save;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UITextField *input;

@property (copy, nonatomic) CancelClick cancelClick;
@property (copy, nonatomic) SaveClick saveClick;
@end
