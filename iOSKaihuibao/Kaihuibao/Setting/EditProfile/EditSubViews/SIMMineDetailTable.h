//
//  SIMMineDetailTable.h
//  Kaihuibao
//
//  Created by mac126 on 2019/1/7.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LogoutBtnClick)();
@interface SIMMineDetailTable : UIView
@property (copy, nonatomic) LogoutBtnClick logoutBtnClick;

@property (nonatomic, copy) void(^indexBlock)(NSInteger sectionTag,NSInteger rowTag);

@property (strong, nonatomic) SIMBaseTableView *tableView;

-(void)prepareCells;

@end

NS_ASSUME_NONNULL_END
