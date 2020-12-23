//
//  SIMNCNormalCell.h
//  Kaihuibao
//
//  Created by mac126 on 2018/9/8.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BtnClick)();
@interface SIMNCNormalCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *theNewDic; // 用于新的好友这种写死的样式 不是模型的用户
@property (copy, nonatomic) BtnClick btnClick;
@end
