//
//  SIMConfDocSelectSearchController.h
//  Kaihuibao
//
//  Created by mac126 on 2019/9/9.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SIMConfDocSelectSearchController : SIMBaseViewController
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) SIMBaseTableView *tableView;
@property (nonatomic, weak) UIViewController *mainSearchController;
@property (nonatomic, strong) NSMutableArray *chooseArr;// 选中数组传递
@end

NS_ASSUME_NONNULL_END
