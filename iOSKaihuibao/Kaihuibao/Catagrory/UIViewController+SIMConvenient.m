//
//  UIViewController+SIMConvenient.m
//  Tictalk
//
//  Created by Ferris on 2016/12/20.
//  Copyright © 2016年 Tictalkin. All rights reserved.
//

#import "UIViewController+SIMConvenient.h"
#import "SIMTabBarViewController.h"
@implementation UIViewController (SIMConvenient)
-(UINavigationController *)sim_wrappedByNavigationViewControllerClass:(Class)className
{
    UINavigationController* navigationController= [[className alloc] initWithRootViewController:self] ;
    return navigationController;
}
-(UINavigationController *)sim_wrappedByNavigationController
{
    return [self sim_wrappedByNavigationViewControllerClass:[UINavigationController class]];
}
-(SIMBaseNavigationViewController *)sim_wrappedBySIMNavigationController
{
    return (SIMBaseNavigationViewController*)[self sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
}

@end
