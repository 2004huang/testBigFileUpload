//
//  SIMNMmainCell.h
//  Kaihuibao
//
//  Created by mac126 on 2018/9/4.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMNModel.h"

//typedef void(^BtnClick)();

@interface SIMNMmainCell : UITableViewCell
@property (nonatomic, strong) SIMNModel *model;
//@property (nonatomic, assign) BOOL isHaveMore; // 是否有“更多应用”的按钮
//@property (copy, nonatomic) BtnClick btnClick;

@property (nonatomic, copy) void(^indexTagBlock)(NSInteger btnserial);// 图标按钮点击方法

@property (nonatomic, copy) void(^btnClick)(NSInteger btnserial);// 点击更多按钮的方法

@end
