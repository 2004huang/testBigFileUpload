//
//  SIMBaseInputTableViewCell.h
//  Kaihuibao
//
//  Created by Ferris on 2017/3/30.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMJoinNumTF.h"
@interface SIMBaseInputTableViewCell : UITableViewCell
@property (nonatomic,strong,readonly) UITextField* textfield;
@property (nonatomic,strong,readonly) SIMJoinNumTF* joinTextfield;
@property (nonatomic,strong) NSString *placeHolderStr;
@property (nonatomic,strong) NSString *placeHolderTwoStr;
-(instancetype)initTwoTextF;
@end

