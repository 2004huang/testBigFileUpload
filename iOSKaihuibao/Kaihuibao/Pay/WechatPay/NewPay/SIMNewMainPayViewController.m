//
//  SIMNewMainPayViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/5/20.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMNewMainPayViewController.h"

#import "SIMNewPlanListViewController.h"
#import "SIMNowPlanViewController.h"
#import "SIMNewPlanChossen.h"
#import "SIMNowServiceViewController.h"
#import "SIMMainPayScrollViewController.h"

@interface SIMNewMainPayViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_baseScrollView;// 滚动视图

    SIMNewPlanListViewController *_planVC;// 计划VC
    SIMNewPlanListViewController *_extraVC;// 拓展VC
    SIMNowPlanViewController *_nowPVC;// 当前VC
    SIMNowServiceViewController *_nowSVC;// 当前VC
}

@property (nonatomic, strong) NSMutableArray <UIViewController *> *subViewControllers;
@property (nonatomic, strong) SIMNewPlanChossen *segmentView;
@end

@implementation SIMNewMainPayViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"wechatpaymaindealloc");
}
- (void)refreshTheDatas {
    [self navigationDidSelectedControllerIndex:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTheDatas) name:PayRefreshTheMainPage object:nil];
    self.navigationItem.title = SIMLocalizedString(@"NPayChooseTitle", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _subViewControllers = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segmentView];
    [self addScrollViews];// 添加分段控制器以及滚动子视图
    // 如果是会议内部界面的话 那么是返回是dismiss
    if (self.isConfVC) {
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"returnicon"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
        self.navigationItem.leftBarButtonItem = backBtn;
    }
}
- (void)backClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- lazyload
- (SIMNewPlanChossen *)segmentView {
    if (!_segmentView) {
        self.segmentView = [[SIMNewPlanChossen alloc] initWithTitles:@[SIMLocalizedString(@"NPayPlanTitle", nil),SIMLocalizedString(@"NPayServiceTitle", nil),SIMLocalizedString(@"NPayNowPlanTitle", nil),SIMLocalizedString(@"NPayNowServiceTitle", nil)]  frame:CGRectMake(0, 0, screen_width, 46) selectIndex:0 hasLine:NO hasSlider:YES];
        
        
        __weak typeof(self) weakSelf = self;
        [self.segmentView setDidClickAtIndex:^(NSInteger index) {
            [weakSelf navigationDidSelectedControllerIndex:index];
        }];
    }
    return _segmentView;
}

- (void)addScrollViews {
    //添加滚动视图
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _segmentView.bottom, screen_width, screen_height - StatusNavH - _segmentView.height)];
    
    
    _baseScrollView.bounces = NO;
    _baseScrollView.delegate = self;
    _baseScrollView.scrollEnabled = NO;
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_baseScrollView];
    
    _baseScrollView.contentSize = CGSizeMake(screen_width*4, _baseScrollView.height);

    _planVC = [[SIMNewPlanListViewController alloc] init];
    _planVC.view.frame = CGRectMake(0, 0, screen_width, _baseScrollView.height);
    _planVC.type = @"plan";
    [self addChildViewController:_planVC];
    [_baseScrollView addSubview:_planVC.view];
    
    [self.subViewControllers addObject:_planVC];
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //实时计算当前位置,实现和titleView上的按钮的联动
    [self.segmentView scrollToIndex:scrollView.contentOffset.x];
    NSInteger indexT = scrollView.contentOffset.x / screen_width;
    [self addOtherSubViews:indexT];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.segmentView scrollToIndex:scrollView.contentOffset.x];
    NSInteger indexT = scrollView.contentOffset.x / screen_width;
    [self addOtherSubViews:indexT];
}

#pragma mark - PrivateMethod
- (void)navigationDidSelectedControllerIndex:(NSInteger)index {
    [_baseScrollView setContentOffset:CGPointMake((_baseScrollView.frame.size.width)*index, 0) animated:NO];
}
- (void)addOtherSubViews:(NSInteger)indexT {
    if (indexT == 1) {
        BOOL ishave = [self.subViewControllers containsObject:_extraVC];
        if (!ishave) {
            _extraVC = [[SIMNewPlanListViewController alloc] init];
            _extraVC.type = @"device";
            [self addChildViewController:_extraVC];
            _extraVC.view.frame = CGRectMake(screen_width, 0, screen_width, _baseScrollView.height);
            [_baseScrollView addSubview:_extraVC.view];
            [self.subViewControllers addObject:_extraVC];
            NSLog(@"没有包含第一个 执行了");
        }else {
            NSLog(@"已经包含第一个 执行了");
        }
    }else if (indexT == 2) {
        BOOL ishave = [self.subViewControllers containsObject:_nowPVC];
        if (!ishave) {
            _nowPVC = [[SIMNowPlanViewController alloc] init];
            _nowPVC.buttonType = @"nowPlan";
            [self addChildViewController:_nowPVC];
            _nowPVC.view.frame = CGRectMake(screen_width * 2, 0, screen_width, _baseScrollView.height);
            [_baseScrollView addSubview:_nowPVC.view];
            [self.subViewControllers addObject:_nowPVC];
            NSLog(@"没有包含第二个 执行了");
        }else {
            NSLog(@"已经包含第二个 执行了");
        }
        
    }else if (indexT == 3) {
        BOOL ishave = [self.subViewControllers containsObject:_nowSVC];
        if (!ishave) {
            _nowSVC = [[SIMNowServiceViewController alloc] init];
            [self addChildViewController:_nowSVC];
            _nowSVC.view.frame = CGRectMake(screen_width * 3, 0, screen_width, _baseScrollView.height);
            [_baseScrollView addSubview:_nowSVC.view];
            [self.subViewControllers addObject:_nowSVC];
            NSLog(@"没有包含第二个 执行了");
        }else {
            NSLog(@"已经包含第二个 执行了");
        }
        
    }
}



@end
