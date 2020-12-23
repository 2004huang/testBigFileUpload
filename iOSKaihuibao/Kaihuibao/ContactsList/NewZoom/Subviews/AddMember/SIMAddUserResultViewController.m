//
//  SIMAddUserResultViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/7/9.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMAddUserResultViewController.h"


#import "SIMContants.h"
#import "SIMAddFromAdressCell.h"

@interface SIMAddUserResultViewController ()<UITableViewDelegate,UITableViewDataSource>
@end
static NSString *reuse1 = @"SIMAddFromAdressCell";
@implementation SIMAddUserResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _chooseArr = [NSMutableArray array];
    NSLog(@"_chooseArr_chooseArr %@ %p",_chooseArr,_chooseArr);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.frame = CGRectMake(0, isIPhoneXAll ? StatusNavH + 10 : StatusNavH, screen_width, screen_height - (isIPhoneXAll ? StatusNavH + 10 : StatusNavH));
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[SIMAddFromAdressCell class] forCellReuseIdentifier:reuse1];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.searchResults.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SIMAddFromAdressCell *addCell = [tableView dequeueReusableCellWithIdentifier:reuse1];
    SIMContants *ss = self.searchResults[indexPath.row];
    addCell.contants = ss;
    return addCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 是添加按钮 才可以展示详情页面 如果有邀请按钮 那么不需要cell点击查看详情
    SIMContants *person = self.searchResults[indexPath.row];
    person.isSelectt = !person.isSelectt;
    if (person.isSelectt) {
        [_chooseArr addObject:person];
    }else {
        [_chooseArr removeObject:person];
        
    }
    if (_chooseArr.count >= 50) {
//        [MBProgressHUD cc_showText:@"一次最多选择50人"];
        for (SIMContants *person in _searchResults) {
            person.isNotClick = YES;
        }
        for (SIMContants *person in _chooseArr) {
            person.isNotClick = NO;
        }
    }else {
        for (SIMContants *person in _searchResults) {
            person.isNotClick = NO;
        }
    }
    [self.tableView reloadData];
    NSLog(@"_chooseArr_chooseArr222 %@ %p",_chooseArr,_chooseArr);
}


@end
