//
//  SIMMainSubIconViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/11/20.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMMainSubIconViewController.h"
#import "SIMNMmainCell.h"
#import "SIMNModel.h"
#import "SIMConfDocumentViewController.h"
#import "SIMArrangeDetailViewController.h"
#import "SIMCloudSpaceViewController.h"
#import "SIMNewMainPayViewController.h"
#import "SIMMapViewController.h"
#import "SIMOrderPayNextViewController.h"

@interface SIMMainSubIconViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) SIMBaseTableView *tableView;
@property (strong,nonatomic) NSMutableArray *arr;

@end

static NSString *reuseNew = @"SIMNMmainCell";

@implementation SIMMainSubIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr = [NSMutableArray array];
    if ([self.typeStr isEqualToString:@"5006"]) {
        // 会议模式
        self.title = SIMLocalizedString(@"MainPageMoreLanguageTitle", nil);
//        [self addConfModelDatas];
        [self addTeachModelDatas:@"confmode"];
    }else if ([self.typeStr isEqualToString:@"5007"]) {
        // 教学模式
        self.title = SIMLocalizedString(@"MainPageTeachModeTitle", nil);
        [self addTeachModelDatas:@"teaching"];
    }else if ([self.typeStr isEqualToString:@"5008"]) {
        // 远程医疗
        self.title = SIMLocalizedString(@"MainPageTelemedicineTitle", nil);
//        [self addTelemedicineDatas];
        [self addTeachModelDatas:@"telemedicine"];
    }else if ([self.typeStr isEqualToString:@"5009"]) {
        // 现场作业
        self.title = SIMLocalizedString(@"MainPageFieldOperationTitle", nil);
        [self addFieldOperationDatas:@"scene"];
    }else if ([self.typeStr isEqualToString:@"5004"]) {
        // 云空间
        self.title = SIMLocalizedString(@"CloudSpaceTitle", nil);
        [self addConfDocDatas];
    }else if ([self.typeStr isEqualToString:@"5010"]) {
        // 视频主页
        self.title = SIMLocalizedString(@"VideoMainPageTitle", nil);
//        [self addVideoPageDatas];
        [self addTeachModelDatas:@"homepage"];
    }else {
        
    }
    [self addsubViews];
    
}
- (void)addsubViews {
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height - StatusNavH);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];

    [self.tableView registerClass:[SIMNMmainCell class] forCellReuseIdentifier:reuseNew];
    
}
#pragma mark - TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SIMNModel *model = _arr[indexPath.section];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SIMNMmainCell class] contentViewWidth:screen_width];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMNMmainCell *btnListCell = [tableView dequeueReusableCellWithIdentifier:reuseNew];
    SIMNModel *modelD = _arr[indexPath.section];
    btnListCell.model = modelD;
    
    __weak typeof (self)weakSlf = self;
    btnListCell.indexTagBlock = ^(NSInteger btnserial) {
        [weakSlf btnSerialClickMethod:btnserial];
    };
    return btnListCell;
}
- (void)btnSerialClickMethod:(NSInteger)btnserial {
//    if (btnserial == 20001) {
//        // 会议文档
//        SIMConfDocumentViewController *confDoc = [[SIMConfDocumentViewController alloc] init];
//        confDoc.pageType = @"doc";
//        [self.navigationController pushViewController:confDoc animated:YES];
//    }else if (btnserial == 20002){
//        // 速记文档
//        SIMConfDocumentViewController *confDoc = [[SIMConfDocumentViewController alloc] init];
//        confDoc.pageType = @"shorthand";
//        [self.navigationController pushViewController:confDoc animated:YES];
//    }else
        if (btnserial == 10009){
        // 地图
        SIMMapViewController *mapVC = [[SIMMapViewController alloc] init];
        [self.navigationController pushViewController:mapVC animated:YES];
    }
//        else if (btnserial >= 10001 && btnserial <= 10008){
//        // 安排会议等会议模式
//        SIMArrangeDetailViewController *arrangeVC = [[SIMArrangeDetailViewController alloc] init];
//        arrangeVC.serialStr = btnserial;
//        arrangeVC.navigationItem.title = SIMLocalizedString(@"MArrangeConf", nil);// 和编辑会议区分
//        [self.navigationController pushViewController:arrangeVC animated:YES];
//    }
//    else if (btnserial >= 20003 && btnserial <= 20010){
//        // 钢琴课等教学模式远程医疗等
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] && [self.cloudVersion.plan boolValue]) {
//            SIMNewMainPayViewController *planVC = [[SIMNewMainPayViewController alloc] init];
//            [self.navigationController pushViewController:planVC animated:YES];
//        }else {
//            [MBProgressHUD cc_showText:@"请联系我们开通"];
//        }
//    }else if (btnserial >= 20011 && btnserial <= 20014){
//        // 视频主页
//        [MBProgressHUD cc_showText:@"请联系我们开通"];
//    }
//    else if (btnserial == 2003 || btnserial == 2004 || btnserial == 2005){
//        SIMNewMainPayViewController *planVC = [[SIMNewMainPayViewController alloc] init];
//        [self.navigationController pushViewController:planVC animated:YES];
//    }
    else {
        if ([self.typeStr isEqualToString:@"5006"] || [self.typeStr isEqualToString:@"5007"] || [self.typeStr isEqualToString:@"5008"] || [self.typeStr isEqualToString:@"5009"] || [self.typeStr isEqualToString:@"5010"]) {
            NSLog(@"教学模式");
            // 教学模式
            // 钢琴课等教学模式远程医疗等
            SIMNModel *model = _arr[0];
            NSArray *arr = model.btn_list;
            NSString *clickSerial = [NSString stringWithFormat:@"%ld",btnserial];
            SIMNModel_btnList *listModel = nil;
            for (SIMNModel_btnList *list in arr) {
                if ([list.serial isEqualToString:clickSerial]) {
                    listModel = list;
                }
            }
            if (!listModel.isbuy) {
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] && [self.cloudVersion.plan boolValue]) {
                    SIMOrderPayNextViewController *planDetailVC = [[SIMOrderPayNextViewController alloc] init];
                    planDetailVC.teachID = clickSerial;
                    [self.navigationController pushViewController:planDetailVC animated:YES];
                }else {
                    [MBProgressHUD cc_showText:@"请联系我们开通"];
                }
            }else {
                // 安排会议
                SIMArrangeDetailViewController *arrangeVC = [[SIMArrangeDetailViewController alloc] init];
                if ([listModel.conf_type isEqualToString:@"teaching"]) {
                    arrangeVC.navigationItem.title = @"安排课表";
                }else {
                    arrangeVC.navigationItem.title = SIMLocalizedString(@"MArrangeConf", nil);
                }
                arrangeVC.teachNameStr = listModel.titleName;
                arrangeVC.teachIDStr = clickSerial;
                [self.navigationController pushViewController:arrangeVC animated:YES];
            }
            
        }else if ([self.typeStr isEqualToString:@"5004"]) {
            // 云空间
            NSLog(@"云空间");
            SIMNModel *model = _arr[0];
            NSArray *arr = model.btn_list;
            NSString *clickSerial = [NSString stringWithFormat:@"%ld",btnserial];
            SIMNModel_btnList *listModel = nil;
            for (SIMNModel_btnList *list in arr) {
                if ([list.serial isEqualToString:clickSerial]) {
                    listModel = list;
                }
            }
            if ([listModel.space_type isEqualToString:@"plan"]) {
                // 支付页面
                SIMNewMainPayViewController *planVC = [[SIMNewMainPayViewController alloc] init];
                [self.navigationController pushViewController:planVC animated:YES];
            }else {
                SIMCloudSpaceViewController *cloudSpaceVC = [[SIMCloudSpaceViewController alloc] init];
                cloudSpaceVC.model = listModel;
                [self.navigationController pushViewController:cloudSpaceVC animated:YES];
            }
        }
        
    }
}
// 云空间 网络请求后台活动参数+会议文档会议速记
- (void)addConfDocDatas {
    NSMutableArray *allArrM = [NSMutableArray array];
//    if (self.cloudVersion.webFileUrl.length > 0) {
//        [allArrM addObject:@{
//            @"titleName":SIMLocalizedString(@"CloudSpaceDocTitle", nil),
//            @"bannerPic":@"main_会议文件",
//            @"serial":@"20001"
//        }];
//    }
//    if ([self.cloudVersion.shorthand boolValue]) {
//        [allArrM addObject:@{
//            @"titleName":SIMLocalizedString(@"CloudSpaceMinutesTitle", nil),
//            @"bannerPic":@"main_速记文档",
//            @"serial":@"20002"
//        }];
//    }
//    NSDictionary *dd1 = @{@"mainTitle":@"文档管理",@"btn_list":allArrM,@"serial":@"003"};
//    SIMNModel *model1 = [[SIMNModel alloc] initWithDictionary:dd1];
//    [_arr addObject:model1];
    
    if ([self.cloudVersion.cloud_space boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
        [MainNetworkRequest cloudspaceClassRequestParams:nil success:^(id success) {
            NSLog(@"cloudspaceClassListSuccess %@",success);
            if ([success[@"code"] integerValue] == successCodeOK) {
                [_arr removeAllObjects];
                NSArray *arr = success[@"data"];
                for (NSDictionary *dic in arr) {
                    SIMNModel_btnList *list = [[SIMNModel_btnList alloc] initWithDictionary:dic];
                    list.webData = YES;
                    list.serial = [dic[@"id"] stringValue];// 转化类型
                    [allArrM addObject:list];
                }
                NSDictionary *dd1 = @{@"mainTitle":@"更多",@"btn_list":allArrM,@"serial":@"003"};
                SIMNModel *model1 = [[SIMNModel alloc] initWithDictionary:dd1];
                [_arr addObject:model1];
                [self.tableView reloadData];
            }else {
                [MBProgressHUD cc_showText:success[@"msg"]];
            }
        } failure:^(id failure) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        }];
    }
}
// 会议模式
- (void)addConfModelDatas {
    NSMutableArray *allArrM = [NSMutableArray array];
//    if ([self.cloudVersion.freeCamera boolValue]) {
        [allArrM addObject:@{
            @"titleName":SIMLocalizedString(@"ConfModelFreeCamaraTitle", nil),
            @"bannerPic":@"main_自由讨论会议",
            @"serial":@"10001"
        }];
//    }
//    if ([self.cloudVersion.mainBroadcast boolValue]) {
        [allArrM addObject:@{
            @"titleName":SIMLocalizedString(@"ConfModelMainBroadcastTitle", nil),
            @"bannerPic":@"main_网络广播会议",
            @"serial":@"10002"
        }];
//    }
//    if ([self.cloudVersion.mainCamera boolValue]) {
        [allArrM addObject:@{
            @"titleName":SIMLocalizedString(@"ConfModelMainCameraTitle", nil),
            @"bannerPic":@"main_网络研讨会",
            @"serial":@"10003"
        }];
//    }
    if ([self.cloudVersion.intercom boolValue]) {
        [allArrM addObject:@{
            @"titleName":SIMLocalizedString(@"ConfModesIntercomTitle", nil),
            @"bannerPic":@"main_对讲机模式会议",
            @"serial":@"10004"
        }];
    }
    if ([self.cloudVersion.EHSfieldOperation boolValue]) {
        [allArrM addObject:@{
            @"titleName":SIMLocalizedString(@"ConfModelEHSfieldOperationTitle", nil),
            @"bannerPic":@"main_EHS现场作业",
            @"serial":@"10005"
        }];
    }
    if ([self.cloudVersion.voiceSeminar boolValue]) {
        [allArrM addObject:@{
            @"titleName":SIMLocalizedString(@"ConfModelVoiceSeminarTitle", nil),
            @"bannerPic":@"main_语音电话会议",
            @"serial":@"10006"
        }];
    }
//    if ([self.cloudVersion.trainingConference boolValue]) {
//        [allArrM addObject:@{
//            @"titleName":SIMLocalizedString(@"ConfModelTrainingConferenceTitle", nil),
//            @"bannerPic":@"main_在线培训会议",
//            @"serial":@"10007"
//        }];
//    }
//    if ([self.cloudVersion.live boolValue]) {
//        [allArrM addObject:@{
//            @"titleName":SIMLocalizedString(@"ConfModesLiveTitle", nil),
//            @"bannerPic":@"main_在线培训会议拷贝",
//            @"serial":@"10008"
//        }];
//    }
    NSDictionary *dd1 = @{@"mainTitle":@"更多",@"btn_list":allArrM,@"serial":@"002"};
    SIMNModel *model1 = [[SIMNModel alloc] initWithDictionary:dd1];
    [_arr addObject:model1];
}
// 教学模式
- (void)addTeachModelDatas:(NSString *)iconID {
    NSMutableArray *allArrM = [NSMutableArray array];
//    [allArrM addObject:@{
//        @"titleName":SIMLocalizedString(@"TeachModeLanguageTitle", nil),
//        @"bannerPic":@"main_语文课",
//        @"serial":@"20003"
//    }];
//    [allArrM addObject:@{
//        @"titleName":SIMLocalizedString(@"TeachModeMathTitle", nil),
//        @"bannerPic":@"main_数学课",
//        @"serial":@"20004"
//    }];
//    [allArrM addObject:@{
//        @"titleName":SIMLocalizedString(@"TeachModeEnglishTitle", nil),
//        @"bannerPic":@"main_英语课",
//        @"serial":@"20005"
//    }];
//    [allArrM addObject:@{
//        @"titleName":SIMLocalizedString(@"TeachModePianoTitle", nil),
//        @"bannerPic":@"main_钢琴课",
//        @"serial":@"20006"
//    }];
//    [allArrM addObject:@{
//        @"titleName":SIMLocalizedString(@"TeachModePhysicalTitle", nil),
//        @"bannerPic":@"main_物理课",
//        @"serial":@"20007"
//    }];
//    [allArrM addObject:@{
//        @"titleName":SIMLocalizedString(@"TeachModeChemistryTitle", nil),
//        @"bannerPic":@"main_化学课",
//        @"serial":@"20008"
//    }];
    [MainNetworkRequest classmodelListRequestParams:nil iconid:iconID success:^(id success) {
        NSLog(@"cloudspaceClassListSuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [_arr removeAllObjects];
            NSArray *arr = success[@"data"];
            for (NSDictionary *dic in arr) {
                SIMNModel_btnList *list = [[SIMNModel_btnList alloc] initWithDictionary:dic];
                list.webData = YES;
                list.serial = [dic[@"id"] stringValue];// 转化类型
                [allArrM addObject:list];
            }
            NSDictionary *dd1 = @{@"mainTitle":@"更多",@"btn_list":allArrM,@"serial":@"002"};
            SIMNModel *model1 = [[SIMNModel alloc] initWithDictionary:dd1];
            [_arr addObject:model1];
    
            [self.tableView reloadData];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
}
// 远程医疗
- (void)addTelemedicineDatas {
    NSMutableArray *allArrM = [NSMutableArray array];
    [allArrM addObject:@{
        @"titleName":SIMLocalizedString(@"MainPageOnlineMedicalTitle", nil),
        @"bannerPic":@"main_在线医疗",
        @"serial":@"20009"
    }];
    [allArrM addObject:@{
        @"titleName":SIMLocalizedString(@"MainPageTelemedicineTitle", nil),
        @"bannerPic":@"main_远程医疗",
        @"serial":@"20010"
    }];
    NSDictionary *dd1 = @{@"mainTitle":@"更多",@"btn_list":allArrM,@"serial":@"002"};
    SIMNModel *model1 = [[SIMNModel alloc] initWithDictionary:dd1];
    [_arr addObject:model1];
}
// 现场作业
- (void)addFieldOperationDatas:(NSString *)iconID {
    NSMutableArray *allArrM = [NSMutableArray array];
//    if ([self.cloudVersion.EHSfieldOperation boolValue]) {
//        [allArrM addObject:@{
//            @"titleName":SIMLocalizedString(@"ConfModelEHSfieldOperationTitle", nil),
//            @"bannerPic":@"main_EHS现场作业",
//            @"serial":@"10005"
//        }];
//    }
//    if ([self.cloudVersion.intercom boolValue]) {
//        [allArrM addObject:@{
//            @"titleName":SIMLocalizedString(@"ConfModesIntercomTitle", nil),
//            @"bannerPic":@"main_对讲机模式会议",
//            @"serial":@"10004"
//        }];
//    }
    if ([self.cloudVersion.map_position boolValue]) {
        [allArrM addObject:@{@"titleName":SIMLocalizedString(@"CCMapTitleAbbreviation", nil),
                             @"bannerPic":@"地图定位",
                             @"serial":@"10009"}];
    }
    NSDictionary *dd1 = @{@"mainTitle":@"更多",@"btn_list":allArrM,@"serial":@"002"};
    SIMNModel *model1 = [[SIMNModel alloc] initWithDictionary:dd1];
    [_arr addObject:model1];
    
    [MainNetworkRequest classmodelListRequestParams:nil iconid:iconID success:^(id success) {
        NSLog(@"sceneClassmodelListSuccess %@",success);
        [_arr removeAllObjects];
        if ([success[@"code"] integerValue] == successCodeOK) {
            NSArray *arr = success[@"data"];
            for (NSDictionary *dic in arr) {
                SIMNModel_btnList *list = [[SIMNModel_btnList alloc] initWithDictionary:dic];
                list.webData = YES;
                list.serial = [dic[@"id"] stringValue];// 转化类型
                [allArrM addObject:list];
            }
            NSDictionary *dd1 = @{@"mainTitle":@"更多",@"btn_list":allArrM,@"serial":@"002"};
            SIMNModel *model1 = [[SIMNModel alloc] initWithDictionary:dd1];
            [_arr addObject:model1];
            
            [self.tableView reloadData];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
    
}
- (void)addVideoPageDatas {
    NSMutableArray *allArrM = [NSMutableArray array];
    [allArrM addObject:@{
        @"titleName":SIMLocalizedString(@"VideoMainPageTitle", nil),
        @"bannerPic":@"main_视频主页",
        @"serial":@"20011"
    }];
    [allArrM addObject:@{
        @"titleName":SIMLocalizedString(@"MMessEditLive", nil),
        @"bannerPic":@"main_直播",
        @"serial":@"20012"
    }];
    [allArrM addObject:@{
        @"titleName":SIMLocalizedString(@"VMP_Interactive", nil),
        @"bannerPic":@"main_互动直播",
        @"serial":@"20013"
    }];
    
    [allArrM addObject:@{
        @"titleName":SIMLocalizedString(@"NPayMainSeverce_titleThree", nil),
        @"bannerPic":@"main_视频客服-1",
        @"serial":@"20014"
    }];
    
    NSDictionary *dd1 = @{@"mainTitle":SIMLocalizedString(@"VideoMainPageTitle", nil),@"btn_list":allArrM,@"serial":@"002"};
    SIMNModel *model1 = [[SIMNModel alloc] initWithDictionary:dd1];
    [_arr addObject:model1];
}


@end
