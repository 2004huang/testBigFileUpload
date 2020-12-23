//
//  SIMOhterContactSubController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/5/13.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMOhterContactSubController.h"

#import "SIMContactDetailViewController.h"

#import "SIMOtherContactTableViewCell.h"

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface SIMOhterContactSubController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *mutArray;
@end

@implementation SIMOhterContactSubController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}
- (void)setIndexCount:(NSInteger)indexCount {
    _indexCount = indexCount;
    if (_indexCount == 1) {
        _ishaveBtn = NO;
//        [self addDatas];
    }else if (_indexCount == 2){
        _ishaveBtn = NO;
//        [self addDatas];
    }else {
        _ishaveBtn = YES;
//        [self addDatas];
    }
    [self addSubViews];
}
- (void)addDatas {
    
    SIMContants *cont1 = [[SIMContants alloc] initWithDictionary:@{@"nickname":@"fdfsfd"}];
    SIMContants *cont2 = [[SIMContants alloc] initWithDictionary:@{@"nickname":@"ffd"}];
    SIMContants *cont3 = [[SIMContants alloc] initWithDictionary:@{@"nickname":@"fdj好地方fsfd"}];
    SIMContants *cont4 = [[SIMContants alloc] initWithDictionary:@{@"nickname":@"发哦挨个"}];
    _mutArray = [NSMutableArray arrayWithObjects:cont1,cont2,cont3,cont4,cont1,cont2,cont3,cont4,cont1,cont2,cont3,cont4,cont1,cont2,cont3,cont4, nil];
    [self.tableView reloadData];
}
- (void)addSubViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH - 46) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.tableView setSeparatorColor:ZJYColorHex(@"#e3e3e4")];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerClass:[SIMOtherContactTableViewCell class] forCellReuseIdentifier:@"SIMOtherContactTableViewCell"];
}
#pragma mark - TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.01; // 60
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [NSString stringWithFormat:@"共%ld人",_mutArray.count];
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 30)];
//    headerV.backgroundColor = ZJYColorHex(@"#f7f7f9");
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screen_width, 30)];
//    label.text = [NSString stringWithFormat:@"共%ld人",_mutArray.count];
//    label.font = FontRegularName(15);
//    label.textColor = BlackTextColor;
//    [headerV addSubview:label];
//    return headerV;
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001; // 30
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SIMOtherContactTableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"SIMOtherContactTableViewCell"];
//    commonCell.ishaveBtn = self.ishaveBtn;// 有没有邀请按钮
//    commonCell.contants = _mutArray[indexPath.row];
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    SIMContactDetailViewController *conver = [[SIMContactDetailViewController alloc] init];
//    conver.person = _mutArray[indexPath.row];
//    conver.person.isContant = NO;// 说明是部门
//    [self.navigationController pushViewController:conver animated:YES];
    
}

#pragma mark -- DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_tableview_icon"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无外部联系人";
    
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
