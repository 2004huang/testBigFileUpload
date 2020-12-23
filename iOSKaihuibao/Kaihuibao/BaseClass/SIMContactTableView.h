//
//  SIMContactTableView.h
//  Kaihuibao
//
//  Created by mac126 on 2019/5/14.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMContactTableView : UITableView
-(instancetype)initPlainInViewController:(UIViewController<UITableViewDelegate,UITableViewDataSource> *)viewController  style:(UITableViewStyle)style;
@end

NS_ASSUME_NONNULL_END
