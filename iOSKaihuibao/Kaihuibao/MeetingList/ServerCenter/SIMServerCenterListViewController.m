//
//  SIMServerCenterListViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2020/5/28.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "SIMServerCenterListViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "SIMServerCenterListCell.h"
#import "SIMServerCenterCollectionViewCell.h"
#import "SIMServerCenterDetailViewController.h"

@interface SIMServerCenterListViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (strong,nonatomic) SIMBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UICollectionView *collectionV;

@end

@implementation SIMServerCenterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArr = [[NSMutableArray alloc] init];
    self.title = SIMLocalizedString(@"ServiceCenterDetailTitle", nil);
}
- (void)addTableViewUI {
    // 加载tableview
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height - 45 - StatusNavH);
    [self.tableView registerClass:[SIMServerCenterListCell class] forCellReuseIdentifier:@"SIMServerCenterListCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
}
- (void)addCollectionViewUI {
    // 加载collectionview
    NSInteger itemCount = 2;
    CGFloat itemSpace = (screen_width - 170 * itemCount) / 4;
    NSLog(@"itemSpace itemSpace %lf",itemSpace);
//    NSInteger itemCount = screen_width/125;
//    CGFloat itemSpace = ((NSInteger)screen_width % 125)/itemCount;
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.itemSize = CGSizeMake(170, 200);
    flow.minimumLineSpacing = 1;
    flow.minimumInteritemSpacing = itemSpace*2;
    flow.sectionInset = UIEdgeInsetsMake(0, itemSpace, 0, itemSpace);

    
    _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH - 45) collectionViewLayout:flow];
    _collectionV.backgroundColor = [UIColor whiteColor];
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    _collectionV.bounces = NO;
    [self.view addSubview:self.collectionV];
    [_collectionV registerClass:[SIMServerCenterCollectionViewCell class] forCellWithReuseIdentifier:@"SIMServerCenterCollectionViewCell"];
    
}

#pragma mark - TableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMServerCenterListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SIMServerCenterListCell"];
    cell.dic = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SIMServerCenterDetailViewController *detailVC = [[SIMServerCenterDetailViewController alloc] init];
    NSDictionary *dic = _dataArr[indexPath.row];
    detailVC.serial = dic[@"id"];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SIMServerCenterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SIMServerCenterCollectionViewCell" forIndexPath:indexPath];
    cell.dic = _dataArr[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath.item %ld",indexPath.item);
    SIMServerCenterDetailViewController *detailVC = [[SIMServerCenterDetailViewController alloc] init];
    NSDictionary *dic = _dataArr[indexPath.item];
    detailVC.serial = dic[@"id"];
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark -- DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_tableview_icon"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"该条目暂无内容";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:FontRegularName(15),
                                 NSForegroundColorAttributeName:TableViewHeaderColor,
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (void)setSerial:(NSString *)serial {
    _serial = serial;
    [self getDatas:_serial];
    
}
- (void)getDatas:(NSString *)serial {
    [MainNetworkRequest servicecenterlistRequestParams:@{@"sort_id":serial} success:^(id success) {
        NSLog(@"severCentertableListsuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            NSDictionary *tempDic = success[@"data"];
            for (NSDictionary *dic in tempDic[@"data"]) {
                [_dataArr addObject:dic];
            }
            if ([tempDic[@"arrangement"] isEqualToString:@"vertical"]) {
                // tableview
                [self addTableViewUI];
            }else {
                [self addCollectionViewUI];
            }
            
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
}
//
@end
