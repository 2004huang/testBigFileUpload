//
//  SIMNMmainViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/4.
//  Copyright © 2018年 Ferris. All rights reserved.
//
//#define MineCustomSeverID @"27578231060"

#import "SIMNMmainViewController.h"

#import "SIMNMmainCell.h"
#import "SIMMainNewFooter.h"
#import "SIMBottomView.h"
#import "SIMWellBeingCell.h"

#import "SIMFootImageModel.h"
#import "SIMNModel.h"
#import "ArrangeConfModel.h"
#import "SIMPrivateMainPageCell.h"

#import "SIMLearnPicViewController.h"
#import "SIMJoinMeetingViewController.h"
#import "SIMArrangeDetailViewController.h"
#import "SIMMyRoomViewController.h"
#import "SIMMapViewController.h"
#import "SIMNewMainPayViewController.h"
#import "SIMNewPlanListModel.h"
#import <CoreLocation/CoreLocation.h>
#import "SIMMainSubIconViewController.h"
#import "SIMMessNotifListViewController.h"
#import "SIMFindPageViewController.h"
#import "SIMTempCompanyViewController.h"
#import "SIMMainPlanDetailViewController.h"
#import "SIMManTranslationController.h"
#import "SIMCSMainViewController.h"


@interface SIMNMmainViewController ()<UITableViewDelegate,UITableViewDataSource,CLConferenceDelegate>

@property (strong,nonatomic) SIMBaseTableView* tableView;
@property (strong,nonatomic) NSArray *arrAll;
@property (strong,nonatomic) NSMutableArray *footArr;
@property (nonatomic, strong) ArrangeConfModel *myConf;
@property (nonatomic, strong) SIMMainNewFooter *footV;
@property (nonatomic, strong) NSString *urlshareStr;
@property (nonatomic, strong) SIMBottomView *bottomView;
@property (nonatomic, assign) BOOL isCanClick;
@end

static NSString *reuseNew = @"SIMNMmainCell";
static NSString *reuseFoot = @"SIMWellBeingCell";
static NSString *reuseNewPrivate = @"SIMPrivateMainPageCell";
@implementation SIMNMmainViewController
-(instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reNetWorkActive) name:NetWorkReConnect object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
// 重新登录入会-- （这个方法只是在第一次进入没网才会走）没网络链接,需要重新查询服务器,防止第一次进入时候就没网没查到地址
- (void)reNetWorkActive
{
    [self searchHasPlan];  // 检测是否有计划
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isCanClick = YES;
    _footArr = [NSMutableArray array];
    [self addDatas];
    [self searchHasPlan];  // 检测是否有计划
    [self addsubViews];    // 创建视图
}

- (void)addsubViews {
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height - TabbarH - StatusNavH);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
//    self.tableView.estimatedRowHeight = 50;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    if ([self.cloudVersion.version isEqualToString:@"privatization"]) {
        [self.tableView registerClass:[SIMPrivateMainPageCell class] forCellReuseIdentifier:reuseNewPrivate];
    }else {
        [self.tableView registerClass:[SIMNMmainCell class] forCellReuseIdentifier:reuseNew];
    }
    [self.tableView registerClass:[SIMWellBeingCell class] forCellReuseIdentifier:reuseFoot];
//    if ([self.cloudVersion.special_note boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
//        [self bottomViewUI];
//
//    }
    MJRefreshNormalHeader *refreshHead = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    refreshHead.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = refreshHead;
}
- (void)loadNewData {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
        [self footerViewRequestDatas];
    }else {
        [self.tableView.mj_header endRefreshing];
    }
}
- (void)bottomViewUI {
    if (!_bottomView) {
        _bottomView = [[SIMBottomView alloc] init];
        _bottomView.dic = [[NSDictionary alloc] init];
        [self.view addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(kWidthS(140));
            make.bottom.mas_equalTo(0);
        }];
        
        __weak typeof(self) weakSelf = self;
        _bottomView.btnClick = ^{
            SIMMessNotifListViewController *messVC = [[SIMMessNotifListViewController alloc] init];
            messVC.title = SIMLocalizedString(@"WellBeingTitle", nil);
            [weakSelf.navigationController pushViewController:messVC animated:YES];
        };
        _bottomView.wellBeingBtnClick = ^{
            SIMNewMainPayViewController *planVC = [[SIMNewMainPayViewController alloc] init];
            [weakSelf.navigationController pushViewController:planVC animated:YES];
        };
        
    }
    
}

