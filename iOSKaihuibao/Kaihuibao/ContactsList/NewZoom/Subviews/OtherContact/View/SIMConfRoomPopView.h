//
//  SIMConfRoomPopView.h
//  Kaihuibao
//
//  Created by mac126 on 2019/5/14.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^CancelClickBlock)();
typedef void(^AddClickBlock)();

@interface SIMConfRoomPopView : UIView
@property (copy, nonatomic) CancelClickBlock cancelClickBlock;
@property (copy, nonatomic) AddClickBlock addClickBlock;
@property (nonatomic, strong) UITextField *textF;

@end

NS_ASSUME_NONNULL_END
