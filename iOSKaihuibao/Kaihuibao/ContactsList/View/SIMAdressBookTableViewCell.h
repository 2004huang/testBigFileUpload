//
//  SIMAdressBookTableViewCell.h
//  Kaihuibao
//
//  Created by 王小琪 on 2017/7/31.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMContants.h"
typedef void(^AddClick)();
@interface SIMAdressBookTableViewCell : UITableViewCell
@property (copy, nonatomic) AddClick addClick;
@property (nonatomic, strong) SIMContants *sont;// 人员模型
//@property (nonatomic, assign) BOOL isNewBtn;
@property (nonatomic, strong) UIButton *addBtn;
@end
