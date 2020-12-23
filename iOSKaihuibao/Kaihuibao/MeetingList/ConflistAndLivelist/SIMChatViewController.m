//
//  SIMChatViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/10/17.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMChatViewController.h"

#import "ConfListTableViewCell.h"
#import "SIMBaseCommonTableViewCell.h"

#import "ConfMessageViewController.h"

#import "NSDate+SIMConvenient.h"
#import "SIMLabel.h"

#import <AVFoundation/AVFoundation.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#import "ArrangeConfModel.h"
#import "SIMMyConf.h"

@interface SIMChatViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,CLConferenceDelegate>
{
    NSMutableArray *tmpWaitingArr;
    NSInteger _sumCount;
    
    dispatch_queue_t _queueEnter;
    dispatch_group_t _groupEnter;
    UITextField * passwordfiled;
    BOOL canClickCell;
    
    NSInteger  _pageRepNumber;
    NSInteger  _pageRunNumber;
    NSInteger  _pageWaitNumber;
}

@property (strong,nonatomic) SIMBaseTableView* tableView;
@property (nonatomic, strong) SIMMyConf *myConf;
@property (nonatomic, strong) ArrangeConfModel *arrangeConf;

@property (nonatomic, strong) NSMutableArray *waitingArr;//未来会议数组
@property (nonatomic, strong) NSMutableArray *repeatingArr;//周期会议数组
@property (nonatomic, strong) NSMutableArray *runningArr;//正在进行会议数组
@property (nonatomic, strong) NSMutableArray *tableHeaderArr;//页眉数组
@end

static NSString *reuse2 = @"ConfListTableViewCell";
@implementation SIMChatViewController

-(instancetype)init
{
    if (self = [super init]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestConfListData) name:EditLiveSuccess object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestConfListData) name:EditLiveSuccess object:nil];
    
    self.navigationItem.title = SIMLocalizedString(@"MGoBackLookTheLiving", nil);
    canClickCell = YES;
    // 创建全局队列
    _queueEnter = dispatch_get_global_queue(0, 0);
    _groupEnter = dispatch_group_create();
    
    tmpWaitingArr = [[NSMutableArray alloc] init];
    _repeatingArr = [[NSMutableArray alloc] init];
    _runningArr = [[NSMutableArray alloc] init];
    _tableHeaderArr = [[NSMutableArray alloc] init];
    
    _pageRepNumber = 0;
    _pageRunNumber = 0;
    _pageWaitNumber = 0;
    // 获取会议列表
    [self requestConfListData];
    
    [self addsubViews];
    
    _sumCount = 0;
    
//    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    
    // 刷新 上拉加载 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(weakSelf) sself = weakSelf;
        sself->_pageRunNumber = weakSelf.runningArr.count;
        sself->_pageRepNumber = weakSelf.repeatingArr.count;
        sself->_pageWaitNumber = sself->tmpWaitingArr.count;
        [weakSelf requestConfListData];
    }];
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    
    MJRefreshNormalHeader *refreshHead = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    refreshHead.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = refreshHead;
    
}

// 刷新响应方法
- (void)loadNewData {
    _pageRepNumber = 0;
    _pageRunNumber = 0;
    _pageWaitNumber = 0;
    // 获取会议列表
    [self requestConfListData];
}
- (void)addsubViews {
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height - TabbarH - StatusNavH);
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[ConfListTableViewCell class] forCellReuseIdentifier:reuse2];
}

