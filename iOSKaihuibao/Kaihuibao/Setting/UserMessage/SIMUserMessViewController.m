//
//  SIMUserMessViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/10/26.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMUserMessViewController.h"
#import "SIMBaseCommonTableViewCell.h"
#import "SIMEditNameViewController.h"

@interface SIMUserMessViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) SIMBaseTableView* tableView;
@property (strong,nonatomic) NSArray *array;
@property (strong,nonatomic) NSArray *detailArray;
@end
static NSString *reuse = @"SIMBaseCommonTableViewCell";
@implementation SIMUserMessViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initTheData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"SAccountMess", nil);
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];
}

- (void)initTheData {
    _array = @[SIMLocalizedString(@"SAccountName", nil),SIMLocalizedString(@"SAccountRole", nil),SIMLocalizedString(@"SAccountType", nil)];
    NSString *vipStr;
//    if ([self.currentUser.isVip isEqualToString:@"1"]) {
//        vipStr = SIMLocalizedString(@"SAccountLevelHigh", nil);
//    }else {
        vipStr = SIMLocalizedString(@"SAccountLevelNormal", nil);
//    }
    _detailArray = @[self.currentUser.nickname,SIMLocalizedString(@"SAccountPossesser", nil),vipStr];
    [self.tableView reloadData];
}

#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMBaseCommonTableViewCell *confListCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:_array[indexPath.row] prompt:_detailArray[indexPath.row]];
    if (indexPath.row == 0) {
        confListCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        confListCell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else {
        confListCell.accessoryType = UITableViewCellAccessoryNone;
        confListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return confListCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 100;
    }else {
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        // 姓名
        SIMEditNameViewController *edit = [[SIMEditNameViewController alloc] init];
        [self.navigationController pushViewController:edit animated:YES];
    }
}
@end
