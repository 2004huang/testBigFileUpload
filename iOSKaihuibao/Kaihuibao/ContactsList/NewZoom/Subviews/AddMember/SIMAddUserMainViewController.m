//
//  SIMAddUserMainViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/7/8.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMAddUserMainViewController.h"

#import "SIMSettingNewCell.h"
#import "SIMShareTool.h"

#import "SIMAccountCompanyViewController.h"
#import "SIMAddFromAdressViewController.h"

@interface SIMAddUserMainViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) SIMBaseTableView* tableView;
@property (strong,nonatomic) NSArray *cellDatas;

@end

@implementation SIMAddUserMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"CCAddTheMemberTitle", nil);
    
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
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellDatas count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMSettingNewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"SIMSettingNewCell"];
    commonCell.datas = self.cellDatas[indexPath.row];
    return commonCell;
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *indexDic = self.cellDatas[indexPath.row];
    NSString *indexStr = indexDic[@"serial"];
    NSString *messStr = SIMLocalizedString(@"ShareContactInviteToWechatText", nil);
    NSString *titleStr = [NSString stringWithFormat:@"%@%@",self.currentUser.nickname,SIMLocalizedString(@"ShareContactInviteToWechatTitle", nil)];
    NSString *urlstr = [NSString stringWithFormat:@"%@/admin/index/register?cs=%@",kApiBaseUrl,self.currentUser.company_serial];
    NSLog(@"urlstrurlstrurlstr %@",urlstr);
    if ([indexStr isEqualToString:@"AddWechat"]) {
        // 微信添加
        [[SIMShareTool shareInstace] shareToWeChatWithShareStr:messStr shareImage:@"share_khbicon" urlStr:urlstr ShareTitle:titleStr];
    }else if ([indexStr isEqualToString:@"AddQQ"]) {
        // QQ添加
        [[SIMShareTool shareInstace] shareToQQWithShareStr:messStr shareImage:@"share_khbicon" urlStr:urlstr ShareTitle:titleStr];
    }else if ([indexStr isEqualToString:@"AddMessage"]) {
        // 短信添加
        [self showMessageViewbody:[NSString stringWithFormat:@"%@。点击 %@ 加入",titleStr,urlstr] viewController:self];
//        [[SIMShareTool shareInstace] showMessageViewbody:[NSString stringWithFormat:@"%@。点击 %@ 加入",titleStr,urlstr] viewController:self];
    }else if ([indexStr isEqualToString:@"AddAdressBook"]) {
        // 通讯录添加
        SIMAddFromAdressViewController *adressVC = [[SIMAddFromAdressViewController alloc] init];
        [self.navigationController pushViewController:adressVC animated:YES];
    }else if ([indexStr isEqualToString:@"AddPutin"]) {
        // 手动输入添加
        SIMAccountCompanyViewController *addVC = [[SIMAccountCompanyViewController alloc] init];
        [self.navigationController pushViewController:addVC animated:YES];
    }
}
- (void)addDatas {
    NSMutableArray *sectionArr = [NSMutableArray array];
    if ([self.cloudVersion.wechat boolValue]) {
        [sectionArr addObject:@{@"icon":@"adduser_wechat",
                                @"title":SIMLocalizedString(@"AUListWechat", nil),
                                @"serial":@"AddWechat"
                                }];
        [sectionArr addObject:@{@"icon":@"adduser_qqAdd",
                                @"title":SIMLocalizedString(@"AUListQQ", nil),
                                @"serial":@"AddQQ"
                                }];
    }
    
    if ([self.cloudVersion.message boolValue]) {
        [sectionArr addObject:@{@"icon":@"adduser_message",
                                @"title":SIMLocalizedString(@"AUListMessage", nil),
                                @"serial":@"AddMessage"
                                }];
    }
    if ([self.cloudVersion.invite boolValue]) {
        [sectionArr addObject:@{@"icon":@"adduser_adressbook",
                                @"title":SIMLocalizedString(@"AUListAdressBook", nil),
                                @"serial":@"AddAdressBook"
                                }];
    }
    [sectionArr addObject:@{@"icon":@"adduser_putin",
                            @"title":SIMLocalizedString(@"AUListPutin", nil),
                            @"serial":@"AddPutin"
                            }];
    
    
    self.cellDatas = sectionArr.copy;
}

@end
