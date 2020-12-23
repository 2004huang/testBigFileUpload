//
//  SIMSelectToponTableViewCell.h
//  Kaihuibao
//
//  Created by mac126 on 2019/9/20.
//  Copyright © 2019 Ferris. All rights reserved.
//

// llllllll
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TabBarDidClickAtIndex)(NSInteger buttonIndex);
@interface SIMSelectToponTableViewCell : UITableViewCell
@property(nonatomic,copy)TabBarDidClickAtIndex didClickAtIndex;
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, assign) NSInteger selectIndex;

@end

NS_ASSUME_NONNULL_END
