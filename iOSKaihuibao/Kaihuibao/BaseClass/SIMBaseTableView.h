//
//  SIMBaseTableView.h
//  Kaihuibao
//
//  Created by Ferris on 2017/3/30.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIMBaseTableView : UITableView
-(instancetype)initInViewController:(UIViewController<UITableViewDelegate,UITableViewDataSource> *)viewController;
@end
