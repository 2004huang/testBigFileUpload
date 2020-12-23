//
//  SIMConfDocListCell.h
//  Kaihuibao
//
//  Created by mac126 on 2019/9/5.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMConfDocModel.h"
#import "SIMCofShorthandModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SIMConfDocListCell : UITableViewCell
@property (nonatomic, strong) SIMConfDocModel *model;
@property (nonatomic, strong) SIMCofShorthandModel *shortmodel;
@end

NS_ASSUME_NONNULL_END
