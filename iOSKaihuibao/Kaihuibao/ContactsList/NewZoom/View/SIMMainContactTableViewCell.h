//
//  SIMMainContactTableViewCell.h
//  Kaihuibao
//
//  Created by mac126 on 2019/5/13.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMMainContactTableViewCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UILabel *mainTitle;
@property (nonatomic, strong) UILabel *detailLab;
@end

NS_ASSUME_NONNULL_END
