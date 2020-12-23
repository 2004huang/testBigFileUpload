//
//  WebviewProgressLine.h
//  Kaihuibao
//
//  Created by 王小琪 on 2017/10/11.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebviewProgressLine : UIView
//进度条颜色
@property (nonatomic,strong) UIColor  *lineColor;

//开始加载
-(void)startLoadingAnimation;

//结束加载
-(void)endLoadingAnimation;

@end
