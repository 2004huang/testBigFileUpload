//
//  SIMScrollTextAlertView.h
//  Kaihuibao
//
//  Created by mac126 on 2020/5/11.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMScrollTextAlertView : UIView
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, copy) void(^buttonSerialBlock)(NSInteger index);// 按钮点击方法
@end

NS_ASSUME_NONNULL_END
