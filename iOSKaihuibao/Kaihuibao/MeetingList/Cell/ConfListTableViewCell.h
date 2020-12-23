//
//  ConfListTableViewCell.h
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/22.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArrangeConfModel.h"
#import "SIMMyServiceVideo.h"
typedef void(^StartClick)();
@interface ConfListTableViewCell : UITableViewCell
@property (copy, nonatomic) StartClick startClick;
@property (nonatomic, strong) ArrangeConfModel *conflistModel;
@property (nonatomic, strong) SIMMyServiceVideo *myVideoM;

@property (nonatomic, strong) UIButton *start;
@end
