//
//  PopView.h
//  Kaihuibao
//
//  Created by 王小琪 on 2017/5/25.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopView : UIView

+ (void)configCustomPopViewWithFrame:(CGRect)frame imagesArr:(NSArray *)imagesArr dataSourceArr:(NSArray *)dataourceArr seletedRowForIndex:(void(^)(NSInteger index))action animation:(BOOL)animation timeForCome:(NSTimeInterval)come timeForGo:(NSTimeInterval)go;
+ (void)removed;

@end
