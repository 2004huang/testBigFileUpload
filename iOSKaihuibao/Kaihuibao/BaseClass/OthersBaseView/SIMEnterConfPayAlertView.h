//
//  SIMEnterConfPayAlertView.h
//  Kaihuibao
//
//  Created by mac126 on 2019/12/19.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CancelClick)();

@interface SIMEnterConfPayAlertView : UIView
@property (copy, nonatomic) CancelClick cancelClick;
@property (nonatomic, copy) void(^buttonSerialBlock)(NSString *serial);// 按钮点击方法
@property (assign, nonatomic) CGFloat viewHei;
@property (strong, nonatomic) NSDictionary *dicM;

@end

NS_ASSUME_NONNULL_END
