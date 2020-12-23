//
//  SIMNewWalletHeader.h
//  Kaihuibao
//
//  Created by mac126 on 2020/2/25.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMNewWalletHeader : UIView
@property (nonatomic, copy) void(^indexTagBlock)(NSInteger btnserial);// 图标按钮点击方法
@property (nonatomic, strong) NSString *balanceCount;
@end

NS_ASSUME_NONNULL_END
