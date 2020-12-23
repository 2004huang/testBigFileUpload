//
//  SIMAboutViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/24.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMAboutViewController.h"
#import "SIMBaseCommonTableViewCell.h"

#import "SIMFeedViewController.h"
#import "SIMShareTool.h"

@interface SIMAboutViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    SIMBaseCommonTableViewCell* _vesionCell;
    SIMBaseCommonTableViewCell* _feedCell;
    SIMBaseCommonTableViewCell* _recommenCell;
    SIMBaseCommonTableViewCell* _webCell;
//    SIMBaseCommonTableViewCell* _markCell;
    NSMutableArray *_cells;
}
@property (nonatomic,strong) SIMBaseTableView* tableView;
@property (nonatomic,strong) NSMutableArray *cells;
@end

@implementation SIMAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"SAbort", nil);
    
    [self setUpCells];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];
    
}
- (void)setUpCells
{
    _cells = [NSMutableArray array];
    // 获取版本号
    _vesionCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SShowAppVersion", nil) prompt:[NSString stringWithFormat:@"%@(%@)",getApp_Version,getApp_ownVersion]];
    _vesionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _vesionCell.accessoryType = UITableViewCellAccessoryNone;
    
    _feedCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SSendFeed", nil)];
    _feedCell.tag = 1001;
    
    _recommenCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SRecommenApp", nil)];
    _recommenCell.tag = 1002;
    
    _webCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SInviteWebSite", nil)];
    _webCell.tag = 1003;
//    _markCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SSendStarToUS", nil)];
    
    [_cells addObject:@[_vesionCell]];
    NSMutableArray *subCells = [NSMutableArray array];
    if ([self.cloudVersion.feedback boolValue]) {
        [subCells addObject:_feedCell];
    }
    if ([self.cloudVersion.recommend_show boolValue]) {
        [subCells addObject:_recommenCell];
    }
    if ([self.cloudVersion.homeurl_show boolValue]) {
        [subCells addObject:_webCell];
    }
    [_cells addObject:subCells];
    
}
#pragma mark - UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cells.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cells[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cells[indexPath.section][indexPath.row];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        UITableViewCell *cell = _cells[indexPath.section][indexPath.row];
        NSLog(@"cell.tagcell.tagcell.tag %ld",cell.tag);
        if (cell.tag == 1001) {
            // 反馈
            SIMFeedViewController *feed = [[SIMFeedViewController alloc] init];
            [self.navigationController pushViewController:feed animated:YES];
        }else if (cell.tag == 1002) {
            [self addActionSheet];// 推荐
        }else if (cell.tag == 1003) {
            // 跳转官网
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.cloudVersion.homeurl]];
        }

    }
//    else if (indexPath.section == 2) {
//        //评分 // 下载地址https://itunes.apple.com/cn/app/id1231422672?mt=8
//
//        NSString *urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8", APP_storeID];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
//    }
}

#pragma mark -- UIAlertViewDelegate
- (void)addActionSheet {
//    NSString *shareStr = SIMLocalizedString(@"NewAdressBookShare", nil);// 换成应用地址
    NSString *shareStr = [NSString stringWithFormat:SIMLocalizedString(@"NewAdressBookShareTitle", nil),self.cloudVersion.recommend_content,@""];

    // 推荐
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:SIMLocalizedString(@"MailSend", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sendEmailActiontitle:shareStr viewController:self];// 调用发送邮件
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"MessageSend", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[SIMShareTool shareInstace] showMessageViewbody:shareStr viewController:self];// 调用发送短信
        [self showMessageViewbody:shareStr viewController:self];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [action3 setValue:RedButtonColor forKey:@"_titleTextColor"];
    [alertC addAction:action];
    [alertC addAction:action2];
    [alertC addAction:action3];
    alertC.popoverPresentationController.sourceView = self.view;
    alertC.popoverPresentationController.sourceRect = _recommenCell.frame;
    [self presentViewController:alertC animated:YES completion:nil];
}


@end
