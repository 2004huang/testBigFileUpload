//
//  SIMMainReservateOrderViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/10/31.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMMainReservateOrderViewController.h"

#import "SIMReservateOrderViewController.h"
#import "SIMNewPlanChossen.h"

@interface SIMMainReservateOrderViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_baseScrollView;// 滚动视图
    
    SIMReservateOrderViewController *_allVC;// 全部VC
    SIMReservateOrderViewController *_paymentVC;// 待付款VC
    SIMReservateOrderViewController *_deliverVC;// 待发货VC
    SIMReservateOrderViewController *_receiptVC;// 待收货VC
    SIMReservateOrderViewController *_completeVC;// 已完成VC
}

@property (nonatomic, strong) NSMutableArray <UIViewController *> *subViewControllers;
@property (nonatomic, strong) SIMNewPlanChossen *segmentView;
@end

@implementation SIMMainReservateOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = SIMLocalizedString(@"NPayReservationOrderTitle", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _subViewControllers = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segmentView];
    [self addScrollViews];// 添加分段控制器以及滚动子视图
}

#pragma mark -- lazyload
- (SIMNewPlanChossen *)segmentView {
    if (!_segmentView) {
        self.segmentView = [[SIMNewPlanChossen alloc] initWithTitles:@[SIMLocalizedString(@"NPayHistoryOneTitle", nil),SIMLocalizedString(@"NPayResOrdPaymentTitle", nil),SIMLocalizedString(@"NPayResOrdDeliverTitle", nil),SIMLocalizedString(@"NPayResOrdReceiptTitle", nil),SIMLocalizedString(@"NPayResOrdCompleteTitle", nil)]  frame:CGRectMake(0, 0, screen_width, 46) selectIndex:0 hasLine:NO hasSlider:YES];
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
    _allVC = [[SIMReservateOrderViewController alloc] init];
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
        BOOL ishave = [self.subViewControllers containsObject:_paymentVC];
        if (!ishave) {
            _paymentVC = [[SIMReservateOrderViewController alloc] init];
            _paymentVC.pageIndex = 1;
            [self addChildViewController:_paymentVC];
            _paymentVC.view.frame = CGRectMake(screen_width, 0, screen_width, _baseScrollView.height);
            [_baseScrollView addSubview:_paymentVC.view];
            [self.subViewControllers addObject:_paymentVC];
            NSLog(@"没有包含第一个 执行了");
        }else {
            NSLog(@"已经包含第一个 执行了");
        }
        
    }else if (indexT == 2) {
        BOOL ishave = [self.subViewControllers containsObject:_deliverVC];
        if (!ishave) {
            _deliverVC = [[SIMReservateOrderViewController alloc] init];
            _deliverVC.pageIndex = 2;
            [self addChildViewController:_deliverVC];
            _deliverVC.view.frame = CGRectMake(screen_width * 2, 0, screen_width, _baseScrollView.height);
            [_baseScrollView addSubview:_deliverVC.view];
            [self.subViewControllers addObject:_deliverVC];
            NSLog(@"没有包含第二个 执行了");
        }else {
            NSLog(@"已经包含第二个 执行了");
        }
        
    }
    else if (indexT == 3) {
        BOOL ishave = [self.subViewControllers containsObject:_receiptVC];
        if (!ishave) {
            _receiptVC = [[SIMReservateOrderViewController alloc] init];
            _receiptVC.pageIndex = 3;
            [self addChildViewController:_receiptVC];
            _receiptVC.view.frame = CGRectMake(screen_width * 3, 0, screen_width, _baseScrollView.height);
            [_baseScrollView addSubview:_receiptVC.view];
            [self.subViewControllers addObject:_receiptVC];
            NSLog(@"没有包含第三个 执行了");
        }else {
            NSLog(@"已经包含第三个 执行了");
        }

    }
    else if (indexT == 4) {
        BOOL ishave = [self.subViewControllers containsObject:_completeVC];
        if (!ishave) {
            _completeVC = [[SIMReservateOrderViewController alloc] init];
            _completeVC.pageIndex = 3;
            [self addChildViewController:_completeVC];
            _completeVC.view.frame = CGRectMake(screen_width * 3, 0, screen_width, _baseScrollView.height);
            [_baseScrollView addSubview:_completeVC.view];
            [self.subViewControllers addObject:_completeVC];
            NSLog(@"没有包含第三个 执行了");
        }else {
            NSLog(@"已经包含第三个 执行了");
        }

    }
}

@end


