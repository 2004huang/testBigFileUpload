//
//  SIMAdressBookViewController.h
//  Kaihuibao
//
//  Created by 王小琪 on 2017/7/31.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"
#import "SIMPicture.h"

@interface SIMAdressBookViewController : SIMBaseViewController
@property (nonatomic, assign) NSInteger shareType;
@property (nonatomic, assign) BOOL isNewHaveBtn;
@property (nonatomic, strong) SIMPicture *webAdress;
@end
