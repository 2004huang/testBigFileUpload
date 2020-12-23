//
//  SIMAddNewFriendCell.h
//  Kaihuibao
//
//  Created by mac126 on 2018/10/19.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMAddNewFriendCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *theNewDic; // 用于新的好友这种写死的样式 不是模型的用户

@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *ownerLab;

@end

NS_ASSUME_NONNULL_END
