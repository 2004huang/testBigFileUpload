//
//  SIMResultDisplayViewController.h
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/30.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SIMResultDisplayViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *datas;
//@property (nonatomic, copy) void(^block)(SIMContants *person);
@property (nonatomic, strong) SIMBaseTableView *tableView;

//@property (nonatomic, strong) NSMutableDictionary *searchResults;

//在MySearchResultViewController添加一个指向展示页的【弱】引用属性。
@property (nonatomic, weak) UIViewController *mainSearchController;
//@property (nonatomic, assign) NSInteger selectIndex;
//@property (nonatomic, assign) BOOL isOrganize;
@end
