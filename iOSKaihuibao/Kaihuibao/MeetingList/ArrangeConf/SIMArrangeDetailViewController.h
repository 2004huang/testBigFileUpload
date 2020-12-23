//
//  SIMArrangeDetailViewController.h
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/22.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"
#import "ArrangeConfModel.h"
@interface SIMArrangeDetailViewController : SIMBaseViewController
@property (nonatomic, strong) NSString *cidStr;
@property (nonatomic, assign) NSInteger serialStr;
@property (nonatomic, strong) NSString *teachIDStr;// 教学的ID
@property (nonatomic, strong) NSString *teachNameStr;// 教学的模式名字
@property (nonatomic, strong) NSString *teachorConfStr;// 教学列表里是显示教学还是会议

@property (nonatomic, strong) ArrangeConfModel *arrangeConf;
@end
