//
//  UIViewController+SIMConvenient.h
//  Tictalk
//
//  Created by Ferris on 2016/12/20.
//  Copyright © 2016年 Tictalkin. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIViewController (SIMConvenient)
- (UINavigationController*)sim_wrappedByNavigationViewControllerClass:(Class)className;
-(UINavigationController*)sim_wrappedByNavigationController;
- (SIMBaseNavigationViewController*)sim_wrappedBySIMNavigationController;

@end
