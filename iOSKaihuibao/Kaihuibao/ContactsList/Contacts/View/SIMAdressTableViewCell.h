//
//  SIMAdressTableViewCell.h
//  Kaihuibao
//
//  Created by mac126 on 2017/12/26.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SIMContants.h"

typedef void(^AddBnClick)();

@interface SIMAdressTableViewCell : UITableViewCell

@property (copy, nonatomic) AddBnClick addBnClick;
//@property (nonatomic, strong) SIMAdress *sont;// 人员模型
@property (nonatomic, strong) SIMContants *contants;// 人员模型
@property (nonatomic, assign) BOOL ishaveBtn;// 有没有邀请按钮
@end
