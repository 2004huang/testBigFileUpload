//
//  SIMListTableViewCell.h
//  Kaihuibao
//
//  Created by 王小琪 on 2017/7/17.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMContants.h"
//#import "SIMGroup.h"
//#import "SIMGroupMember.h"
//#import "SIMUserContants.h"
#import "SIMDepartment.h"

@interface SIMListTableViewCell : UITableViewCell
@property (nonatomic, strong) SIMContants *contants;
//@property (nonatomic, strong) SIMGroup *groups;
//@property (nonatomic, strong) SIMGroupMember *members;
//@property (nonatomic, strong) SIMUserContants *userContants;
@property (nonatomic, strong) SIMDepartment_member *department;



@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *ownerLab;
@end
