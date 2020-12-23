//
//  SIMAddUserResultViewController.h
//  Kaihuibao
//
//  Created by mac126 on 2019/7/9.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SIMAddUserResultViewController : SIMBaseViewController


@property (nonatomic, strong) SIMBaseTableView *tableView;

@property (nonatomic, strong) NSArray *searchResults;// 搜索结果数组
@property (nonatomic, strong) NSMutableArray *chooseArr;// 选中数组传递
//在MySearchResultViewController添加一个指向展示页的【弱】引用属性。
@property (nonatomic, weak) UIViewController *mainSearchController;
@end

NS_ASSUME_NONNULL_END
