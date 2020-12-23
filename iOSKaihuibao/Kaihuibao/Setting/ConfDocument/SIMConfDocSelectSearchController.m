//
//  SIMConfDocSelectSearchController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/9/9.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMConfDocSelectSearchController.h"
#import "SIMConfDocSelectCell.h"
#import "SIMConfDocModel.h"

@interface SIMConfDocSelectSearchController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SIMConfDocSelectSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.tableFooterView = [UIView new];
    //    CGFloat searchHei;
    //    if (@available(iOS 11.0, *)) {
    //        searchHei = 55;
    self.tableView.frame = CGRectMake(0, isIPhoneXAll ? StatusNavH + 10 : StatusNavH, screen_width, screen_height - (isIPhoneXAll ? StatusNavH + 10 : StatusNavH));
    //        self.tableView.frame = CGRectMake(0, StatusNavH, screen_width, screen_height);
    //    }else {
    //        searchHei = 44;
    //        self.tableView.frame = CGRectMake(0, searchHei+StatusBarH, screen_width, screen_height - searchHei);
    //    }
    [self.tableView registerClass:[SIMConfDocSelectCell class] forCellReuseIdentifier:@"SIMConfDocSelectCell"];
    [self.view addSubview:self.tableView];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMConfDocSelectCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"SIMConfDocSelectCell"];
    commonCell.model = _datas[indexPath.row];
    return commonCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 是添加按钮 才可以展示详情页面 如果有邀请按钮 那么不需要cell点击查看详情
    SIMConfDocModel *model = self.datas[indexPath.row];
    model.isSelect = !model.isSelect;
    if (model.isSelect) {
        [_chooseArr addObject:model];
    }else {
        [_chooseArr removeObject:model];
        
    }
    [self.tableView reloadData];
}

@end