#pragma mark - TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _waitingArr.count + 2;// 会议列表数加4
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _runningArr.count;// 正在进行会议数
    }else if(section == 1) {
        return _repeatingArr.count;// 重复会议数
    }else {
        return [_waitingArr[section-2] count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.runningArr.count == 0 ? CGFLOAT_MIN : 48;
    }else if(section == 1) {
        return self.repeatingArr.count == 0 ? CGFLOAT_MIN : 48;
    }else{
        if ([_waitingArr[section-2] count]) {
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
        label.text = self.runningArr.count == 0 ? @"" : SIMLocalizedString(@"MMainLiveHeaderTitleING", nil);
    }else if (section == 1) {
        label.text = self.repeatingArr.count == 0 ? @"" : SIMLocalizedString(@"MMainLiveHeaderTitleREP", nil);
    }else {
        label.text = _tableHeaderArr[section-2];
    }
    return backV;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConfListTableViewCell *confListCell = [tableView dequeueReusableCellWithIdentifier:reuse2];
    
    if (indexPath.section == 0) {
        // 传值 正在进行的会议
        if (self.runningArr.count) {
            ArrangeConfModel *conflist = self.runningArr[indexPath.row];
            confListCell.conflistModel = conflist;
            // 点击开始按钮
            __weak typeof(self) weakSelf = self;
            confListCell.startClick = ^{
                [weakSelf conflistCellWithModel:conflist];
            };
        }
        return confListCell;
        
    }else if (indexPath.section == 1){
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
            ArrangeConfModel *conflist = _waitingArr[indexPath.section-2][indexPath.row];
            confListCell.conflistModel = conflist;
            __weak typeof(self) weakSelf = self;
            confListCell.startClick = ^{ // 点击开始按钮
                [weakSelf conflistCellWithModel:conflist];
            };
        }
        
        return confListCell;
        
    }
}

// 点击单元格抽方法
- (void)conflistCellWithModel:(ArrangeConfModel *)conflist {
    // 判断相机权限
//    if (![SIMEnterConfTool  avauthorizationStatusWithViewController:self]) return;
//     判断是否有密码 从而进入不同的进会模式
//    if (conflist.normalPassword.length) {
//        [SIMEnterConfTool addAlertControllerWithCid:conflist.cid uid:self.currentUser.uid name:self.currentUser.nickname token:[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"] psw:conflist.normal_password signID:@"2" viewController:self];
//        [SIMNewEnterConfTool enterWithAlertControllerWithCid:conflist.cid psw:conflist.normalPassword  confType:EnterConfTypeLive isJoined:NO viewController:self];

//    }else {
//        [SIMEnterConfTool transferVideoMethodWithUid:self.currentUser.uid name:self.currentUser.nickname token:[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"] confID:conflist.cid psw:conflist.normal_password signID:@"2" viewController:self];
        [SIMNewEnterConfTool enterTheMineConfWithCid:conflist.cid psw:@""  confType:EnterConfTypeLive isJoined:NO viewController:self];
//    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ConfMessageViewController *mess = [[ConfMessageViewController alloc] init];
    if (indexPath.section == 0) {
        mess.confMessID = [_runningArr[indexPath.row] cid];
        mess.confMess = _runningArr[indexPath.row];
    }else if (indexPath.section == 1){
        mess.confMessID = [_repeatingArr[indexPath.row] cid];
        mess.confMess = _repeatingArr[indexPath.row];
    }else {
        mess.confMessID = [_waitingArr[indexPath.section-2][indexPath.row] cid];
        mess.confMess = _waitingArr[indexPath.section-2][indexPath.row];
        
    }
    mess.confMess.isLive = YES;
//    mess.signType = @"2"; // 这里是直播 所以传信息界面为2
    [self.navigationController pushViewController:mess animated:YES];
}

