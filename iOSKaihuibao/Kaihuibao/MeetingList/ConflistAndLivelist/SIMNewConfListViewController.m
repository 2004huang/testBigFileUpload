//
//  SIMNewConfListViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/5.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMNewConfListViewController.h"

#import "ConfListTableViewCell.h"
#import "SIMConfHeader.h"

#import "ConfMessageViewController.h"
#import "EditMyConfViewController.h"
#import "SIMShareFromChooseViewController.h"
#import "NSDate+SIMConvenient.h"

#import "ArrangeConfModel.h"
//#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "NSDate+SIMConvenient.h"
#import "SIMShareTool.h"
#import "SIMConfIDQRCodeViewController.h"
#import "SIMConfAllViewController.h"

//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
//#import <ShareSDKUI/SSUIShareSheetConfiguration.h>
//DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
@interface SIMNewConfListViewController ()<UITableViewDelegate,UITableViewDataSource,CLConferenceDelegate>
{
    dispatch_queue_t _queueEnter;
    dispatch_group_t _groupEnter;
    
    NSMutableArray *tmpWaitingArr; // 用于给未来的会议临时排序用的数组 自己按开始时间分类到每一天里
    BOOL isNoMoreData;      // 上拉加载标记是否是没有更多数据了
    NSInteger  _pageNumber; // 上拉加载第几页 从0开始
}

@property (strong,nonatomic) SIMBaseTableView *tableView;
@property (strong,nonatomic) SIMConfHeader *confHeaderView; // 个人会议室头视图
@property (nonatomic, strong) ArrangeConfModel *myConf;     // 个人会议室模型

@property (nonatomic, strong) NSMutableArray *shareArr;   //分享邀请的数组
@property (nonatomic, strong) NSMutableArray *waitingArr;   //未来会议数组
@property (nonatomic, strong) NSMutableArray *repeatingArr; //周期会议数组
@property (nonatomic, strong) NSMutableArray *tableHeaderArr;//页眉数组

@end

static NSString *reuse = @"ConfListTableViewCell";
@implementation SIMNewConfListViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//- (void)exitConference:(NSError *)error {
//    NSLog(@"failToLeaveConferrorerrorerrorerror %@",error);
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestConfListData) name:EditConfSuccess object:nil];// 会议列表刷新 放到这里没放到init里是因为上课宝也用这个页面 上课宝里面有两个地方需要列表 要在页面加载完成之后加上通知 否则 tabbar直接init加载通知而没有展示
    self.title = SIMLocalizedString(@"TabBarConfTitle", nil);
    // 创建全局队列
    _queueEnter = dispatch_get_global_queue(0, 0);
    _groupEnter = dispatch_group_create();
    
    tmpWaitingArr = [[NSMutableArray alloc] init];
    _repeatingArr = [[NSMutableArray alloc] init];
    _tableHeaderArr = [[NSMutableArray alloc] init];
    
    // 获取会议列表和个人会议室资料
    [self requestConfListData];
    
    [self addsubViews];
    
}

- (void)addsubViews {
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];

    self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height - TabbarH - StatusNavH);
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[ConfListTableViewCell class] forCellReuseIdentifier:reuse];
    
    // 刷新 上拉加载 下拉刷新
    __weak typeof(self) weakSelf = self;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestConfListFooterRefresh];
    }];
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    
    
    MJRefreshNormalHeader *refreshHead = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    refreshHead.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = refreshHead;
    
    _confHeaderView = [[SIMConfHeader alloc] initWithFrame:CGRectMake(0, 0, screen_width, 160)];
    self.tableView.tableHeaderView = _confHeaderView;
    
    // 开始进入会议室我的个人会议室
    _confHeaderView.startClick = ^{
//        SIMConfAllViewController *mainVC = [[SIMConfAllViewController alloc] init];
//        [weakSelf.navigationController pushViewController:mainVC animated:YES];
        [SIMNewEnterConfTool enterTheMineConfWithCid:weakSelf.currentUser.self_conf psw:@"" confType:EnterConfTypeConf isJoined:NO viewController:weakSelf];
    };
    // 编辑
    _confHeaderView.editClick = ^{
        // 点击了编辑会议会议
        EditMyConfViewController *editVC = [[EditMyConfViewController alloc] init];
        editVC.isLive = NO;
        editVC.myConf = weakSelf.myConf;
        [weakSelf.navigationController pushViewController:editVC animated:YES];
    };
    
    // 发送邀请
    _confHeaderView.sendClick = ^{
        [weakSelf shareTheMyConf];
    };
    
}

