//
//  SIMMineAppointViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/1/15.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMMineAppointViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface SIMMineAppointViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSArray<NSArray<UITableViewCell*>*>* _cells;
}
@property (nonatomic,strong) SIMBaseTableView* tableView;

@end

@implementation SIMMineAppointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
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
    return [UIImage imageNamed:@"logo"];
}


- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = self.titleStr;
    
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
