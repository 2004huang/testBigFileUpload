//
//  SIMPayLiuLiangCell.h
//  Kaihuibao
//
//  Created by mac126 on 2018/10/13.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TabBarDidClickAtIndex)(NSInteger buttonIndex);

@interface SIMPayLiuLiangCell : UITableViewCell
@property(nonatomic,copy)TabBarDidClickAtIndex didClickAtIndex;
@end

NS_ASSUME_NONNULL_END
