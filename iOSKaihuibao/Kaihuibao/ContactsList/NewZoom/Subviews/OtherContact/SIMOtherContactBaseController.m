//
//  SIMOtherContactBaseController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/5/13.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMOtherContactBaseController.h"

#import "SIMOhterContactSubController.h"

#import "SIMSegmentView.h"

@interface SIMOtherContactBaseController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *baseScrollView;// 滚动视图
@property (nonatomic, strong) SIMOhterContactSubController *recommendVC;
@property (nonatomic, strong) SIMOhterContactSubController *companyVC;
@property (nonatomic, strong) SIMOhterContactSubController *mineVC;

@property (nonatomic, strong) SIMSegmentView *segmentView;
@property (nonatomic, strong) NSMutableArray <UIViewController *> *subViewControllers;


@end

@implementation SIMOtherContactBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addFriendClick)];
//    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [self.view addSubview:self.segmentView];// 添加分段控制器
    [self addScrollViews];// 添加滚动子视图
}
// 导航视图
- (SIMSegmentView *)segmentView {
    if (!_segmentView) {
        self.segmentView = [[SIMSegmentView alloc] initWithTitles:@[@"推荐",@"全公司的",@"我的"] frame:CGRectMake(0, 0, screen_width, 46)];
        self.segmentView.titleStr = @"推荐";
        __weak typeof(self) weakSelf = self;
        [self.segmentView setDidClickAtIndex:^(NSInteger index){
            [weakSelf navigationDidSelectedControllerIndex:index];
        }];
    }
    return _segmentView;
}
- (void)addScrollViews {
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _segmentView.bottom, screen_width, screen_height - StatusNavH - _segmentView.height)];
    _baseScrollView.contentSize = CGSizeMake(screen_width, _baseScrollView.frame.size.height);
    _baseScrollView.bounces = NO;
    _baseScrollView.delegate = self;
    _baseScrollView.scrollEnabled = NO;
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_baseScrollView];
    
    
    _baseScrollView.contentSize = CGSizeMake(screen_width, _baseScrollView.frame.size.height);
    _recommendVC = [[SIMOhterContactSubController alloc] init];
    _recommendVC.indexCount = 0;
    _recommendVC.view.frame = CGRectMake(0, 0, screen_width, _baseScrollView.frame.size.height);
    [self addChildViewController:_recommendVC];
    [_baseScrollView addSubview:_recommendVC.view];
    
    [self.subViewControllers addObject:_recommendVC];
    
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 实时计算当前位置,实现和titleView上的按钮的联动
    [self.segmentView scrollToIndex:scrollView.contentOffset.x];
    NSInteger indexT = scrollView.contentOffset.x / screen_width;
    [self addOtherSubViews:indexT];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.segmentView canSelectedWidthIndex:scrollView.contentOffset.x];
    NSInteger indexT = scrollView.contentOffset.x / screen_width;
    [self addOtherSubViews:indexT];
}

#pragma mark - PrivateMethod
- (void)navigationDidSelectedControllerIndex:(NSInteger)index {
    [_baseScrollView setContentOffset:CGPointMake((_baseScrollView.frame.size.width)*index, 0) animated:NO];
    
}

- (void)addOtherSubViews:(NSInteger)indexT {
    if (indexT == 1) {
        BOOL ishave = [self.subViewControllers containsObject:_companyVC];
        if (!ishave) {
            _companyVC = [[SIMOhterContactSubController alloc] init];
            _companyVC.view.frame = CGRectMake(screen_width, 0, screen_width, _baseScrollView.frame.size.height);
            _companyVC.indexCount = indexT;
            [self addChildViewController:_companyVC];
            [_baseScrollView addSubview:_companyVC.view];
            [self.subViewControllers addObject:_companyVC];
            
        }else {
            
        }
        
    }else if (indexT == 2) {
        BOOL ishave = [self.subViewControllers containsObject:_mineVC];
        if (!ishave) {
            _mineVC = [[SIMOhterContactSubController alloc] init];
            _mineVC.indexCount = indexT;
            _mineVC.view.frame = CGRectMake(screen_width * 2, 0, screen_width, _baseScrollView.frame.size.height);
            [self addChildViewController:_mineVC];
            [_baseScrollView addSubview:_mineVC.view];
            [self.subViewControllers addObject:_mineVC];
            
        }
    }
}
#pragma mark -- event
- (void)addFriendClick {
    
}
@end
