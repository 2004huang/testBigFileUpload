//
//  SIMMapViewController.h
//  Kaihuibao
//
//  Created by 王小琪 on 17/7/6.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SIMMapViewDelegate <NSObject>
// 点击网格上各个按钮的事件
//- (void)buttonSnapshootImage:(UIImage *)seletImage;
- (void)buttonNowLoactionWithLat:(double)latitude andLon:(double)longitude locationStr:(NSString *)locationStr;
@end

@interface SIMMapViewController : UIViewController
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) id <SIMMapViewDelegate>delegate;
@end
