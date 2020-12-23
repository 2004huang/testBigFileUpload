//
//  SIMMainChatViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2020/6/13.
//  Copyright © 2020 Ferris. All rights reserved.
//
#define Segment_Height 45    // 高

#import "SIMMainChatViewController.h"
#import "SIMChatMessListViewController.h"
#import "ConversationController.h"
//#import "SIMConfVideoViewController.h"
//#import "SIMConfDocumentViewController.h"
#import "SIMNewPlanChossen.h"

@interface SIMMainChatViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) ConversationController *messageVC;
@property (nonatomic, strong) SIMChatMessListViewController *allVC;
//@property (nonatomic, strong) SIMConfDocumentViewController *successVC;
//@property (nonatomic, strong) SIMConfVideoViewController *failVC;
@property (nonatomic, strong) NSMutableArray *subViewControllers;
@property (nonatomic, strong) SIMNewPlanChossen *segmentView;
@property (nonatomic, strong) NSMutableArray *arrM;


@end

@implementation SIMMainChatViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    _subViewControllers = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    _arrM = [[NSMutableArray alloc] init];
    if ([self.cloudVersion.im boolValue]) {
        [_arrM addObject:SIMLocalizedString(@"IMNewChatTitle", nil)];
    }
    
    if ([self.cloudVersion.find boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
        [_arrM addObject:@"通知"];
    }
//    if (self.cloudVersion.webFileUrl.length > 0) {
//        [_arrM addObject:SIMLocalizedString(@"SConfDocumentCloud", nil)];
//    }
//    if ([self.cloudVersion.video_playback boolValue]) {
//        [_arrM addObject:SIMLocalizedString(@"CloudSpaceVideoTitle", nil)];
//    }
//    self.navigationItem.titleView = self.segmentView;
    self.navigationItem.title = SIMLocalizedString(@"TabBarMessageTitle", nil);
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
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Segment_Height, screen_width, screen_height - TabbarH - StatusNavH - Segment_Height)];
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
        if ([string isEqualToString:SIMLocalizedString(@"IMNewChatTitle", nil)]) {
            _messageVC = [[ConversationController alloc] init];
            _messageVC.view.frame = CGRectMake(indexT *screen_width, 0, screen_width, _baseScrollView.height);
            [self addChildViewController:_messageVC];
            [_baseScrollView addSubview:_messageVC.view];
            [self.subViewControllers addObject:string];
        }
        if ([string isEqualToString:@"通知"]) {
            _allVC = [[SIMChatMessListViewController alloc] init];
            _allVC.view.frame = CGRectMake(indexT *screen_width, 0, screen_width, _baseScrollView.height);
            [self addChildViewController:_allVC];
            [_baseScrollView addSubview:_allVC.view];
            [self.subViewControllers addObject:string];
        }
//        if ([string isEqualToString:SIMLocalizedString(@"SConfDocumentCloud", nil)]) {
//            _successVC = [[SIMConfDocumentViewController alloc] init];
//            _successVC.view.frame = CGRectMake(indexT *screen_width, 0, screen_width, _baseScrollView.height);
//            [self addChildViewController:_successVC];
//            [_baseScrollView addSubview:_successVC.view];
//            [self.subViewControllers addObject:string];
//        }
//        if ([string isEqualToString:SIMLocalizedString(@"CloudSpaceVideoTitle", nil)]) {
//            _failVC = [[SIMConfVideoViewController alloc] init];
//            _failVC.ishaveHeader = YES;
//            _failVC.view.frame = CGRectMake(indexT *screen_width, 0, screen_width, _baseScrollView.height);
//            [self addChildViewController:_failVC];
//            [_baseScrollView addSubview:_failVC.view];
//            [self.subViewControllers addObject:string];
//        }
        NSLog(@"没有包含第%@个 执行了",string);
    }else {
        NSLog(@"已经包含第%@个 执行了",string);
    }
    
}

@end
