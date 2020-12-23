//
//  SIMWalletPayAlertView.h
//  Kaihuibao
//
//  Created by mac126 on 2019/7/29.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SaveClick)();
@interface SIMWalletPayAlertView : UIView
@property (copy, nonatomic) SaveClick saveClick;
@end

NS_ASSUME_NONNULL_END
