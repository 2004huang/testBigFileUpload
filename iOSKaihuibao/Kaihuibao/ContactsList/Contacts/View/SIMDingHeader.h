//
//  SIMDingHeader.h
//  Kaihuibao
//
//  Created by 王小琪 on 2018/1/31.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMContants.h"
#import "SIMDepartment.h"
//#import "SIMUserContants.h"
#import "SIMAdress.h"

@interface SIMDingHeader : UIView
@property (nonatomic, strong) SIMContants *contant;
//@property (nonatomic, strong) SIMUserContants *userCont;
@property (nonatomic, strong) SIMDepartment_member *depart;
@property (nonatomic, strong) SIMAdress *adress;
@end