#pragma mark -- MJRefreshMethod
- (void)loadNewData {
    // 获取会议列表和个人会议室资料
    [self requestConfListData];
}

#pragma mark - TableViewDelegate DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _waitingArr.count + 1;// 分区0都是周期会议 剩下的分区个数有waitingarr里的数组个数确定
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _repeatingArr.count;// 重复会议数
    }else {
        return [_waitingArr[section - 1] count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.repeatingArr.count == 0 ? CGFLOAT_MIN : 48;
    }else{
        if ([_waitingArr[section - 1] count]) {
            return 48;
        }
    }
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backV = [[UIView alloc] init];
    backV.frame = CGRectMake(0, 0, screen_width, 48);
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 0, screen_width, 48);
    label.font = FontRegularName(15);
    label.textColor = ZJYColorHex(@"#666666");
    [backV addSubview:label];
    if (section == 0) {
        label.text = self.repeatingArr.count == 0 ? @"" : SIMLocalizedString(@"MMainMeetingHeaderTitleREP", nil);
    }else {
        label.text = _tableHeaderArr[section-1];
    }
    return backV;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConfListTableViewCell *confListCell = [tableView dequeueReusableCellWithIdentifier:reuse];
    
    if (indexPath.section == 0){
        // 传值 重复会议
        if (self.repeatingArr.count) {
            ArrangeConfModel *conflist = self.repeatingArr[indexPath.row];
            confListCell.conflistModel = conflist;
            // 点击开始按钮
            __weak typeof(self) weakSelf = self;
            confListCell.startClick = ^{
                [weakSelf conflistCellWithModel:conflist];
            };
        }
        return confListCell;
    }else {
        // 传值 尚未召开的未来的会议 只有今天的有开始按钮
        if (self.waitingArr.count) {
            ArrangeConfModel *conflist = _waitingArr[indexPath.section-1][indexPath.row];
            confListCell.conflistModel = conflist;
            __weak typeof(self) weakSelf = self;
            confListCell.startClick = ^{ // 点击开始按钮
                [weakSelf conflistCellWithModel:conflist];
            };
        }
        
        return confListCell;
        
    }

}

- (void)conflistCellWithModel:(ArrangeConfModel *)conflist {

//    if (conflist.normalPassword.length) {
//        [SIMNewEnterConfTool enterWithAlertControllerWithCid:conflist.cid psw:conflist.normalPassword confType:[self.signIDStr integerValue] isJoined:NO viewController:self];
//    }else {
        [SIMNewEnterConfTool enterTheMineConfWithCid:conflist.cid psw:@"" confType:[self.signIDStr integerValue] isJoined:NO viewController:self];

//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ConfMessageViewController *mess = [[ConfMessageViewController alloc] init];
    if (indexPath.section == 0){
        mess.confMessID = [_repeatingArr[indexPath.row] cid];
        mess.confMess = _repeatingArr[indexPath.row];
    }else {
        mess.confMessID = [_waitingArr[indexPath.section-1][indexPath.row] cid];
        mess.confMess = _waitingArr[indexPath.section-1][indexPath.row];
    }
    
    mess.confMess.isLive = NO;
    mess.signType = self.signIDStr;
    [self.navigationController pushViewController:mess animated:YES];
}