// 会议列表数据
// 正在进行的会议
- (void)requestMeeting1{
    dispatch_group_enter(_groupEnter);
    [MainNetworkRequest liveListRequestParams:nil start:[NSString stringWithFormat:@"%ld",_pageRunNumber] limit:@"10" status:@"2" success:^(id success) {
         
        if (success) {
            NSError *error = nil;
//            NSDictionary *successDic = [NSJSONSerialization JSONObjectWithData:success options:NSJSONReadingMutableContainers error:nil];
            if (!error) {
                NSLog(@"successRunningList+++%@",success[@"list"]);
                // 成功
                if ([success[@"status"] isEqualToString:@"ok"]) {
                    if (_pageRunNumber == 0) {
                        [_runningArr removeAllObjects];
                    }
                    for (NSDictionary *dic in success[@"list"]) {
                        _arrangeConf = [[ArrangeConfModel alloc] initWithDictionary:dic];
                        [_runningArr addObject:_arrangeConf];
                    }
                }
            }
            
        }
        
        dispatch_group_leave(_groupEnter);
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        dispatch_group_leave(_groupEnter);
    }];
    
    
}
// 重复的直播
- (void)requestMeeting2{
    dispatch_group_enter(_groupEnter);
    
    [MainNetworkRequest liveListRequestParams:nil start:[NSString stringWithFormat:@"%ld",_pageRepNumber] limit:@"20" status:@"5" success:^(id success) {
         
        if (success) {
            NSError *error = nil;
//            NSDictionary *success = [NSJSONSerialization JSONObjectWithData:success options:NSJSONReadingMutableContainers error:&error];
            if (!error) {
                NSLog(@"successRepeatListlive+++%@",success[@"list"]);
                // 成功
                if ([success[@"status"] isEqualToString:@"ok"]) {
                    if (_pageRepNumber == 0) {
                        [_repeatingArr removeAllObjects];
                    }
                    for (NSDictionary *dic in success[@"list"]) {
                        _arrangeConf = [[ArrangeConfModel alloc] initWithDictionary:dic];
                        [_repeatingArr addObject:_arrangeConf];
                    }
                }
            }
        }
        dispatch_group_leave(_groupEnter);
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        dispatch_group_leave(_groupEnter);
    }];
}
// 未来的直播
- (void)requestMeeting3{
    dispatch_group_enter(_groupEnter);
    
    [MainNetworkRequest liveListRequestParams:nil start:[NSString stringWithFormat:@"%ld",_pageWaitNumber] limit:@"20" status:@"1" success:^(id success) {
         
        if (success) {
            NSError *error = nil;
//            NSDictionary *successDic = [NSJSONSerialization JSONObjectWithData:success options:NSJSONReadingMutableContainers error:nil];
        // 成功
            if (!error) {
                if ([success[@"status"] isEqualToString:@"ok"]) {
                    NSLog(@"successWaitList+++%@",success[@"list"]);
                    [_tableHeaderArr removeAllObjects];
                    if (_pageWaitNumber == 0) {
                        
                        [tmpWaitingArr removeAllObjects];
                        [_waitingArr removeAllObjects];
                    }
                    
                    for (NSDictionary *dic in success[@"list"]) {
                        ArrangeConfModel *arrangeConf = [[ArrangeConfModel alloc] initWithDictionary:dic];
                        [tmpWaitingArr addObject:arrangeConf];
                    }
                    // 按时间先后进行排序
                    __weak typeof(self) weakSelf = self;
                    [tmpWaitingArr sortUsingComparator:^NSComparisonResult(ArrangeConfModel *obj1, ArrangeConfModel *obj2) {
                        return [[weakSelf getDate:obj1.startTime] compare:[weakSelf getDate:obj2.startTime]];
                    }];
                    // arr 数据 通过getWaitingArray方法将tmpWaitingArr进行分类 按照日期前后进行分组排序
                   
                    _waitingArr = [self getWaitingArray:[[NSMutableArray alloc] initWithArray:tmpWaitingArr]];
                    NSLog(@"%@",_waitingArr);
                    
                }
            }
        }
        dispatch_group_leave(_groupEnter);
    } failure:^(id failure) {
        
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        dispatch_group_leave(_groupEnter);
    }];
    
    
}
// 解析会议列表数据 ^^^^^^^^^^^^^^^^^^^^^^^^^^^
- (void)requestConfListData{
    //    [MBProgressHUD cc_showLoading:nil];
//    canClickCell = NO;
    
    //    self.tableView.userInteractionEnabled = NO;
    // 将三个请求添加到队列
    dispatch_group_async(_groupEnter, _queueEnter, ^{
        // 正在进行的会议
        [self requestMeeting1];
    });
    dispatch_group_async(_groupEnter, _queueEnter, ^{
        // 重复的会议
        [self requestMeeting2];
    });
    dispatch_group_async(_groupEnter, _queueEnter, ^{
        // 未来的会议
        [self requestMeeting3];
    });
    
    dispatch_group_notify(_groupEnter, dispatch_get_main_queue(), ^{
        // 返回主线程 刷新UI
//        dispatch_async(dispatch_get_main_queue(), ^{
        
            [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
            self.tableView.emptyDataSetSource = self;
            self.tableView.emptyDataSetDelegate = self;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            if (_pageWaitNumber != 0) {
                NSInteger tmpCount = _runningArr.count + tmpWaitingArr.count + _repeatingArr.count;
                // 判断数组个数 显示不同页脚标题
                if (tmpCount == 0) {
                    [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }else{
                    if (_sumCount == tmpCount) {
                        [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else {
                        [self.tableView.mj_footer endRefreshing];
                    }
                    
                }
                NSLog(@"sumCountsumCount %ld    %ld", _sumCount, tmpCount);
                _sumCount = tmpCount;
            }else {
                [self.tableView.mj_footer endRefreshing];
            }
            
            
//        });
    });
}
- (NSMutableArray *)getWaitingArray:(NSMutableArray *)mArray{
    NSMutableArray *dateMutablearray = [@[] mutableCopy];
    for (int i = 0; i < mArray.count; i ++) {
        ArrangeConfModel *model_i = mArray[i];
        NSMutableArray *tempArray = [@[] mutableCopy];
        [tempArray addObject:model_i];
        if (![model_i isKindOfClass:[NSNull class]]) {
            for (int j = i+1; j < mArray.count; j ++) {
                ArrangeConfModel *model_j = mArray[j];
                if([[model_i.startTime substringToIndex:10] isEqualToString:[model_j.startTime substringToIndex:10]]){
                    [tempArray addObject:model_j];
                    [mArray replaceObjectAtIndex:j withObject:[NSNull null]];
                }
            }
            if (![tempArray containsObject:[NSNull null]]) {
                [dateMutablearray addObject:tempArray];
                [_tableHeaderArr addObject:[NSString dateTranformDayStrFromTimeStr:[tempArray[0] startTime]]];
            }
        }
    }
    
    return dateMutablearray;
}
- (NSDate *)getDate:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter dateFromString:dateStr];
}
//- (NSString *)dateTransform:(NSString *)dateString {
//    // 日期赋值
//    NSString *dateStart = dateString;
//    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
//    [inputFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//    [inputFormatter setLocale:locale];
//    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate* inputDate = [inputFormatter dateFromString:dateStart];
//    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//    [outputFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
//    if ([inputDate isToday]) {
//        [outputFormatter setDateFormat:SIMLocalizedString(@"TimeToday", nil)];
//    }else if ([inputDate isTomorrow]){
//        [outputFormatter setDateFormat:SIMLocalizedString(@"TimeTomorrow", nil)];
//    }else if ([inputDate isAfterTomorrow]){
//        [outputFormatter setDateFormat:SIMLocalizedString(@"TimeAfterTomorrow", nil)];
//    }else {
//        [outputFormatter setDateFormat:SIMLocalizedString(@"TimeYearANDday", nil)];
//    }
//    NSLocale *locale2 = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//    [outputFormatter setLocale:locale2];
//    NSString *dateHour = [outputFormatter stringFromDate:inputDate];
//    return dateHour;
//}




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

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [MainNetworkRequest cancelAllRequest];
//    NSLog(@"viewWillDisappear cancelAllRequest3");
//}

@end
