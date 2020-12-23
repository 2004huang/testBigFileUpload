//
//  SIMConfRoomListViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/5/14.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMConfRoomListViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "SIMConfRoomPopView.h"

@interface SIMConfRoomListViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (strong,nonatomic) SIMBaseTableView* tableView;
@property (nonatomic, strong) NSMutableArray *mutArray;
@property (nonatomic, strong) UIButton *findBtn;
@property (nonatomic, strong) UIView *backView;// 蒙层
@property (nonatomic, strong) SIMConfRoomPopView *popAddView;// 添加人员视图

@end

@implementation SIMConfRoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubViews];
    [self addBottomUI];
}
- (void)addSubViews {
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"邀请联系人"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addFriendClick)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
//    self.tableView = [[ alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH) style:UITableViewStyleGrouped];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
//    [self.tableView setSeparatorColor:ZJYColorHex(@"#e3e3e4")];
//    self.tableView.backgroundColor = ;
//    [self.view addSubview:self.tableView];
//    self.tableView.tableFooterView = [[UIView alloc] init];
    
//    [self.tableView registerClass:[SIMOtherContactTableViewCell class] forCellReuseIdentifier:@"SIMOtherContactTableViewCell"];
}
#pragma mark - TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mutArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SIMOtherContactTableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"SIMOtherContactTableViewCell"];
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark -- DZNEmptyDataSetSource
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -StatusNavH;
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"您还没有购买会议室";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:FontRegularName(15),
                                 NSForegroundColorAttributeName:BlackTextColor,
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (void)addBottomUI {
    _findBtn = [[UIButton alloc] init];
    [_findBtn setTitle:@"查看设备" forState:UIControlStateNormal];
    [_findBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_findBtn setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_findBtn setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    _findBtn.layer.masksToBounds = YES;
    _findBtn.layer.cornerRadius = 45/4;
    _findBtn.backgroundColor = BlueButtonColor;
    [_findBtn addTarget:self action:@selector(pushTheNextPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_findBtn];
    [_findBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-(BottomSaveH+15));
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(45);
        make.right.mas_equalTo(-15);
    }];
}
- (void)pushTheNextPage {
    NSLog(@"点击了查看设备");
}
- (void)addFriendClick {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.2;
    _popAddView = [[SIMConfRoomPopView alloc] initWithFrame:CGRectMake(screen_width/2 - 260/2, screen_height/2 - 150/2 - StatusNavH, 260,150)];
    [UIView animateWithDuration:0.4 animations:^{
        [window addSubview:_backView];
        [window addSubview:_popAddView];
    }];
    __weak typeof(self)weakSelf = self;
    __weak typeof(SIMConfRoomPopView *)weakLittle = _popAddView;
    _popAddView.cancelClickBlock = ^{
        [weakSelf tapClick];// 取消按钮方法
    };
    // 保存按钮方法
    _popAddView.addClickBlock = ^{
        // 保存按钮方法 添加人的手机号
        if (weakLittle.textF.text.length <= 0) {
            [MBProgressHUD cc_showText:@"请输入序列号"];
            return;
        }
//        [weakSelf addContractorRequest];
        [weakSelf tapClick];
    };
}
// window点击手势
- (void)tapClick {
    
    [UIView animateWithDuration:0.2 animations:^{
        _backView.alpha = 0;
        _popAddView.alpha = 0;
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        [_popAddView removeFromSuperview];
        _backView = nil;
        _popAddView = nil;
    }];
    
    
}
@end
