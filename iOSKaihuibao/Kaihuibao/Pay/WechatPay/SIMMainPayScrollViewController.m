//
//  SIMMainPayScrollViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/11.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMMainPayScrollViewController.h"
#import "SIMNewPlanChossen.h"
//#import "SIMWXpayViewController.h"
#import "SIMHistoryPayOrderController.h"


@interface SIMMainPayScrollViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_baseScrollView;// 滚动视图
    
    SIMHistoryPayOrderController *_allVC;// 全部VC
    SIMHistoryPayOrderController *_successVC;// 成功VC
    SIMHistoryPayOrderController *_failVC;// 失败VC
    SIMHistoryPayOrderController *_cancelVC;// 取消VC
}

@property (nonatomic, strong) NSMutableArray <UIViewController *> *subViewControllers;
@property (nonatomic, strong) SIMNewPlanChossen *segmentView;

@end

@implementation SIMMainPayScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = SIMLocalizedString(@"SBuyOrder", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _subViewControllers = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segmentView];
    [self addScrollViews];// 添加分段控制器以及滚动子视图
}

#pragma mark -- lazyload
- (SIMNewPlanChossen *)segmentView {
    if (!_segmentView) {
        self.segmentView = [[SIMNewPlanChossen alloc] initWithTitles:@[SIMLocalizedString(@"NPayHistoryOneTitle", nil),SIMLocalizedString(@"NPayAlertViewsucess", nil),SIMLocalizedString(@"NPayAlertViewfail", nil),SIMLocalizedString(@"NPayAlertViewNoPayed", nil)]  frame:CGRectMake(0, 0, screen_width, 46) selectIndex:0 hasLine:NO hasSlider:YES];
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
    _baseScrollView.contentSize = CGSizeMake(screen_width*4, _baseScrollView.height);
    _baseScrollView.bounces = NO;
    _baseScrollView.delegate = self;
    _baseScrollView.scrollEnabled = NO;
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_baseScrollView];
    _allVC = [[SIMHistoryPayOrderController alloc] init];
    _allVC.view.frame = CGRectMake(0, 0, screen_width, _baseScrollView.height);
    _allVC.pageIndex = 0;
    [self addChildViewController:_allVC];
    [_baseScrollView addSubview:_allVC.view];
    [self.subViewControllers addObject:_allVC];

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
        BOOL ishave = [self.subViewControllers containsObject:_successVC];
        if (!ishave) {
            _successVC = [[SIMHistoryPayOrderController alloc] init];
            _successVC.pageIndex = 1;
            [self addChildViewController:_successVC];
            _successVC.view.frame = CGRectMake(screen_width, 0, screen_width, _baseScrollView.height);
            [_baseScrollView addSubview:_successVC.view];
            [self.subViewControllers addObject:_successVC];
            NSLog(@"没有包含第一个 执行了");
        }else {
            NSLog(@"已经包含第一个 执行了");
        }
        
    }else if (indexT == 2) {
        BOOL ishave = [self.subViewControllers containsObject:_failVC];
        if (!ishave) {
            _failVC = [[SIMHistoryPayOrderController alloc] init];
            _failVC.pageIndex = 2;
            [self addChildViewController:_failVC];
            _failVC.view.frame = CGRectMake(screen_width * 2, 0, screen_width, _baseScrollView.height);
            [_baseScrollView addSubview:_failVC.view];
            [self.subViewControllers addObject:_failVC];
            NSLog(@"没有包含第二个 执行了");
        }else {
            NSLog(@"已经包含第二个 执行了");
        }
        
    }
    else if (indexT == 3) {
        BOOL ishave = [self.subViewControllers containsObject:_cancelVC];
        if (!ishave) {
            _cancelVC = [[SIMHistoryPayOrderController alloc] init];
            _cancelVC.pageIndex = 3;
            [self addChildViewController:_cancelVC];
            _cancelVC.view.frame = CGRectMake(screen_width * 3, 0, screen_width, _baseScrollView.height);
            [_baseScrollView addSubview:_cancelVC.view];
            [self.subViewControllers addObject:_cancelVC];
            NSLog(@"没有包含第三个 执行了");
        }else {
            NSLog(@"已经包含第三个 执行了");
        }

    }
}


@end
