//
//  SIMPayResultAlertView.h
//  Kaihuibao
//
//  Created by mac126 on 2018/10/11.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CancelClick)();
typedef void(^SaveClick)();

@interface SIMPayResultAlertView : UIView
@property (copy, nonatomic) CancelClick cancelClick;
@property (copy, nonatomic) SaveClick saveClick;
@property (strong, nonatomic) NSDictionary *dicWalletM;
@property (strong, nonatomic) NSDictionary *dicM;
@property (strong, nonatomic) NSDictionary *dicFreeM;
@property (strong, nonatomic) NSString *type;
@end

NS_ASSUME_NONNULL_END
