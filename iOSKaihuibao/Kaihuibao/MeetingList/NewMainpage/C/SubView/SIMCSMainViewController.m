//
//  SIMCSMainViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2020/6/28.
//  Copyright © 2020 Ferris. All rights reserved.
//
#define Segment_Height 45    // 高

#import "SIMCSMainViewController.h"
#import "SIMConfVideoViewController.h"
#import "SIMConfDocumentViewController.h"
#import "SIMNewPlanChossen.h"

@interface SIMCSMainViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *baseScrollView;
//@property (nonatomic, strong) SIMConfDocumentViewController *successVC;
//@property (nonatomic, strong) SIMConfVideoViewController *failVC;
@property (nonatomic, strong) NSMutableArray *subViewControllers;
@property (nonatomic, strong) SIMNewPlanChossen *segmentView;
@property (nonatomic, strong) NSMutableArray *arrM;

@end

@implementation SIMCSMainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    _subViewControllers = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    _arrM = [[NSMutableArray alloc] init];
  
    if (self.cloudVersion.webFileUrl.length > 0) {
        [_arrM addObject:@"团队空间"];
        [_arrM addObject:@"会议文件"];
        [_arrM addObject:@"我的文件"];
    }
    [_arrM addObject:@"相册视频"];
//    if ([self.cloudVersion.video_playback boolValue]) {
//        [_arrM addObject:SIMLocalizedString(@"CloudSpaceVideoTitle", nil)];
//    }
//    self.navigationItem.titleView = self.segmentView;
    self.navigationItem.title = SIMLocalizedString(@"CloudSpaceTitle", nil);
    [self.view addSubview:self.segmentView];
    [self addScrollViews];// 添加分段控制器以及滚动子视图
}

#pragma mark -- lazyload
- (SIMNewPlanChossen *)segmentView {
    if (!_segmentView) {
        _segmentView = [[SIMNewPlanChossen alloc] initWithTitles:_arrM  frame:CGRectMake(0, 0, screen_width, Segment_Height) selectIndex:0 hasLine:NO hasSlider:YES];
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
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Segment_Height, screen_width, screen_height - StatusNavH - Segment_Height)];
    _baseScrollView.contentSize = CGSizeMake(screen_width*_arrM.count, _baseScrollView.height);
    _baseScrollView.delegate = self;
    _baseScrollView.bounces = NO;
    _baseScrollView.scrollEnabled = NO;
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_baseScrollView];
    
    [self addOtherSubViews:0];
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
    if (_arrM.count <= 0) {
        return;
    }
    NSString *string = _arrM[indexT];
    BOOL ishave = [self.subViewControllers containsObject:string];
    if (!ishave) {
        if ([string isEqualToString:@"团队空间"]) {
            SIMConfDocumentViewController *successVC = [[SIMConfDocumentViewController alloc] init];
            successVC.tabName = string;
            successVC.view.frame = CGRectMake(indexT *screen_width, 0, screen_width, _baseScrollView.height);
            [self addChildViewController:successVC];
            [_baseScrollView addSubview:successVC.view];
            [self.subViewControllers addObject:string];
        }
        if ([string isEqualToString:@"会议文件"]) {
            SIMConfDocumentViewController *successVC = [[SIMConfDocumentViewController alloc] init];
            successVC.view.frame = CGRectMake(indexT *screen_width, 0, screen_width, _baseScrollView.height);
            successVC.tabName = string;
            [self addChildViewController:successVC];
            [_baseScrollView addSubview:successVC.view];
            [self.subViewControllers addObject:string];
        }
        if ([string isEqualToString:@"我的文件"]) {
            SIMConfDocumentViewController *successVC = [[SIMConfDocumentViewController alloc] init];
            successVC.view.frame = CGRectMake(indexT *screen_width, 0, screen_width, _baseScrollView.height);
            successVC.tabName = string;
            [self addChildViewController:successVC];
            [_baseScrollView addSubview:successVC.view];
            [self.subViewControllers addObject:string];
        }
        if ([string isEqualToString:@"相册视频"]) {
            SIMConfVideoViewController *failVC = [[SIMConfVideoViewController alloc] init];
//            failVC.ishaveHeader = YES;
            failVC.view.frame = CGRectMake(indexT *screen_width, 0, screen_width, _baseScrollView.height);
            [self addChildViewController:failVC];
            [_baseScrollView addSubview:failVC.view];
            [self.subViewControllers addObject:string];
        }
        NSLog(@"没有包含第%@个 执行了",string);
    }else {
        NSLog(@"已经包含第%@个 执行了",string);
    }
    
}

@end
