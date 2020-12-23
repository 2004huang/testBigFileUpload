//
//  SIMConfAllViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2020/3/13.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "SIMConfAllViewController.h"
#import "SIMNewConfListViewController.h"
//#import "SIMConfDocumentViewController.h"
#import "SIMConfVideoViewController.h"
#import "SIMNewPlanChossen.h"


@interface SIMConfAllViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_baseScrollView;// 滚动视图
    
    SIMNewConfListViewController *_allVC;
//    SIMConfDocumentViewController *_successVC;
//    SIMConfVideoViewController *_failVC;
}

@property (nonatomic, strong) NSMutableArray *subViewControllerIndex;
@property (nonatomic, strong) SIMNewPlanChossen *segmentView;
@property (nonatomic, strong) NSMutableArray *arrM;
@property (nonatomic, assign) CGFloat segmentHei;

@end

@implementation SIMConfAllViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = SIMLocalizedString(@"TabBarConfTitle", nil);
    _subViewControllerIndex = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
#if TypeClassBao
    _arrM = [[NSMutableArray alloc] init];
    _segmentHei = 0;
#else
    _arrM = [[NSMutableArray alloc] initWithObjects:@"会议",@"国际会议", nil];
    _segmentHei = 45;
    [self.view addSubview:self.segmentView];
#endif
    
    [self addScrollViews];// 添加分段控制器以及滚动子视图
}

#pragma mark -- lazyload
- (SIMNewPlanChossen *)segmentView {
    if (!_segmentView) {
        _segmentView = [[SIMNewPlanChossen alloc] initWithTitles:_arrM  frame:CGRectMake(0, 0, screen_width, _segmentHei) selectIndex:0 hasLine:NO hasSlider:YES];
        _segmentView.backgroundColor = ZJYColorHex(@"#f7f7f7");
        __weak typeof(self) weakSelf = self;
        [_segmentView setDidClickAtIndex:^(NSInteger index) {
            [weakSelf navigationDidSelectedControllerIndex:index];
        }];
    }
    return _segmentView;
}

- (void)addScrollViews {
    //添加滚动视图
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _segmentHei, screen_width, screen_height - TabbarH - StatusNavH - _segmentHei)];
    _baseScrollView.contentSize = CGSizeMake(screen_width*_arrM.count, _baseScrollView.height);
    _baseScrollView.delegate = self;
    _baseScrollView.bounces = NO;
    _baseScrollView.scrollEnabled = NO;
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_baseScrollView];
    
    [self addOtherSubViews:0];
//    _allVC = [[SIMNewConfListViewController alloc] init];
//    _allVC.view.frame = CGRectMake(0, 0, screen_width, _baseScrollView.height);
//    [self addChildViewController:_allVC];
//    [_baseScrollView addSubview:_allVC.view];
//    [self.subViewControllers addObject:_allVC];

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _baseScrollView) {
        //实时计算当前位置,实现和titleView上的按钮的联动
        [self.segmentView scrollToIndex:scrollView.contentOffset.x];
        NSInteger indexT = scrollView.contentOffset.x / screen_width;
        [self addOtherSubViews:indexT];
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _baseScrollView) {
        [self.segmentView scrollToIndex:scrollView.contentOffset.x];
        NSInteger indexT = scrollView.contentOffset.x / screen_width;
        [self addOtherSubViews:indexT];
    }
    
}

#pragma mark - PrivateMethod
- (void)navigationDidSelectedControllerIndex:(NSInteger)index {
    [_baseScrollView setContentOffset:CGPointMake((_baseScrollView.frame.size.width)*index, 0) animated:NO];
}

- (void)addOtherSubViews:(NSInteger)indexT {
    BOOL ishave = [self.subViewControllerIndex containsObject:[NSString stringWithFormat:@"%ld",(long)indexT]];
    if (!ishave) {
        if (indexT == 0) {
            _allVC = [[SIMNewConfListViewController alloc] init];
            _allVC.view.frame = CGRectMake(0, 0, screen_width, _baseScrollView.height);
            [self addChildViewController:_allVC];
            [_baseScrollView addSubview:_allVC.view];
            [self.subViewControllerIndex addObject:[NSString stringWithFormat:@"%ld",indexT]];
        }else {
            SIMConfVideoViewController *listVC = [[SIMConfVideoViewController alloc] init];
            [self addChildViewController:listVC];
            listVC.view.frame = CGRectMake(screen_width * indexT, 0, screen_width, _baseScrollView.frame.size.height);
            [_baseScrollView addSubview:listVC.view];
            [self.subViewControllerIndex addObject:[NSString stringWithFormat:@"%ld",indexT]];
        }
        NSLog(@"没有包含第%ld个 执行了",indexT);
    }else {
        NSLog(@"已经包含第%ld个 执行了",indexT);
    }
    
}

@end
