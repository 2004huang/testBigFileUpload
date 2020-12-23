//
//  SIMSearchMapResultViewController.h
//  Kaihuibao
//
//  Created by mac126 on 2019/8/9.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol SIMSearchMapResultViewDelegate <NSObject>
// 点击网格上各个按钮的事件
- (void)searchLoactionWithLat:(double)latitude andLon:(double)longitude locationStr:(NSString *)locationStr;
@end

@interface SIMSearchMapResultViewController : SIMBaseViewController
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) SIMBaseTableView *tableView;
//在MySearchResultViewController添加一个指向展示页的【弱】引用属性。
@property (nonatomic, weak) UIViewController *mainSearchController;
@property (nonatomic, assign) id <SIMSearchMapResultViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
