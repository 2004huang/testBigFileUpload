//
//  SIMSettingSubViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/11/28.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMSettingSubViewController.h"

#import "SIMSettingNewCell.h"
#import "SIMConfEditViewController.h"
#import "SIMMessageEditViewController.h"
#import "SIMLanguageChooseViewController.h"

@interface SIMSettingSubViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) SIMBaseTableView* tableView;
@property (strong,nonatomic) NSArray *cellDatas;

@end

@implementation SIMSettingSubViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"AlertCSet", nil);
    [self addDatas];
    // 加载tableview
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height - StatusNavH);
    [self.tableView registerClass:[SIMSettingNewCell class] forCellReuseIdentifier:@"SIMSettingNewCell"];
    [self.view addSubview:self.tableView];

}

#pragma mark - TableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellDatas.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellDatas[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMSettingNewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"SIMSettingNewCell"];
    commonCell.datas = self.cellDatas[indexPath.section][indexPath.row];
    return commonCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *indexDic = self.cellDatas[indexPath.section][indexPath.row];
    NSString *indexStr = indexDic[@"title"];
   if ([indexStr isEqualToString:SIMLocalizedString(@"SConfSetting", nil)]) {
        // 会议设置
        SIMConfEditViewController *confEdit = [[SIMConfEditViewController alloc] init];
        [self.navigationController pushViewController:confEdit animated:YES];
    }else if ([indexStr isEqualToString:SIMLocalizedString(@"SMessageNotify", nil)]) {
        // 消息通知
        SIMMessageEditViewController *messEdit = [[SIMMessageEditViewController alloc] init];
        [self.navigationController pushViewController:messEdit animated:YES];
    }else if ([indexStr isEqualToString:SIMLocalizedString(@"SLanguages", nil)]) {
        // 多语言环境
        SIMLanguageChooseViewController *langVC = [[SIMLanguageChooseViewController alloc] init];
        langVC.pageType = @"login";
        [self.navigationController pushViewController:langVC animated:YES];
    }

}
- (void)addDatas {
    NSMutableArray *section1 = [NSMutableArray array];
    // 分区
    [section1 addObject:@{@"icon":@"setting会议设置",
                          @"title":SIMLocalizedString(@"SConfSetting", nil)}];
    if ([self.cloudVersion.im boolValue]) {
        [section1 addObject:@{@"icon":@"setting消息通知",
                              @"title":SIMLocalizedString(@"SMessageNotify", nil)}];
    }
    if ([self.cloudVersion.many_languages boolValue]) {
        [section1 addObject:@{@"icon":@"setting多语言",
        @"title":SIMLocalizedString(@"SLanguages", nil)}];
    }
    
    self.cellDatas = @[section1];
}

@end
