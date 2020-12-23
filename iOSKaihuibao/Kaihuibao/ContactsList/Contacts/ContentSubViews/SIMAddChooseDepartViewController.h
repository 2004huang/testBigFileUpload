//
//  SIMAddChooseDepartViewController.h
//  Kaihuibao
//
//  Created by mac126 on 2019/7/22.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol AddChooseDepartDelegate <NSObject>

@optional
- (void)optionChooseArr:(NSArray *)chooseArr;

@end

@interface SIMAddChooseDepartViewController : SIMBaseViewController
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, weak) id<AddChooseDepartDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *choseIndexArr;
@end

NS_ASSUME_NONNULL_END
