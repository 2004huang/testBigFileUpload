//
//  SIMConfVideoViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2020/3/12.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "SIMConfVideoViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "SIMCustomFooterView.h"

@interface SIMConfVideoViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSArray<NSArray<UITableViewCell*>*>* _cells;
}
@property (nonatomic,strong) SIMBaseTableView* tableView;
@property(nonatomic,strong) SIMCustomFooterView *headerView;

@end

@implementation SIMConfVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubUIs];
}
- (void)addSubUIs {
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height - TabbarH - StatusNavH - 45);
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    if (_ishaveHeader) {
        _headerView = [[SIMCustomFooterView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 100)];
        _headerView.arr = @[
        @{@"titleName":@"我的视频",@"bannerPic":@"mess_我的视频"},
        @{@"titleName":@"会议录像",@"bannerPic":@"mess_会议录像"},
        @{@"titleName":@"共享视频",@"bannerPic":@"mess_共享视频"}
        ];
        _headerView.indexTagBlock = ^(NSInteger btnserial) {
            [MBProgressHUD cc_showText:@"暂无该功能"];
        };
        self.tableView.tableHeaderView = _headerView;
    }
    
    
    
}
#pragma mark -- UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;// 改数据源
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -- DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_tableview_icon"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"列表目前为空";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:FontRegularName(14),
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
