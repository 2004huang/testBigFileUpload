//
//  SIMSendView.h
//  Kaihuibao
//
//  Created by mac126 on 2018/9/6.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIMSendView : UIView

@property (nonatomic, copy) void(^indexTagBlock)(NSInteger btnserial);
@property (nonatomic, assign) BOOL typeStr;
@property (nonatomic, strong) NSArray *array;

@end