#pragma mark -- NetworkRequestMethod
// 个人会议室接口
- (void)requestEditData {
    dispatch_group_enter(_groupEnter);
    [MainNetworkRequest confDetailRequestParams:@{@"cid":self.currentUser.self_conf,@"advice":@"all"} success:^(id success) {
        
        NSLog(@"myConfListResult %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            // 暂存模型
            _myConf = [[ArrangeConfModel alloc] initWithDictionary:success[@"data"]];
            // 保存到本地
            NSData * dat = [NSJSONSerialization dataWithJSONObject:success[@"data"] options:NSJSONWritingPrettyPrinted error:nil];
            [[NSUserDefaults standardUserDefaults] setObject:dat forKey:@"MYCONF"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        
            _confHeaderView.model = _myConf;
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
        dispatch_group_leave(_groupEnter);
    } failure:^(id failure) {
        dispatch_group_leave(_groupEnter);
    }];
    
}

// 会议列表数据
// 正在进行的会议
- (void)requestMeeting1WithPageCount:(BOOL)isFootMore {
    dispatch_group_enter(_groupEnter);
    NSInteger limitCount = 10;
    NSInteger temp = 0;
    if (isFootMore) {
        temp = _pageNumber + 1;
    }
    
    // 传递参数字典
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
        [dicM setValue:@(limitCount) forKey:@"limit"];
    [dicM setValue:[NSString stringWithFormat:@"%ld",temp] forKey:@"offset"];

    [MainNetworkRequest newconfListRequestParams:dicM success:^(id success) {

        NSLog(@"successRunningConfList+++%@",success);
//        // 成功
        if ([success[@"code"] integerValue] == successCodeOK) {
            if (!isFootMore) {
                [_repeatingArr removeAllObjects];
                [tmpWaitingArr removeAllObjects];
                [_waitingArr removeAllObjects];
                
            }
            [_tableHeaderArr removeAllObjects];
            
            NSInteger repeatnum = 0;
            NSInteger listnum = 0;
            
            for (NSDictionary *dic in success[@"data"]) {
                NSString *arrKeys = [dic allKeys][0];
                NSArray *valueArr = [dic allValues];
                if ([arrKeys isEqualToString:@"repeatList"]) {
                    for (NSDictionary *modelDic in valueArr[0]) {
                        ArrangeConfModel *arrangeConf = [[ArrangeConfModel alloc] initWithDictionary:modelDic];
                        [_repeatingArr addObject:arrangeConf];
                        
                    }
//                    NSLog(@"arrM %@ ",_repeatingArr);
//                    [_tableHeaderArr addObject:arrKeys];
                    repeatnum = [valueArr[0] count];
                }else if ([arrKeys isEqualToString:@"list"]) {
                    for (NSDictionary *modelDic in valueArr[0]) {
                        ArrangeConfModel *arrangeConf = [[ArrangeConfModel alloc] initWithDictionary:modelDic];
                        [tmpWaitingArr addObject:arrangeConf];
                        
                    }
                    
//                    NSLog(@"arrM %@ ",_repeatingArr);
                    _waitingArr = [self getWaitingArray:[[NSMutableArray alloc] initWithArray:tmpWaitingArr]];
//                    [_tableHeaderArr addObject:arrKeys];
                    listnum = [valueArr[0] count];
                }else {
                    
                }
            }
            if (isFootMore) {
                _pageNumber += 1;// 如果是网络请求成功了 才加一
                if (listnum < limitCount && repeatnum < limitCount) {
                    isNoMoreData = YES; // 没有更多数据了 要两个数组都要小于固定个数才行 一个不小于都还要继续下拉
                }else {
                    isNoMoreData = NO;
                }
            }else {
                _pageNumber = 0; // 当请求成功之后才去更改变量的值 防止中途有问题 导致变量提前变化 用户又去下拉加载的不准确
            }
            
            
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
            
        dispatch_group_leave(_groupEnter);
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        
        dispatch_group_leave(_groupEnter);
    }];
}

// 请求会议列表数据和个人会议室资料 初始化和下啦刷新时候^^^^^^^^^^^^^^^^^^
- (void)requestConfListData{
    // 下拉刷新和初始化时候 将请求开始的下标改为0
//    _pageNumber = 0;
    _shareArr = [NSMutableArray array];
    if ([self.cloudVersion.wechat boolValue]) {
        [_shareArr addObject:@{@"title":SIMLocalizedString(@"WeChatSend", nil),@"serial":@"1001"}];
    }
    if ([self.cloudVersion.email boolValue]) {
        [_shareArr addObject:@{@"title":SIMLocalizedString(@"NewEmailSend", nil),@"serial":@"1002"}];
    }
    if ([self.cloudVersion.message boolValue]) {
        [_shareArr addObject:@{@"title":SIMLocalizedString(@"NewMessageSend", nil),@"serial":@"1003"}];
    }
    if ([self.cloudVersion.pasteBoard boolValue]) {
        [_shareArr addObject:@{@"title":SIMLocalizedString(@"PaseboardSend", nil),@"serial":@"1004"}];
    }
    
    dispatch_group_async(_groupEnter, _queueEnter, ^{
        // 我的个人会议室 在这个页面请求然后将模型传给下一个界面 因为下一个界面有开关 这样避免了网络请求在当页请求开关动态
        [self requestEditData];
    });
    dispatch_group_async(_groupEnter, _queueEnter, ^{
        // 安排的会议
        [self requestMeeting1WithPageCount:NO];
    });
    dispatch_group_notify(_groupEnter, dispatch_get_main_queue(), ^{
        
        _confHeaderView.convenceBtn.layer.borderColor = BlueButtonColor.CGColor;
        [_confHeaderView.convenceBtn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
        _confHeaderView.convenceBtn.enabled = YES;
        _confHeaderView.send.layer.borderColor = BlueButtonColor.CGColor;
        [_confHeaderView.send setTitleColor:BlueButtonColor forState:UIControlStateNormal];
        _confHeaderView.send.enabled = YES;
        _confHeaderView.edit.layer.borderColor = BlueButtonColor.CGColor;
        [_confHeaderView.edit setTitleColor:BlueButtonColor forState:UIControlStateNormal];
        _confHeaderView.edit.enabled = YES;
        
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
//        self.tableView.emptyDataSetSource = self;
//        self.tableView.emptyDataSetDelegate = self;
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        
        
    });
}
// 解析会议列表数据 下啦加载的时候 只让他请求会议列表
- (void)requestConfListFooterRefresh{
//    NSInteger temp = _pageNumber + 1;// 请求的时候先用临时加一 只有当真正的网络请求成功了 才变量加一
    
    dispatch_group_async(_groupEnter, _queueEnter, ^{
        // 正在进行的会议
        [self requestMeeting1WithPageCount:YES];
    });
    dispatch_group_notify(_groupEnter, dispatch_get_main_queue(), ^{
        
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
        [self.tableView reloadData];
        
        // 根据变量 显示不同页脚标题
        if (isNoMoreData == YES) {
            [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];

        }else{
            
            [self.tableView.mj_footer endRefreshing];
            
        }
    });
}
// 排序方法
- (NSMutableArray *)getWaitingArray:(NSMutableArray *)mArray{
    NSMutableArray *dateMutablearray = [@[] mutableCopy];
    for (int i = 0; i < mArray.count; i ++) {
        ArrangeConfModel *model_i = mArray[i];
        NSMutableArray *tempArray = [@[] mutableCopy];
        [tempArray addObject:model_i];
        if (![model_i isKindOfClass:[NSNull class]]) {
            for (int j = i+1; j < mArray.count; j ++) {
                ArrangeConfModel *model_j = mArray[j];
                if (![model_j isKindOfClass:[NSNull class]]) {
                    if([model_i.time isEqualToString:model_j.time]){
                        [tempArray addObject:model_j];
                        [mArray replaceObjectAtIndex:j withObject:[NSNull null]];
                    }
                }
            }
            if (![tempArray containsObject:[NSNull null]]) {
                [dateMutablearray addObject:tempArray];
                ArrangeConfModel *model = tempArray[0];
//                [_tableHeaderArr addObject:[self dateTransform:momo.time]];
                [_tableHeaderArr addObject:[NSString dateTranformDayStrFromTimeStr:[model startTime]]];
            }
        }
    }
    
    return dateMutablearray;
}
#pragma mark -- DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_tableview_icon"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = SIMLocalizedString(@"MMainLiveNoneTitle", nil);
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
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = SIMLocalizedString(@"MMainLiveNoneTitleTest", nil);

    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{
                                 NSFontAttributeName:FontRegularName(14),
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName:paragraph
                                 };

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView {
    NSLog(@"点击了重新加载数据");
}
- (void)shareTheMyConf {
    if (_shareArr.count == 0) {
        [MBProgressHUD cc_showText:@"暂无邀请功能，请联系管理开启配置"];
        return ;
    }
    NSString *title = SIMLocalizedString(@"MMessEditConf", nil);
    NSString *fistStr = [[NSString alloc] initWithString:title];
    NSString * sharedStr = [NSString stringWithFormat:@"%@%@",SIMLocalizedString(@"MMessEditConfOne", nil),title];
    
//    NSString * urlsharedStr = [NSString stringWithFormat:@"%@/admin/conference/joinmeeting?server=%@&port=%@&name=zc_test&token=11111&cid=%@&cp=%@&sm=web&anon=1&role=&ref=%@&data=&timetap=%@",urlString,webHostStr,webPortStr,self.currentUser.self_conf,self.myConf.normalPassword,[NSString stringWithFormat:@"iOS%@",app_Version],[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]];
//    NSString * urlsharedStr = [NSString stringWithFormat:@"%@&ref=%@&timetap=%@",self.myConf.roomUrl,[NSString stringWithFormat:@"iOS%@",getApp_Version],[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]];
    NSString * urlsharedStr = self.myConf.roomUrl;
    [self addActionSheetWithShareStr:sharedStr nameStr:fistStr urlStr:urlsharedStr];
}
#pragma mark -- UIAlertViewDelegate
- (void)addActionSheetWithShareStr:(NSString *)shareStr nameStr:(NSString *)namestr urlStr:(NSString *)urlstr{
    NSString *shareContent = [NSString stringWithFormat:SIMLocalizedString(@"ShareConfInviteOnePart", nil),self.currentUser.nickname,self.myConf.name,self.myConf.name,self.myConf.startTime,self.currentUser.nickname,urlstr];
    NSString *wechatContent = [NSString stringWithFormat:SIMLocalizedString(@"ShareConfInviteOnePartWechat", nil),self.myConf.name,self.myConf.startTime,self.currentUser.nickname,urlstr];
    
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"WeChatSend", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *titleStr = [NSString stringWithFormat:@"\n%@ %@ %@",self.currentUser.nickname,SIMLocalizedString(@"MMessageWechatTitle", nil),shareStr];
        
        [[SIMShareTool shareInstace] shareToWeChatWithShareStr:wechatContent shareImage:@"share_meeting" urlStr:urlstr ShareTitle:titleStr];
    }];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"MessageSend", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[SIMShareTool shareInstace] showMessageViewbody:shareContent viewController:self];// 调用发送短信
        [self showMessageViewbody:shareContent viewController:self];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"MailSend", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sendEmailActiontitle:shareContent viewController:self];// 调用发送邮件
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"ShareToDepartMemberTitle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 分享到企业联系人
        SIMShareFromChooseViewController *shareVC = [[SIMShareFromChooseViewController alloc] init];
        shareVC.shareText = shareContent;
        [self.navigationController pushViewController:shareVC animated:YES];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"PaseboardToSend", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[SIMShareTool shareInstace] sendPasteboardActiontitle:shareContent];// 调用复制到剪贴板
    }];
    UIAlertAction *action6 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"ErweimaSendTitle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 二维码保存
        SIMConfIDQRCodeViewController *qrcodeVC = [[SIMConfIDQRCodeViewController alloc] init];
        qrcodeVC.confURL = urlstr;
        [self.navigationController pushViewController:qrcodeVC animated:YES];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [action4 setValue:RedButtonColor forKey:@"_titleTextColor"];

    if ([self.cloudVersion.wechat boolValue]) {
        [alertC addAction:action0];
    }
    if ([self.cloudVersion.message boolValue]) {
        [alertC addAction:action1];
    }
    if ([self.cloudVersion.email boolValue]) {
        [alertC addAction:action2];
    }
    if ([self.cloudVersion.im boolValue]) {
        [alertC addAction:action5];
    }
    if ([self.cloudVersion.pasteBoard boolValue]) {
        [alertC addAction:action3];
    }
    [alertC addAction:action6];
    [alertC addAction:action4];
    alertC.popoverPresentationController.sourceView = self.view;
    alertC.popoverPresentationController.sourceRect = _confHeaderView.send.frame;
    alertC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    [self presentViewController:alertC animated:YES completion:nil];
}
@end
