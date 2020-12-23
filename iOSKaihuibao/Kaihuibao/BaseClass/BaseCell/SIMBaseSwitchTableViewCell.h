//
//  SIMBaseSwitchTableViewCell.h
//  Kaihuibao
//
//  Created by Ferris on 2017/4/1.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SwitClick)();
@interface SIMBaseSwitchTableViewCell : UITableViewCell

@property (nonatomic,strong,readonly) UISwitch* switchButton;
@property (copy, nonatomic) SwitClick switClick;
@property (nonatomic, strong) UILabel *titleLab;
@end
