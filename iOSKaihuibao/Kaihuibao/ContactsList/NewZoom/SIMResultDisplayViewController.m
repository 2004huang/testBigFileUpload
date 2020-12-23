//
//  SIMResultDisplayViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/30.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMResultDisplayViewController.h"
//#import "SIMGroupDetailViewController.h"
//#import "SIMNewDevSubViewController.h"
//#import "SIMContants.h"
//#import "SIMGroup.h"
#import "SIMNewConverViewController.h"
#import "SIMContactDetailViewController.h"
//#import "SIMDepartment.h"
#import "SIMListTableViewCell.h"

@interface SIMResultDisplayViewController ()<UITableViewDelegate,UITableViewDataSource>
@end

@implementation SIMResultDisplayViewController

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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SIMListTableViewCell class] forCellReuseIdentifier:@"SIMListTableViewCell"];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UItableViewcell"];
    [self.view addSubview:self.tableView];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return [[self.searchResults objectForKey:@"联系人"] count];
//
//    }else if (section == 1) {
//        return [[self.searchResults objectForKey:@"讨论组"] count];
//
//    }else if (section == 2) {
//        return [[self.searchResults objectForKey:@"设备"] count];
//
//    }
//    return 0;
//    NSArray *a = [self.searchResults allKeys];
//    return [[self.searchResults objectForKey:a[section]] count];
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
    SIMListTableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"SIMListTableViewCell"];
    commonCell.contants = _datas[indexPath.row];
    commonCell.accessoryType = UITableViewCellAccessoryNone;
    return commonCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 1) { // 2
        // 成员列表
//        SIMNewConverViewController *converVC = [[SIMNewConverViewController alloc] init];
//        converVC.person = _datas[indexPath.row];
//        converVC.person.isContant = NO;
//        [self.mainSearchController.navigationController pushViewController:converVC animated:YES];
    SIMContactDetailViewController *converVC = [[SIMContactDetailViewController alloc] init];
    converVC.person = _datas[indexPath.row];
    converVC.person.isContant = NO;
    [self.mainSearchController.navigationController pushViewController:converVC animated:YES];
//    }
    //    else if (indexPath.section == 0) {
    //        NSLog(@"跳转到添加外部联系人页面");
    //        SIMAddContentViewController *addVC = [[SIMAddContentViewController alloc] init];
    //        [self.navigationController pushViewController:addVC animated:YES];
    //    }else if (indexPath.section == 1) {
    //        if (indexPath.row == 2) {
    //            NSLog(@"跳转到外部联系人列表");
    //            SIMNCustomListController *customVC = [[SIMNCustomListController alloc] init];
    //            customVC.navigationItem.title = SIMLocalizedString(@"CContactCustomerManage", nil);
    //            [self.navigationController pushViewController:customVC animated:YES];
    //        }else if (indexPath.row == 1) {
    //            NSLog(@"跳转到企业成员列表");
    //            SIMNMyCompanyMemberController *customVC = [[SIMNMyCompanyMemberController alloc] init];
    //            customVC.navigationItem.title = SIMLocalizedString(@"CContactOrgan", nil);
    //            [self.navigationController pushViewController:customVC animated:YES];
    //        }
    //    }
}
////设置页眉的子视图
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    NSString *strBtn;
////    if (section==0) {
////        strBtn = [[self.searchResults objectForKey:@"联系人"] count] == 0 ? @"" : @"联系人";
////    }else if (section == 1) {
////        strBtn = [[self.searchResults objectForKey:@"讨论组"] count] == 0 ? @"" : @"讨论组";
////    }else if (section == 2) {
////        strBtn = [[self.searchResults objectForKey:@"设备"] count] == 0 ? @"" : @"设备";
////    }
//    NSArray *a = [self.searchResults allKeys];
//    strBtn = a[section];
//    UIView *vieww = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kWidthScale(50))];
//    vieww.backgroundColor = [UIColor whiteColor];
//    
//    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
//    but.frame=CGRectMake(0, kWidthScale(10), screen_width-40, kWidthScale(30));
//    but.titleEdgeInsets = UIEdgeInsetsMake(0, kWidthScale(15), 0, 0);
//    [but setTitle:strBtn forState:UIControlStateNormal];
//    but.titleLabel.font = FontRegularName(17);
//    [but setTitleColor:TableViewHeaderColor forState:UIControlStateNormal];
//    //设置按钮的内容左对齐
//    but.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
//    //给按钮赋tag值－－即分区数
//    but.tag=section;
//    [vieww addSubview:but];
//    return vieww;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    SIMListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listTabelCELL"];
//    UITableViewCell *deviceCell = [tableView dequeueReusableCellWithIdentifier:@"UItableViewcell"];
//    NSArray *a = [self.searchResults allKeys];
//    if ([a[indexPath.section] isEqualToString:SIMLocalizedString(@"ContantManAdress", nil)]) {
//        SIMContants *mm = [self.searchResults objectForKey:SIMLocalizedString(@"ContantManAdress", nil)][indexPath.row];
//        cell.contants = mm;
//        return cell;
//    }else if ([a[indexPath.section] isEqualToString:SIMLocalizedString(@"ContantGroup", nil)]) {
//        SIMGroup *model = [self.searchResults objectForKey:SIMLocalizedString(@"ContantGroup", nil)][indexPath.row];
//        cell.groups = model;
//        return cell;
//    }else if ([a[indexPath.section] isEqualToString:SIMLocalizedString(@"ContantDevice", nil)]) {
//        SIMNewDevice *dd = [self.searchResults objectForKey:SIMLocalizedString(@"ContantDevice", nil)][indexPath.row];
//        deviceCell.textLabel.text=dd.device_name;
//        deviceCell.textLabel.font = FontRegularName(17);
//        return deviceCell;
//    }else if ([a[indexPath.section] isEqualToString:SIMLocalizedString(@"ContantCompanyContant", nil)]) {
//        SIMDepartment_member *mm = [self.searchResults objectForKey:SIMLocalizedString(@"ContantCompanyContant", nil)][indexPath.row];
//        cell.department = mm;
//        return cell;
//    }else {
//        return nil;
//    }
//    
//}
//
//
//// 跳转 
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSArray *a = [self.searchResults allKeys];
//    if ([a[indexPath.section] isEqualToString:SIMLocalizedString(@"ContantManAdress", nil)]) {
//        SIMNewConverViewController *converVC = [[SIMNewConverViewController alloc] init];
//        converVC.person = [self.searchResults objectForKey:SIMLocalizedString(@"ContantManAdress", nil)][indexPath.row];// 传递模型
//        // 将本页的model数组按下标传递给下一页 下一页用一个model属性接受
//        [self.mainSearchController.navigationController pushViewController:converVC animated:YES];
//    }else if ([a[indexPath.section] isEqualToString:SIMLocalizedString(@"ContantGroup", nil)]) {
//        SIMGroupDetailViewController *groupVC = [[SIMGroupDetailViewController alloc] init];
//        groupVC.gg = [self.searchResults objectForKey:SIMLocalizedString(@"ContantGroup", nil)][indexPath.row];
//        [self.mainSearchController.navigationController pushViewController:groupVC animated:YES];
//    }else if ([a[indexPath.section] isEqualToString:SIMLocalizedString(@"ContantDevice", nil)]) {
//        SIMNewDevSubViewController *deviceVC = [[SIMNewDevSubViewController alloc] init];
//        deviceVC.device = [self.searchResults objectForKey:SIMLocalizedString(@"ContantDevice", nil)][indexPath.row];
//        [self.mainSearchController.navigationController pushViewController:deviceVC animated:YES];
//    }
////    else if ([a[indexPath.section] isEqualToString:SIMLocalizedString(@"ContantCompanyContant", nil)]) {
////        SIMNewConverViewController *converVC = [[SIMNewConverViewController alloc] init];
////        converVC.department = [self.searchResults objectForKey:SIMLocalizedString(@"ContantCompanyContant", nil)][indexPath.row];
////        [self.mainSearchController.navigationController pushViewController:converVC animated:YES];
////    }
//}

@end
