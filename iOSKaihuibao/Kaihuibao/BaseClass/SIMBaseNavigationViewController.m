//
//  SIMBaseNavigationViewController.m
//  Kaihuibao
//
//  Created by Ferris on 2017/3/30.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMBaseNavigationViewController.h"

@interface SIMBaseNavigationViewController ()

@end

@implementation SIMBaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *navigationBar = self.navigationBar;
    [navigationBar setBarStyle:UIBarStyleDefault];
    [navigationBar setBarTintColor:[UIColor whiteColor]];
    [navigationBar setTintColor:BlueButtonColor];
    navigationBar.titleTextAttributes=
    @{NSForegroundColorAttributeName:NewBlackTextColor,
      NSFontAttributeName:FontRegularName(18)};
    //    [navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage imageWithColor:ZJYColorHex(@"#f4f3f3")]];
    navigationBar.translucent = NO;
    navigationBar.opaque = YES;
    
    self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"returnicon"];
    self.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"returnicon"];
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item{
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    navigationBar.backIndicatorImage = [UIImage imageNamed:@"returnicon"];
//    navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"returnicon"];
    item.backBarButtonItem = back;

    return YES;
}

//重写push方法隐藏tabBar和自定义返回按钮
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


- (BOOL)shouldAutorotate
{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
//    return UIInterfaceOrientationMaskAll;
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
