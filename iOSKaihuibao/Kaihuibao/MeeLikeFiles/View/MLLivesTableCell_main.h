//
//  MLLivesTableCell_main.h
//  MeeLike
//
//  Created by mac126 on 2020/9/16.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLLivesModel_main.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^BtnCallback)(MLLivesModel_main * model);
@interface MLLivesTableCell_main : UITableViewCell

@property (nonatomic, strong)MLLivesModel_main * model;
@property(nonatomic,copy)BtnCallback didClickAtIndex;

@end

NS_ASSUME_NONNULL_END
