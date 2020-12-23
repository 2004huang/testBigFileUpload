//
//  SIMContentLabViewController.h
//  Kaihuibao
//
//  Created by 王小琪 on 2017/10/18.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"
#import "ArrangeConfModel.h"
@protocol SIMContentLabdelegate <NSObject>
- (void)contentConfString:(NSString *)content;
@end

@interface SIMContentLabViewController : SIMBaseViewController
@property (nonatomic, assign) id <SIMContentLabdelegate>delegate;
@property (nonatomic, strong) NSString *classStr;

@end
