//
//  SIMBaseWhiteNavigationViewController.m
//  Kaihuibao
//
//  Created by Ferris on 2017/3/30.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMBaseWhiteNavigationViewController.h"

@interface SIMBaseWhiteNavigationViewController ()

@end

@implementation SIMBaseWhiteNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *navigationBar = self.navigationBar;
    [navigationBar setBarStyle:UIBarStyleDefault];
    [navigationBar setBarTintColor:[UIColor whiteColor]];
    [navigationBar setTintColor:DarkBlackNavBarFontColor];
    navigationBar.translucent = NO;
    navigationBar.opaque = YES;
    self.navigationItem.backBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"returnicon"];
    self.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"returnicon"];
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item{
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    item.backBarButtonItem = back;
    
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}



@end
