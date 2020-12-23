//
//  SIMNewLiveTabbarController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/11/26.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMNewLiveTabbarController.h"

#import "SIMMyRoomViewController.h"
#import "SIMJoinMeetingViewController.h"
#import "SIMNewLiveViewController.h"
#import "SIMChatViewController.h"

@interface SIMNewLiveTabbarController ()<UITabBarControllerDelegate>
@property (nonatomic, copy) NSArray <NSString *> *titles;

@end

@implementation SIMNewLiveTabbarController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.delegate = self;
    
    // 开始直播
    SIMMyRoomViewController *roomVC = [[SIMMyRoomViewController alloc] init];
    roomVC.isLive = YES;
    
    // 加入直播
    SIMJoinMeetingViewController *joinVC = [[SIMJoinMeetingViewController alloc] init];
    joinVC.isLive = YES;
    
    //  新建直播
    SIMNewLiveViewController *liveVC = [[SIMNewLiveViewController alloc] init];
    liveVC.isTabbar = YES;
    
    //  我的直播列表
    SIMChatViewController *myliveVC = [[SIMChatViewController alloc] init];
    

    [self setUpChidController:roomVC title:@"开始直播" image:@"开始直播-正常" SelectedImage:@"开始直播-选中"];
    [self setUpChidController:joinVC title:@"加入直播" image:@"观看直播-正常" SelectedImage:@"观看直播-选中"];
    [self setUpChidController:liveVC title:@"新建直播" image:@"新建直播-正常" SelectedImage:@"新建直播-选中"];
    [self setUpChidController:myliveVC title:@"直播列表" image:@"直播回放-正常" SelectedImage:@"直播回放-选中"];
    
    self.viewControllers = @[[roomVC sim_wrappedBySIMNavigationController],[joinVC sim_wrappedBySIMNavigationController],[liveVC sim_wrappedBySIMNavigationController],[myliveVC sim_wrappedBySIMNavigationController]];
    
    
    self.selectedIndex = 0;
    
//    [self setSelectedViewController:roomVC];
//
//    roomVC.tabBarController.navigationItem.title = self.titles[0];
    
}

// 初始化子控制器
- (void)setUpChidController:(UIViewController *)viewController title:(NSString *)title image:(NSString *)image SelectedImage:(NSString *)selectImage{
    viewController.tabBarItem = [[UITabBarItem alloc] init];
    viewController.tabBarItem.title = title;
    viewController.navigationItem.title = title;
    if (image.length) {
        // 图片
        viewController.tabBarItem.image = [UIImage imageNamed:image];
        // 选中图片
        viewController.tabBarItem.selectedImage = [UIImage imageNamed:selectImage];
    }
    // 添加子控制器
    [self addChildViewController:viewController];
    
    UIBarButtonItem *tempButItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"returnicon"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    tempButItem.imageInsets = UIEdgeInsetsMake(0, -10,0, 0);
    viewController.navigationItem.leftBarButtonItem = tempButItem;
//    [self addBarButton];
}

- (void)buttonClicked {
    if (self.selectedIndex != 0) {
        [self setSelectedIndex:0];
    }else {
        [self.selectedViewController.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - <UITabBarControllerDelegate>

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    __block NSInteger index = 0;
//    [tabBarController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj == viewController) {
//            index = idx;
//            *stop = YES;
//        }
//    }];
//    
//    viewController.tabBarController.navigationItem.title = self.titles[index];
//}
//
//
//
//#pragma mark - GET
//
//- (NSArray<NSString *> *)titles{
//    if (!_titles) {
//        _titles = @[@"开始直播",
//                    @"观看直播",
//                    @"新建直播",
//                    @"直播回放"];
//    }
//    return _titles;
//}

@end
