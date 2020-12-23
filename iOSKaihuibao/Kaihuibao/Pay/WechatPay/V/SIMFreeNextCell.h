//
//  SIMFreeNextCell.h
//  Kaihuibao
//
//  Created by mac126 on 2018/11/2.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TabBarDidClickAtIndex)(NSInteger buttonIndex);
typedef void(^BtnClick)();
@interface SIMFreeNextCell : UITableViewCell
@property(nonatomic,copy)TabBarDidClickAtIndex didClickAtIndex;
@property (copy, nonatomic) BtnClick btnClick; // 点击了查看计划按钮
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, assign) NSInteger selectIndex;

@end

NS_ASSUME_NONNULL_END
