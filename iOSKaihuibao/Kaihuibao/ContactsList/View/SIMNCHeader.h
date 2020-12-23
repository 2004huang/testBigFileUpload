//
//  SIMNCHeader.h
//  Kaihuibao
//
//  Created by mac126 on 2018/9/8.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BtnClick)();

@interface SIMNCHeader : UIView
@property (copy, nonatomic) BtnClick btnClick;
@property (nonatomic, copy) void(^indexTagBlock)(NSInteger btnserial);
@end