#pragma mark - TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _footArr.count + 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        SIMNModel *model = _arrAll[indexPath.section];
        if ([self.cloudVersion.version isEqualToString:@"privatization"]) {
            return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SIMPrivateMainPageCell class] contentViewWidth:screen_width];
        }else {
            return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SIMNMmainCell class] contentViewWidth:screen_width];
           
        }
    }else {
        return [self.tableView cellHeightForIndexPath:indexPath cellContentViewWidth:screen_width tableView:tableView];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 14;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (section == 0) {
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
//            CGFloat sumHei = 0.0;
//            for (NSDictionary *dic in _footArr) {
//                CGFloat picHei = [[dic objectForKey:@"height"] floatValue]/2;
//                sumHei += picHei + 10;
//            }
//            NSLog(@"sumHeisumHei %lf",sumHei);
//
//
//            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 20 + kWidthScale(sumHei))];
//            backView.backgroundColor = [UIColor whiteColor];
//
//
//            _footV = [[SIMMainNewFooter alloc] init];
//            _footV.arr = _footArr;
//            _footV.frame = CGRectMake(0, 20, screen_width, kWidthScale(sumHei));
//            [backView addSubview:_footV];
//
//            __weak typeof (self)weakSlf = self;
//            _footV.picIndexBlock = ^(NSInteger picserial) {
//                NSDictionary *dic = weakSlf.footArr[picserial];
//                if ([dic[@"jump_type"] isEqualToString:@"url"]) {
//                    // 跳到隐私政策
//                    SIMTempCompanyViewController *webVC = [[SIMTempCompanyViewController alloc] init];
//                    webVC.navigationItem.title = @"完善信息";
//                    if ([dic[@"jump_val"] containsString:@"http"]) {
//                        webVC.webStr = [NSString stringWithFormat:@"%@",dic[@"jump_val"]];
//                    }else {
//                        webVC.webStr = [NSString stringWithFormat:@"%@/%@",kApiBaseUrl,dic[@"jump_val"]];
//                    }
//                    [weakSlf.navigationController pushViewController:webVC animated:YES];
//                }else if ([dic[@"jump_type"] isEqualToString:@"internal"]) {
//                    if ([dic[@"jump_val"] isEqualToString:@"server_center"]) {
//                        // 服务中心
//                        SIMMainPlanDetailViewController *planVC = [[SIMMainPlanDetailViewController alloc] init];
//                        [weakSlf.navigationController pushViewController:planVC animated:YES];
//                    }
//                }else if ([dic[@"jump_type"] isEqualToString:@"conf"] && [dic[@"jump_val"] length] != 0) {
//                    [SIMNewEnterConfTool enterTheMineConfWithCid:dic[@"jump_val"] psw:@"" confType:0 isJoined:NO viewController:weakSlf];
//                }
//
//            };
//            return backView;
//        }else {
//            return nil;
//        }
//    }else {
        
//    }
    if (_footArr.count > 0) {
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 14)];
        lineV.backgroundColor = ZJYColorHex(@"#f7f7f7");
        return lineV;
    }else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if ([self.cloudVersion.version isEqualToString:@"privatization"]) {
            SIMPrivateMainPageCell *btnListCell = [tableView dequeueReusableCellWithIdentifier:reuseNewPrivate];
            SIMNModel *modelD = _arrAll[indexPath.section];
            btnListCell.model = modelD;
            
            __weak typeof (self)weakSlf = self;
            btnListCell.indexTagBlock = ^(NSInteger btnserial) {
                [weakSlf btnSerialClickMethod:btnserial];
            };
            return btnListCell;
        }else {
            SIMNMmainCell *btnListCell = [tableView dequeueReusableCellWithIdentifier:reuseNew];
            SIMNModel *modelD = _arrAll[indexPath.section];
            btnListCell.model = modelD;
            
            __weak typeof (self)weakSlf = self;
            btnListCell.indexTagBlock = ^(NSInteger btnserial) {
                [weakSlf btnSerialClickMethod:btnserial];
            };
            return btnListCell;
        }
    }else {
        SIMWellBeingCell *fCell = [tableView dequeueReusableCellWithIdentifier:reuseFoot];
        SIMFootImageModel *modelF = _footArr[indexPath.section - 1];
        fCell.model = modelF;
        return fCell;
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
    }else {
        SIMFootImageModel *model = _footArr[indexPath.section - 1];
        if ([model.jump_type isEqualToString:@"url"]) {
            // 跳到隐私政策
            SIMTempCompanyViewController *webVC = [[SIMTempCompanyViewController alloc] init];
            webVC.navigationItem.title = model.title;
            webVC.mainShare = YES;
            webVC.imageModel = model;
            if ([model.jump_val containsString:@"http"]) {
                webVC.webStr = [NSString stringWithFormat:@"%@",model.jump_val];
            }else {
                webVC.webStr = [NSString stringWithFormat:@"%@/%@",kApiBaseUrl,model.jump_val];
            }
            [self.navigationController pushViewController:webVC animated:YES];
        }else if ([model.jump_type isEqualToString:@"internal"]) {
            if ([model.jump_val isEqualToString:@"server_center"]) {
                // 服务中心
                SIMMainPlanDetailViewController *planVC = [[SIMMainPlanDetailViewController alloc] init];
                [self.navigationController pushViewController:planVC animated:YES];
            }else if ([model.jump_val isEqualToString:@"plan"]) {
                // 计划
                SIMNewMainPayViewController *planVC = [[SIMNewMainPayViewController alloc] init];
                [self.navigationController pushViewController:planVC animated:YES];
            }else if ([model.jump_val isEqualToString:@"interpreter"]) {
                // 同声传译
                SIMManTranslationController *planVC = [[SIMManTranslationController alloc] init];
                [self.navigationController pushViewController:planVC animated:YES];
            }
        }else if ([model.jump_type isEqualToString:@"conf"] && [model.jump_val length] != 0) {
            [SIMNewEnterConfTool enterTheMineConfWithCid:model.jump_val psw:@"" confType:0 isJoined:NO viewController:self];
        }
    }
}
- (void)btnSerialClickMethod:(NSInteger)btnserial {
    if (btnserial == 5001) {
        // 开始会议
        SIMMyRoomViewController *roomVC = [[SIMMyRoomViewController alloc] init];
        roomVC.isLive = NO;
        roomVC.navigationItem.title = SIMLocalizedString(@"MMainConfRepsonAConf", nil);
        [self.navigationController pushViewController:roomVC animated:YES];
        
    }else if (btnserial == 5002){
        // 加入会议
        SIMJoinMeetingViewController *joinVC = [[SIMJoinMeetingViewController alloc] init];
        joinVC.isLive = NO;
        joinVC.navigationItem.title = SIMLocalizedString(@"MJoinTheMeeting", nil);
        [self.navigationController pushViewController:joinVC animated:YES];
    }else if (btnserial == 5003){
        // 安排会议
        SIMArrangeDetailViewController *arrangeVC = [[SIMArrangeDetailViewController alloc] init];
        arrangeVC.navigationItem.title = SIMLocalizedString(@"MArrangeConf", nil);// 和编辑会议区分
        [self.navigationController pushViewController:arrangeVC animated:YES];
    }
    else if (btnserial == 5008){
        SIMCSMainViewController *cloudVC = [[SIMCSMainViewController alloc] init];
        [self.navigationController pushViewController:cloudVC animated:YES];
    }
    else if (btnserial == 5009){
        SIMMainSubIconViewController *subVC = [[SIMMainSubIconViewController alloc] init];
        subVC.typeStr = [NSString stringWithFormat:@"%ld",btnserial];
        [self.navigationController pushViewController:subVC animated:YES];
    }else if (btnserial == 5007 || btnserial == 5010){
        SIMLearnPicViewController *leVC = [[SIMLearnPicViewController alloc] init];
        leVC.typeStr = btnserial;
        [self.navigationController pushViewController:leVC animated:YES];
        
    }
//    else if (btnserial == 5005){
//        SIMMapViewController *mapVC = [[SIMMapViewController alloc] init];
//        [self.navigationController pushViewController:mapVC animated:YES];
//    }else if (btnserial == 5007){
//        SIMFindPageViewController *subVC = [[SIMFindPageViewController alloc] init];
//        [self.navigationController pushViewController:subVC animated:YES];
//    }
}
- (void)addDatas {
    NSMutableArray *allArrM = [NSMutableArray array];
    if ([self.cloudVersion.start_meeting boolValue]) {
        [allArrM addObject:@{@"titleName":SIMLocalizedString(@"MMainConfHeaderStartAMeeting", nil),
                             @"bannerPic":@"开始会议",
                             @"serial":@"5001"}];
    }
    if ([self.cloudVersion.join_meeting boolValue]) {
        [allArrM addObject:@{@"titleName":SIMLocalizedString(@"MMainConfHeaderJoin", nil),
                             @"bannerPic":@"加入会议",
                             @"serial":@"5002"}];
    }
    if ([self.cloudVersion.arrange_meeting boolValue]) {
        [allArrM addObject:@{@"titleName":SIMLocalizedString(@"MMainConfHeaderSchedule", nil),
                             @"bannerPic":@"安排会议",
                             @"serial":@"5003"}];
    }
//#if TypeClassBao
//
//#else
//    [allArrM addObject:@{@"titleName":SIMLocalizedString(@"MainPageMoreLanguageTitle", nil),
//                        @"bannerPic":@"main_会议模式",
//                        @"serial":@"5006"}];
//#endif
    
    if ([self.cloudVersion.cloud_space boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
        [allArrM addObject:@{@"titleName":SIMLocalizedString(@"CloudSpaceTitle", nil),
                            @"bannerPic":@"main_云空间",
                            @"serial":@"5008"}];
    }
    
//    if ([self.cloudVersion.teaching_model boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
//        [allArrM addObject:@{@"titleName":@"知识店铺",
//                            @"bannerPic":@"main_教学模式",
//                            @"serial":@"5007"}];
//    }
//    if ([self.cloudVersion.video_home boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
//        [allArrM addObject:@{@"titleName":SIMLocalizedString(@"VideoMainPageTitle", nil),
//                            @"bannerPic":@"main_视频主页",
//                            @"serial":@"5010"}];
//    }
    if ([self.cloudVersion.field_operation boolValue]) {
        [allArrM addObject:@{@"titleName":@"业务",
                            @"bannerPic":@"main_业务",
                            @"serial":@"5009"}];
    }
//
//    if ([self.cloudVersion.telemedicine boolValue]) {
//        [allArrM addObject:@{@"titleName":SIMLocalizedString(@"MainPageTelemedicineTitle", nil),
//                                   @"bannerPic":@"main_远程医疗",
//                                   @"serial":@"5008"}];
//    }
    NSDictionary *dd1 = @{@"mainTitle":@"视频会议",@"btn_list":allArrM,@"serial":@"001"};

    SIMNModel *model1 = [[SIMNModel alloc] initWithDictionary:dd1];
    
    _arrAll = @[model1];
}

// 是否上线展示支付相关内容 
- (void)searchHasPlan {
    [MainNetworkRequest hidePlanRequestParams:nil success:^(id success) {
        // 成功
//        NSLog(@"hidePlanRequestSuccess  %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            
            NSDictionary *dicdata = success[@"data"];
            NSString *statustr = dicdata[@"status"];
            if ([statustr isEqualToString:@"no"]) {
                // no为不展示 (当版本号相同以及后台返回为no时候 不展示)
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showTheWechat"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else {
                // yes为展示 (其他情况 版本号不同 或者 当返回yes时候 都展示)
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showTheWechat"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            if ([self.currentUser.mobile isEqualToString:@"15110191111"]) {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showTheWechat"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            [self addDatas];
            [self.tableView reloadData];
//            if ([self.cloudVersion.special_note boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
//                [self bottomViewUI];
//            }
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
                [self footerViewRequestDatas];
            }
        }
    } failure:^(id failure) {
        
    }];
    
}
// 是否上线展示支付相关内容
- (void)footerViewRequestDatas {
    [MainNetworkRequest mainpagePicRequestParams:nil success:^(id success) {
        // 成功
//        NSLog(@"mainpagePicListSuccess  %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [_footArr removeAllObjects];
            for (NSDictionary *dic in success[@"data"]) {
                SIMFootImageModel *model = [[SIMFootImageModel alloc] initWithDictionary:dic];
                [_footArr addObject:model];
            }
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(id failure) {
        [self.tableView.mj_header endRefreshing];
    }];
}



@end
