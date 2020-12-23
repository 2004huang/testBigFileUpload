//
//  SIMFreeNewVipTableViewCell.h
//  Kaihuibao
//
//  Created by mac126 on 2018/11/2.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMFreeNewVipTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray *arr;

//@property (nonatomic, strong) NSArray *picarr;
@property (nonatomic, copy) void(^indexTagBlock)(NSInteger btnserial);

@end

NS_ASSUME_NONNULL_END
