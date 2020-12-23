//
//  SIMNewAddContantViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/2/2.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMNewAddContantViewController.h"
#import "SIMDingTableViewCell.h"
#import "SIMDingHeader.h"
#import "SIMAccountCompanyViewController.h"
#import <MessageUI/MessageUI.h>

@interface SIMNewAddContantViewController ()<UITableViewDelegate,UITableViewDataSource,MFMessageComposeViewControllerDelegate>
{
    NSArray *allArr;
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) SIMDingHeader *dingHeader;
@property (strong,nonatomic) UIButton *addBtnHeader;

@end

static NSString *reuse = @"SIMDingTableViewCell";

@implementation SIMNewAddContantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDataSources]; // 数据
    [self initSubViews];    // 初始化控件
    
}
- (void)initDataSources {
    self.title = self.adress.nickname;
    
    [self initTheTableViewDatas];
}

- (void)initSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建表格
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height-StatusNavH) style:UITableViewStylePlain];
    [self.tableView setSeparatorColor:ZJYColorHex(@"#eeeeee")];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 100)];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[SIMDingTableViewCell class] forCellReuseIdentifier:reuse];
    
    self.tableView.estimatedRowHeight =0;
    self.tableView.estimatedSectionHeaderHeight =0;
    self.tableView.estimatedSectionFooterHeight =0;
    
    UIView *headerBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 260)];
    headerBack.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerBack;
    
    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, screen_width - 30, 165)];
    [headerBack addSubview:shadowView];
    shadowView.layer.shadowColor = GrayPromptTextColor.CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(2, 2);
    shadowView.layer.shadowOpacity = 0.3;
    shadowView.layer.shadowRadius = 5.0;
    shadowView.layer.cornerRadius = 3.0;
    shadowView.clipsToBounds = NO;
    
    _dingHeader = [[SIMDingHeader alloc] initWithFrame:CGRectMake(0, 0, screen_width - 30, 165)];
    _dingHeader.adress = self.adress;// 两种模型 这种是从通讯录里获取的联系人
    
    [shadowView addSubview:_dingHeader];
    
    _addBtnHeader = [[UIButton alloc] initWithFrame:CGRectMake(15, 200, screen_width - 30, 45)];
    if (self.adress.isUserContant) {
        // 从添加用户的地方进来
        if (!self.adress.is_user) {
            [_addBtnHeader setTitle:SIMLocalizedString(@"CCAddTheMemberTitle", nil) forState:UIControlStateNormal];
            SIMAccountCompanyViewController *accountVC = [[SIMAccountCompanyViewController alloc] init];
            accountVC.adress = self.adress;
            [self.navigationController pushViewController:accountVC animated:YES];
        }else {
            
        }
        
    }else {
        [_addBtnHeader setTitle:SIMLocalizedString(@"CCAddTheFriendsTitle", nil) forState:UIControlStateNormal];
    }
    
    [_addBtnHeader addTarget:self action:@selector(addBtnHeaderClick) forControlEvents:UIControlEventTouchUpInside];
    _addBtnHeader.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [_addBtnHeader setTitleColor:ZJYColorHex(@"#3296fa") forState:UIControlStateNormal];
    _addBtnHeader.layer.cornerRadius = 45/4;
    _addBtnHeader.layer.masksToBounds = YES;
    _addBtnHeader.layer.borderWidth = 1;
    _addBtnHeader.layer.borderColor = ZJYColorHex(@"#eeeeee").CGColor;
    [headerBack addSubview:_addBtnHeader];
    
}
- (void)addBtnHeaderClick {
    if (self.adress.isUserContant) {
        // 从添加用户的地方进来
        if (!self.adress.is_user) {
            // 跳转
            SIMAccountCompanyViewController *accountVC = [[SIMAccountCompanyViewController alloc] init];
            accountVC.adress = self.adress;
            [self.navigationController pushViewController:accountVC animated:YES];
        }else {
            
        }
    }else {
        // 从外部联系人地方进来
        if (self.adress.is_user) {
            // 已经注册
            if (!self.adress.is_friend) {
                // 不是好友 -- 那么添加好友
                [MBProgressHUD cc_showText:SIMLocalizedString(@"CCSendFriend_Success", nil)];
                // 将模型里的按钮选中设置为yes 显示已发送字样 刷新表格展示
                self.adress.isSelectSend = YES;
//                [self.tableView reloadData];
                // 添加好友接口
                [self addContractorRequest:self.adress.mobile];
            }
        }else {
            // 未注册
            [MBProgressHUD cc_showText:SIMLocalizedString(@"CCSendMess_Success", nil)];
            // 将模型里的按钮选中设置为yes 显示已发送字样 刷新表格展示
            self.adress.isSelectSend = NO;
//            [self.tableView reloadData];
            // 发送邀请的短信
            if ([MFMessageComposeViewController canSendText]) {
                // 邀请联系人 发送短信
                [MBProgressHUD cc_showLoading:nil delay:3];
                
                
                [self showMessageView:@[self.adress.mobile] title:nil body:[NSString stringWithFormat:@"%@：%@ %@",self.currentUser.nickname,SIMLocalizedString(@"AdressShareSendTest", nil),[NSURL URLWithString:@"kaihuibao.net"]]];
                
            }else {
                [MBProgressHUD cc_showText:SIMLocalizedString(@"MessageSendTest", nil)];
            }
            
        }
    }
    
}
// 添加联系人数据
- (void)addContractorRequest:(NSString *)mobileStr {
    
    NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithObjectsAndKeys:mobileStr ,@"mobile",@"1",@"kind", nil];

