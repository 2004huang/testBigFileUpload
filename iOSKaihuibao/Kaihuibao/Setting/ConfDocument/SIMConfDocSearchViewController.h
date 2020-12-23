//
//  SIMConfDocSearchViewController.h
//  Kaihuibao
//
//  Created by mac126 on 2019/9/5.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SIMConfDocSearchViewController : SIMBaseViewController
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) SIMBaseTableView *tableView;
@property (nonatomic, strong) NSString *pageType;// doc是文档 shorthand是速记
@property (nonatomic, weak) UIViewController *mainSearchController;
@end

NS_ASSUME_NONNULL_END
