//
//  SIMCustomFooterView.h
//  Kaihuibao
//
//  Created by mac126 on 2018/9/17.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIMCustomFooterView : UIView

@property (nonatomic, strong) NSArray *arr;//新增的视频咨询点击进入按钮
@property (nonatomic, copy) void(^indexTagBlock)(NSInteger btnserial);// 图标按钮点击方法

@end