//    [MainNetworkRequest contractorAddRequestParams:dicM success:^(id success) {
//        
//        if ([success[@"status"] isEqualToString:@"ok"]) {
//            
//            /**添加联系人成功 通知联系人控制器 刷新数据*/
//            //            [_contactsVC requestUserList];
//            // 发送列表刷新通知
//            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshContactData object:nil];
//        }else if ([success[@"status"] isEqualToString:@"ERROR_ITEM_EXISTED"]){
//            [MBProgressHUD cc_showFail:SIMLocalizedString(@"CCAddMember_AlreadyHave", nil)];
//        }else if ([success[@"status"] isEqualToString:@"ERROR_USER_NOT_FOUND"]){
//            [MBProgressHUD cc_showFail:SIMLocalizedString(@"ERROR_USER_NOT_FOUND", nil)];
//            // 如果用户未注册 前去邀请注册
//            
//        }else if ([success[@"status"] isEqualToString:@"ERROR_INVALID_DATA"]) {
//            [MBProgressHUD cc_showFail:SIMLocalizedString(@"ERROR_INVALID_DATA4", nil)];
//        }else if ([success[@"status"] isEqualToString:@"ERROR_INVALID_FORM"]) {
//            [MBProgressHUD cc_showFail:SIMLocalizedString(@"ERROR_WRONG_PhoneNumber", nil)];
//        }
//    } failure:^(id failure) {
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
//    }];
}

#pragma mark -- UITableViewDelegate
//设置页眉高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

//设置页眉的子视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vieww = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 50)];
    vieww.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, screen_width-40, 50)];
    label.text = SIMLocalizedString(@"CCOwenMess", nil);
    label.font = [UIFont boldSystemFontOfSize:17];
    label.textColor = ZJYColorHex(@"#191f25");
    [vieww addSubview:label];
    return vieww;
}

//设置分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return allArr.count;
}
//分区中行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allArr[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (void)initTheTableViewDatas {
    NSArray *sectionTwo;
    sectionTwo = @[@{@"title":SIMLocalizedString(@"CCOwenMess_PHONE", nil),@"detail":self.adress.mobile}];
    allArr = @[sectionTwo];
}

//设置单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMDingTableViewCell *dingCell = [tableView dequeueReusableCellWithIdentifier:reuse];
    dingCell.titleLabel.text = [allArr[indexPath.section][indexPath.row] objectForKey:@"title"];
    dingCell.detailLabel.text = [allArr[indexPath.section][indexPath.row] objectForKey:@"detail"];
    
    return dingCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark-- messageCompose
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.body = body;
        controller.messageComposeDelegate = self;
        controller.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
}

#pragma mark -- messageComposeDelegate
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            [MBProgressHUD cc_showSuccess:SIMLocalizedString(@"MessageSendSend", nil)];
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            [MBProgressHUD cc_showFail:SIMLocalizedString(@"MessageSendFail", nil)];
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            [MBProgressHUD cc_showSuccess:SIMLocalizedString(@"MessageSendCancel", nil)];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
