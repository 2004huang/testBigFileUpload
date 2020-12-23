//
//  SIMConfDocSearchViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/9/5.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMConfDocSearchViewController.h"
#import "SIMConfDocListCell.h"
#import "SIMConfDocModel.h"
#import "SIMTempCompanyViewController.h"
#import "SIMConfShorthandViewController.h"

@interface SIMConfDocSearchViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SIMConfDocSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.frame = CGRectMake(0, StatusNavH, screen_width, screen_height - TabbarH - StatusNavH);
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.tableFooterView = [UIView new];
    //    CGFloat searchHei;
    //    if (@available(iOS 11.0, *)) {
    //        searchHei = 55;
    
    self.tableView.frame = CGRectMake(0, StatusNavH, screen_width, screen_height - StatusNavH - TabbarH);
    //        self.tableView.frame = CGRectMake(0, StatusNavH, screen_width, screen_height);
    //    }else {
    //        searchHei = 44;
    //        self.tableView.frame = CGRectMake(0, searchHei+StatusBarH, screen_width, screen_height - searchHei);
    //    }
    [self.tableView registerClass:[SIMConfDocListCell class] forCellReuseIdentifier:@"SIMConfDocListCell"];
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
    SIMConfDocListCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"SIMConfDocListCell"];
    if ([self.pageType isEqualToString:@"shorthand"]) {
        commonCell.shortmodel = _datas[indexPath.row];
    }else {
        commonCell.model = _datas[indexPath.row];
    }
    return commonCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.pageType isEqualToString:@"shorthand"]) {
        SIMConfShorthandViewController *confVC = [[SIMConfShorthandViewController alloc] init];
        confVC.model = _datas[indexPath.row];
        [self.mainSearchController.navigationController pushViewController:confVC animated:YES];
    }else {
        SIMTempCompanyViewController *webVC = [[SIMTempCompanyViewController alloc] init];
        SIMConfDocModel *model = _datas[indexPath.row];
        webVC.navigationItem.title = model.name;
        webVC.webStr = model.url;
        [self.mainSearchController.navigationController pushViewController:webVC animated:YES];
    }
//    SIMAdvertWebViewController *companyVC = [[SIMAdvertWebViewController alloc] init];
//    companyVC.navigationItem.title = SIMLocalizedString(@"SAbortUSConnect", nil);
//    SIMConfDocModel *model = _datas[indexPath.row];
//    companyVC.webStr = model.url;
//    [self.mainSearchController.navigationController pushViewController:companyVC animated:YES];
    
}

@end
