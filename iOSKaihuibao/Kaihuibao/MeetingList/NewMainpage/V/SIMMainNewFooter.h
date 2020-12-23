//
//  SIMMainNewFooter.h
//  Kaihuibao
//
//  Created by mac126 on 2018/9/13.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SIMMainNewFooter : UIView
@property (nonatomic, strong) NSArray *arr;

@property (nonatomic, copy) void(^picIndexBlock)(NSInteger picserial);

@end
