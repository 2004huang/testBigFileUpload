//
//  SIMMainPlanDetailViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/11.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMMainPlanDetailViewController.h"
#import "SIMPayNewSegment.h"
//#import "SIMPayPlanDetailViewController.h"
//#import "SIMPayPlanModel.h"
#import "SIMNewPlanChossen.h"
#import "SIMServerCenterListViewController.h"
@interface SIMMainPlanDetailViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *baseScrollView;// 滚动视图
@property (nonatomic, strong) NSMutableArray *dataArr; // topsegment的arr

@property (nonatomic, strong) NSMutableArray  *subViewControllerIndex;
@property (nonatomic, strong) SIMPayNewSegment *segmentView;
@property (nonatomic, strong) SIMNewPlanChossen *newChoosenView;

@end

@implementation SIMMainPlanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = SIMLocalizedString(@"ServiceCenterTitle", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArr = [[NSMutableArray alloc] init];
    _subViewControllerIndex = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getDatas];
}
#pragma mark -- lazyload
- (SIMPayNewSegment *)segmentView {
    if (!_segmentView) {
        NSMutableArray *arrm = [NSMutableArray array];
        for (NSDictionary *dic in _dataArr) {
            [arrm addObject:dic[@"name"]];
        }
        self.segmentView = [[SIMPayNewSegment alloc] initWithTitles:arrm  frame:CGRectMake(0, 0, screen_width, 44) selectIndex:0 hasLine:YES];
        __weak typeof(self) weakSelf = self;
        [self.segmentView setDidClickAtIndex:^(NSInteger index) {
            [weakSelf navigationDidSelectedControllerIndex:index];
        }];
    }
    return _segmentView;
}

- (SIMNewPlanChossen *)newChoosenView {
    if (!_newChoosenView) {
        NSMutableArray *arrm = [NSMutableArray array];
        for (NSDictionary *dic in _dataArr) {
            [arrm addObject:dic[@"name"]];
        }
        self.newChoosenView = [[SIMNewPlanChossen alloc] initWithTitles:arrm  frame:CGRectMake(0, 0, screen_width, 44) selectIndex:0 hasLine:NO hasSlider:YES];
        __weak typeof(self) weakSelf = self;
        [self.newChoosenView setDidClickAtIndex:^(NSInteger index) {
            [weakSelf navigationDidSelectedControllerIndex:index];
        }];
    }
    return _newChoosenView;
}
- (void)addScrollViews {
    //添加滚动视图
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, screen_width, screen_height - StatusNavH - 44)];
    _baseScrollView.contentSize = CGSizeMake(screen_width*_dataArr.count, _baseScrollView.frame.size.height);
    _baseScrollView.bounces = NO;
    _baseScrollView.delegate = self;
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.backgroundColor = [UIColor whiteColor];
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_baseScrollView];
    
//    [_baseScrollView setContentOffset:CGPointMake(_baseScrollView.frame.size.width * self.indexStr, 0) animated:NO];
    
    if (self.dataArr.count > 0) {
        [self addOtherSubViews:0];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_dataArr.count > 4) {
        // 大于四个 让他不限屏幕根据文字算并且是滚动控件
        //实时计算当前位置,实现和titleView上的按钮的联动
        [self.segmentView scrollToIndex:scrollView.contentOffset.x];
        NSInteger indexT = scrollView.contentOffset.x / screen_width;
        [self addOtherSubViews:indexT];
        
        if (self.segmentView.contentSize.width < self.segmentView.frame.size.width) {
            // 滚动标题滚动条
            [self.segmentView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else {
            for (UIButton *bun in self.segmentView.subviews) {
                if (bun.tag == (int)indexT + 100) {
                    CGFloat offsetX = bun.center.x - screen_width * 0.5;
                    if (offsetX < 0) offsetX = 0;
                    // 获取最大滚动范围
                    CGFloat maxOffsetX = self.segmentView.contentSize.width - screen_width;
                    
                    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
                    
                    // 滚动标题滚动条
                    [self.segmentView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
                }
            }
        }
    }else {
        // 小于四个 让他仅限屏幕宽 不可滚动 按钮大小是固定的
        //实时计算当前位置,实现和titleView上的按钮的联动
        [self.newChoosenView scrollToIndex:scrollView.contentOffset.x];
        NSInteger indexT = scrollView.contentOffset.x / screen_width;
        [self addOtherSubViews:indexT];
    }
    
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _baseScrollView) {
        if (_dataArr.count > 4) {
            // 大于四个 让他不限屏幕根据文字算并且是滚动控件
            [self.segmentView scrollToIndex:scrollView.contentOffset.x];
            NSInteger indexT = scrollView.contentOffset.x / screen_width;
            [self addOtherSubViews:indexT];
        }else {
            // 小于四个 让他仅限屏幕宽 不可滚动 按钮大小是固定的
            [self.newChoosenView scrollToIndex:scrollView.contentOffset.x];
            NSInteger indexT = scrollView.contentOffset.x / screen_width;
            [self addOtherSubViews:indexT];
        }
        
    }
}

#pragma mark - PrivateMethod
- (void)navigationDidSelectedControllerIndex:(NSInteger)index {
    [_baseScrollView setContentOffset:CGPointMake((_baseScrollView.frame.size.width)*index, 0) animated:YES];
    
}
- (void)addOtherSubViews:(NSInteger)indexT {
    BOOL ishave = [self.subViewControllerIndex containsObject:[NSString stringWithFormat:@"%ld",(long)indexT]];
    if (!ishave) {
        SIMServerCenterListViewController *listVC = [[SIMServerCenterListViewController alloc] init];
        NSDictionary *dic = _dataArr[indexT];
        listVC.serial = dic[@"id"];
        [self addChildViewController:listVC];
        listVC.view.frame = CGRectMake(screen_width * indexT, 0, screen_width, _baseScrollView.frame.size.height);
        [_baseScrollView addSubview:listVC.view];
        [self.subViewControllerIndex addObject:[NSString stringWithFormat:@"%ld",indexT]];
        NSLog(@"没有包含第%ld个 执行了",indexT);
    }else {
        NSLog(@"已经包含第%ld个 执行了",indexT);
    }
    
}

- (void)getDatas {
    [MainNetworkRequest servicecenterSortlistRequestParams:nil success:^(id success) {
        NSLog(@"severCenterListsuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            for (NSDictionary *dic in success[@"data"]) {
                [_dataArr addObject:dic];
            }
            if (_dataArr.count>4) {
                // 大于四个 让他不限屏幕根据文字算并且是滚动控件
                [self.view addSubview:self.segmentView];
            }else {
                // 小于四个 让他仅限屏幕宽 不可滚动 按钮大小是固定的
                [self.view addSubview:self.newChoosenView];
            }
            [self addScrollViews];// 添加分段控制器以及滚动子视图
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
}


@end
