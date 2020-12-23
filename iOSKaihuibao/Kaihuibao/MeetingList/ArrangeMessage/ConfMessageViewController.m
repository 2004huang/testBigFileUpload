//
//  ConfMessageViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/23.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "ConfMessageViewController.h"

#import "SIMBaseCommonTableViewCell.h"

#import "SIMArrangeDetailViewController.h"
#import "SIMNewLiveViewController.h"
#import "SIMTempCompanyViewController.h"
#import "SIMShareFromChooseViewController.h"
#import "SIMConfIDQRCodeViewController.h"

#import "NSDate+SIMConvenient.h"
#import "SIMShareTool.h"


typedef NS_ENUM(NSInteger, MyButtonType) {
    MyButtonTypeJoin = 1001,
    MyButtonTypeInvite,
    MyButtonTypeDelete,
    MyButtonTypeShare,
    MyButtonTypeLook,
    MyButtonTypeQRShare,
};

@interface ConfMessageViewController ()<UITableViewDelegate,UITableViewDataSource,CLConferenceDelegate>
{
    SIMBaseCommonTableViewCell *_timeCell;
    SIMBaseCommonTableViewCell *_subjectCell;
    SIMBaseCommonTableViewCell *_confIDCell;
    SIMBaseCommonTableViewCell *_confTimeCell;
    SIMBaseCommonTableViewCell *_explainCell;
    NSArray<NSArray<UITableViewCell*>*>* _cells;
    
    UITextField * passwordfiled;
    UIView* footerView;
    NSString *firstStr;
    NSString *shareStr;
    NSString *urlshareStr;
    UIButton *edit;
    NSString *liveAdressHost;
    NSString *liveAdressPort;
}
@property (nonatomic,strong) SIMBaseTableView* tableView;
@property (nonatomic, strong) UIButton *start;
@property (nonatomic, strong) UIButton *inAdd;
@property (nonatomic, strong) UIButton *liveAdd;
@property (nonatomic, strong) UIButton *lookAdd;
@property (nonatomic, strong) UIButton *deleCof;
@property (nonatomic, strong) UIButton *QRcodeShare;
@property (nonatomic, strong) ArrangeConfModel *arrangeConf;
@property (nonatomic, assign) BOOL canShared;
@property (nonatomic, strong) NSMutableArray *shareArr;   //分享邀请的数组
@end

@implementation ConfMessageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestEditData];
    [self.tableView reloadData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"MMessEdit", nil);
    
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
    
    if (self.confMess.isLive) {
        // 如果是直播 那么
        firstStr = SIMLocalizedString(@"MMessEditLive", nil);
        shareStr = SIMLocalizedString(@"MMessEditLive", nil);
        if (liveAdressPort.length > 0) {
            urlshareStr = [NSString stringWithFormat:@"%@:%@?cid=%@",liveAdressHost,liveAdressPort,_confMessID];
        }else {
            urlshareStr = [NSString stringWithFormat:@"%@?cid=%@",liveAdressHost,_confMessID];
        }

    }else {
        if ([self.signType isEqualToString:@"3"]) {
            // 营销客服 3
            NSString *title = SIMLocalizedString(@"SConfSMessEditConf", nil);
            firstStr = [[NSString alloc] initWithString:title];
        }else if ([self.signType isEqualToString:@"2"]) {
            // 视频客服 2
            NSString *title = SIMLocalizedString(@"SConfSMessEditConf", nil);
            firstStr = [[NSString alloc] initWithString:title];
        }else {
            // 会议 1 默认
            NSString *title = SIMLocalizedString(@"MMessEditConf", nil);
            firstStr = [[NSString alloc] initWithString:title];
            shareStr = [NSString stringWithFormat:@"%@%@",SIMLocalizedString(@"MMessEditConfOne", nil),title];
            urlshareStr = _confMess.roomUrl;
        }
    }
    if (self.teachIDStr != nil && [self.teachorConfStr isEqualToString:@"teaching"]) {
        // 教学模式 只有安排 是显示教学对应的名字但是不传会议模式
        NSString *title = SIMLocalizedString(@"MMessEditConf_class", nil);
        firstStr = [[NSString alloc] initWithString:title];
        shareStr = [NSString stringWithFormat:@"%@%@",SIMLocalizedString(@"MMessEditConfOne", nil),title];
        urlshareStr = _confMess.roomUrl;
    }
    [self setUpCells];
    
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 50;
    
    UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackCancelTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    if ([self.signType isEqualToString:@"3"] || [self.signType isEqualToString:@"2"]) {
         // 营销客服不可以编辑 暂时先把视频客服也不让编辑

    }else {
        if (self.popType) {
            
        }else {
            edit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
            [edit setTitle:SIMLocalizedString(@"NavBackEdit", nil) forState:UIControlStateNormal];
            [edit addTarget:self action:@selector(leftNavBtn) forControlEvents:UIControlEventTouchUpInside];
            [self editBtnCan:NO titleColor:GrayPromptTextColor];
            
            UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithCustomView:edit];
            self.navigationItem.rightBarButtonItem = done;
        }
        
    }
    
//    [MBProgressHUD cc_showLoading:nil view:self.view];
    
}
- (void)cancelBtnClick {
    if (self.popType) {
        [self popToHomeViewController];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)popToHomeViewController
{
    
    if (self.navigationController.viewControllers.count > 0 ) {
           UIViewController *popController = self.navigationController.viewControllers.lastObject;
           if ([popController isKindOfClass:[ConfMessageViewController class]]) {
               popController.hidesBottomBarWhenPushed = NO;
           }
       }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)leftNavBtn {
    NSLog(@"点击了点击会议的按钮！！！！");
    // 跳转到安排会议界面 这里是编辑会议
    if (self.confMess.isLive) {
         // 点击安排直播
        SIMNewLiveViewController *liveArangeVC = [[SIMNewLiveViewController alloc] init];
        liveArangeVC.navigationItem.title = SIMLocalizedString(@"MMessEditLiveTitle", nil);
        liveArangeVC.arrangeConf = self.arrangeConf;
        liveArangeVC.cidStr = self.confMess.cid;// 因为信息界面的字典没有会议号 所以将会议列表的对应会议号 单独传值给下一页编辑 用来修改之后用
        liveArangeVC.arrangeConf.isPast = NO;// 区分是不是历史会议进入的
        liveArangeVC.arrangeConf.isLive = self.confMess.isLive;
        [self.navigationController pushViewController:liveArangeVC animated:YES];
    }else {
        // 点击安排会议 这里是编辑会议
        SIMArrangeDetailViewController *arrangeVC = [[SIMArrangeDetailViewController alloc] init];
        arrangeVC.navigationItem.title = SIMLocalizedString(@"MMessEditConfTitle", nil);
        arrangeVC.arrangeConf = self.arrangeConf;
        arrangeVC.cidStr = self.confMess.cid;// 因为信息界面的字典没有会议号 所以将会议列表的对应会议号 单独传值给下一页编辑 用来修改之后用
        arrangeVC.arrangeConf.isPast = NO;// 区分是不是历史会议进入的
        arrangeVC.arrangeConf.isLive = self.confMess.isLive;
        [self.navigationController pushViewController:arrangeVC animated:YES];
    }
}
- (void)setUpCells
{
//|| [self.confMess.live_status intValue] == 5
    if (![self.confMess.repeat isEqualToString:@"n"]) {
        NSString *dateStr = [NSString dateTranformTimeStrFromTimeStr:self.confMess.startTime withFromformat:@"yyyy-MM-dd HH:mm:ss" withToformat:@"HH:mm"];
        NSString *repeatStr = [NSString transTheRepeatType:self.confMess.repeat];
        _timeCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"MMessEditTime", nil) prompt:[NSString stringWithFormat:@"%@ %@",repeatStr,dateStr]];
        
    }else {
//        [self dateTransFormmate];
        NSDate *inputDate = [NSString dateTranformDateFromTimeStr:self.confMess.startTime withformat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *dateHour = [NSString dateTranformDayTimeStrFromTimeStr:inputDate];
        
        _timeCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"MMessEditTime", nil) prompt:dateHour];
    }
    _timeCell.accessoryType = UITableViewCellAccessoryNone;
    
    _subjectCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"MMessSupportName", nil) prompt:self.confMess.name];// 待选择作为变量
    _subjectCell.accessoryType = UITableViewCellAccessoryNone;
    
    
    if (self.teachIDStr != nil && [self.teachorConfStr isEqualToString:@"teaching"]) {
        _confIDCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"MMessSupportID_class", nil) prompt:[NSString transTheConfIDToTheThreeApart:self.confMess.cid]];
        _confIDCell.accessoryType = UITableViewCellAccessoryNone;
        
        NSString *timeString = [NSString dateTimeInervalToEndFromStart:self.confMess.startTime withEnd:self.confMess.stopTime];
        _confTimeCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:[NSString stringWithFormat:@"%@",SIMLocalizedString(@"MMessTimeLength_class", nil)] prompt:timeString];
        
        _confTimeCell.accessoryType = UITableViewCellAccessoryNone;
        _explainCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:[NSString stringWithFormat:@"%@",SIMLocalizedString(@"MMessTimeExplain_class", nil)] expalinPrompt:self.confMess.detail];
    }else {
        _confIDCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"MMessSupportID", nil) prompt:[NSString transTheConfIDToTheThreeApart:self.confMess.cid]];
        _confIDCell.accessoryType = UITableViewCellAccessoryNone;
        
        NSString *timeString = [NSString dateTimeInervalToEndFromStart:self.confMess.startTime withEnd:self.confMess.stopTime];
        _confTimeCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:[NSString stringWithFormat:@"%@",SIMLocalizedString(@"MMessTimeLength", nil)] prompt:timeString];
        
        _confTimeCell.accessoryType = UITableViewCellAccessoryNone;
        _explainCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:[NSString stringWithFormat:@"%@",SIMLocalizedString(@"MMessTimeExplain", nil)] expalinPrompt:self.confMess.detail];
    }
    
    _cells = @[@[_timeCell,_subjectCell,_confIDCell,_confTimeCell],@[_explainCell]];
//    [self.tableView reloadData];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return UITableViewAutomaticDimension;
    }else {
        return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else {
        return 320;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }else {
        return CGFLOAT_MIN;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cells[section].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cells[indexPath.section][indexPath.row];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section==1)
    {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 200)];
        footerView.backgroundColor = [UIColor clearColor];
        _start = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([self.signType isEqualToString:@"3"]) {
            // 营销客服 3
            [_start setTitle:[NSString stringWithFormat:@"%@%@",SIMLocalizedString(@"SConfSMessStartTheChar", nil),firstStr] forState:UIControlStateNormal];
        }else if ([self.signType isEqualToString:@"2"]) {
            // 视频客服 2
            [_start setTitle:[NSString stringWithFormat:@"%@%@",SIMLocalizedString(@"MMessTimeStart", nil),firstStr] forState:UIControlStateNormal];
        }else {
            if (self.teachIDStr != nil && [self.teachorConfStr isEqualToString:@"teaching"]) {
                [_start setTitle:[NSString stringWithFormat:@"%@",SIMLocalizedString(@"MMessTimeStart_class", nil)] forState:UIControlStateNormal];
            }else {
                [_start setTitle:[NSString stringWithFormat:@"%@",SIMLocalizedString(@"MMessTimeStart", nil)] forState:UIControlStateNormal];
            }
        }
        
        _start.titleLabel.font = FontRegularName(17);

        // 判断开始会议按钮是否可用
//        if (self.btnEnabel == YES) {
            [_start setTitleColor:BlueButtonColor forState:UIControlStateNormal];
            _start.layer.borderColor = ZJYColorHex(@"#e4e4ec").CGColor;
            _start.enabled = YES;
//        }else {
//            [_start setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            _start.layer.borderColor = [UIColor lightGrayColor].CGColor;
//            _start.enabled = NO;
//        }
        _start.backgroundColor = [UIColor whiteColor];
        [_start setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_start setBackgroundImage:[UIImage imageWithColor:GrayPromptTextColor] forState:UIControlStateHighlighted];
        _start.layer.borderWidth = 1;
        
        _start.layer.cornerRadius = 11;
        _start.layer.masksToBounds = YES;
        _start.tag = MyButtonTypeJoin;
        [footerView addSubview:self.start];
        [_start addTarget:self action:@selector(startBtn:) forControlEvents:UIControlEventTouchUpInside];
        
            
        _inAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.confMess.isLive) {
            [_inAdd setTitle:SIMLocalizedString(@"MMessShareLive", nil) forState:UIControlStateNormal];
        }else {
            if ([self.signType isEqualToString:@"3"]) {
                // 营销客服 3
                [_inAdd setTitle:SIMLocalizedString(@"SConfSMessShareWEIPage", nil) forState:UIControlStateNormal];
            }else if ([self.signType isEqualToString:@"2"]) {
                // 视频客服 2
                [_inAdd setTitle:SIMLocalizedString(@"SConfSMessShareWEIPage", nil) forState:UIControlStateNormal];
            }else {
                [_inAdd setTitle:SIMLocalizedString(@"MMessSupportInAdd", nil) forState:UIControlStateNormal];
            }
            
        }
        _inAdd.backgroundColor = [UIColor whiteColor];
        _inAdd.titleLabel.font = FontRegularName(17);
        _inAdd.layer.borderColor = ZJYColorHex(@"#e4e4ec").CGColor;
        _inAdd.enabled = YES;
        [_inAdd setTitleColor:BlueButtonColor forState:UIControlStateNormal];
        [_inAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_inAdd setBackgroundImage:[UIImage imageWithColor:GrayPromptTextColor] forState:UIControlStateHighlighted];
        _inAdd.layer.borderWidth = 1;
        _inAdd.layer.cornerRadius = 11;
        _inAdd.layer.masksToBounds = YES;
        _inAdd.tag = MyButtonTypeInvite;
        [footerView addSubview:self.inAdd];
        [_inAdd addTarget:self action:@selector(startBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _QRcodeShare = [UIButton buttonWithType:UIButtonTypeCustom];
        [_QRcodeShare setTitle:SIMLocalizedString(@"ErweimaSendTitle", nil) forState:UIControlStateNormal];\
        _QRcodeShare.backgroundColor = [UIColor whiteColor];
        _QRcodeShare.titleLabel.font = FontRegularName(17);
        _QRcodeShare.layer.borderColor = ZJYColorHex(@"#e4e4ec").CGColor;
        _QRcodeShare.enabled = YES;
        [_QRcodeShare setTitleColor:BlueButtonColor forState:UIControlStateNormal];
        [_QRcodeShare setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_QRcodeShare setBackgroundImage:[UIImage imageWithColor:GrayPromptTextColor] forState:UIControlStateHighlighted];
        _QRcodeShare.layer.borderWidth = 1;
        _QRcodeShare.layer.cornerRadius = 11;
        _QRcodeShare.layer.masksToBounds = YES;
        _QRcodeShare.tag = MyButtonTypeQRShare;
        [footerView addSubview:self.QRcodeShare];
        [_QRcodeShare addTarget:self action:@selector(startBtn:) forControlEvents:UIControlEventTouchUpInside];
    
        _lookAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lookAdd setTitle:SIMLocalizedString(@"PLivingTileLookTheLive", nil) forState:UIControlStateNormal];
        _lookAdd.backgroundColor = [UIColor whiteColor];
        _lookAdd.titleLabel.font = FontRegularName(17);
        [_lookAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_lookAdd setBackgroundImage:[UIImage imageWithColor:GrayPromptTextColor] forState:UIControlStateHighlighted];
        _lookAdd.layer.borderWidth = 1;
        _lookAdd.layer.cornerRadius = 11;
        _lookAdd.layer.masksToBounds = YES;
        _lookAdd.tag = MyButtonTypeLook;
        [footerView addSubview:self.lookAdd];
        [_lookAdd addTarget:self action:@selector(startBtn:) forControlEvents:UIControlEventTouchUpInside];
        _lookAdd.layer.borderColor = ZJYColorHex(@"#e4e4ec").CGColor;
        _lookAdd.enabled = YES;
        [_lookAdd setTitleColor:BlueButtonColor forState:UIControlStateNormal];
        
        _deleCof = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleCof.backgroundColor = [UIColor whiteColor];
        [_deleCof setTitle:[NSString stringWithFormat:@"%@%@",SIMLocalizedString(@"MMessDelegate", nil),firstStr] forState:UIControlStateNormal];
        _deleCof.titleLabel.font = FontRegularName(17);
        _deleCof.layer.borderWidth = 1;
        _deleCof.layer.borderColor = ZJYColorHex(@"#e4e4ec").CGColor;
//        [_deleCof setBackgroundColor:RedButtonColor];
        [_deleCof setBackgroundImage:[UIImage imageWithColor:GrayPromptTextColor] forState:UIControlStateHighlighted];
        [_deleCof setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_deleCof setTitleColor:RedButtonColor forState:UIControlStateNormal];
        _deleCof.layer.cornerRadius = 11;
        _deleCof.layer.masksToBounds = YES;
        _deleCof.tag = MyButtonTypeDelete;
        [footerView addSubview:self.deleCof];
        [_deleCof addTarget:self action:@selector(startBtn:) forControlEvents:UIControlEventTouchUpInside];
        

        [_start mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(25);
            make.height.mas_equalTo(44);
        }];
        [_inAdd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(_start.mas_bottom).offset(15);
            make.height.mas_equalTo(44);
        }];
        [_QRcodeShare mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(_inAdd.mas_bottom).offset(15);
            make.height.mas_equalTo(44);
        }];
        
        [_lookAdd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(_QRcodeShare.mas_bottom).offset(15);
            make.height.mas_equalTo(44);
        }];
        
        [_deleCof mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(_lookAdd.mas_bottom).offset(15);
            make.height.mas_equalTo(44);
        }];
        
        
        return footerView;
    }else {
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)startBtn:(UIButton*)sender {
    if (sender.tag == MyButtonTypeJoin) {
//        if () {
//            WebDetailController *livVC = [[WebDetailController alloc] init];
////            livVC.keepFit = self.keepFit;
//            [self.navigationController pushViewController:livVC animated:YES];
//        }else {
//            if (![SIMEnterConfTool  avauthorizationStatusWithViewController:self]) return;
        
//            if (_confMess.normalPassword.length) {
//                [SIMEnterConfTool addAlertControllerWithCid:_confMess.cid uid:self.currentUser.uid name:self.currentUser.nickname token:[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"] psw:_confMess.normalPassword signID:self.signType viewController:self];
//                [SIMNewEnterConfTool enterWithAlertControllerWithCid:_confMess.cid psw:_confMess.normalPassword confType:[self.signType integerValue] isJoined:NO viewController:self];
//            }else {
//                [SIMEnterConfTool transferVideoMethodWithUid:self.currentUser.uid name:self.currentUser.nickname token:[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"] confID:_confMess.cid psw:_confMess.normalPassword signID:self.signType viewController:self];
                [SIMNewEnterConfTool enterTheMineConfWithCid:_confMess.cid psw:@"" confType:[self.signType integerValue] isJoined:NO viewController:self];
//            }
//        }
        
    }else if (sender.tag == MyButtonTypeInvite) {
        // 邀请联系人 发送短信等
        // 会议 1 默认
        if (self.confMess.isLive) {
            // 直播
            NSString *firstliveStr = SIMLocalizedString(@"MMessEditLive", nil);
            NSString *shareliveStr = SIMLocalizedString(@"MMessEditLive", nil);
            NSString *shareurlLive;
            if (liveAdressPort.length > 0) {
                shareurlLive = [NSString stringWithFormat:@"%@:%@?cid=%@",liveAdressHost,liveAdressPort,_confMessID];
            }else {
                shareurlLive = [NSString stringWithFormat:@"%@?cid=%@",liveAdressHost,_confMessID];
            }
            // 邀请联系人 直播地址发送短信等
            [self addActionSheetWithShareStr:shareliveStr nameStr:firstliveStr urlStr:shareurlLive];
        }else {
//            NSString *title = SIMLocalizedString(@"MMessEditConf", nil);
//            NSString *fistStr = [[NSString alloc] initWithString:title];
            NSString * sharedStr = [NSString stringWithFormat:@"%@%@",SIMLocalizedString(@"MMessEditConfOne", nil),firstStr];
            
//            NSString * urlsharedStr = [NSString stringWithFormat:@"%@/admin/conference/joinmeeting?server=%@&port=%@&name=zc_test&token=11111&cid=%@&cp=%@&sm=web&anon=1&role=&ref=%@&data=&timetap=%@",urlString,webHostStr,webPortStr,_confMess.cid,_confMess.normalPassword,[NSString stringWithFormat:@"iOS%@",app_Version],[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]];
//            NSString * urlsharedStr = [NSString stringWithFormat:@"%@&ref=%@&timetap=%@",_confMess.roomUrl,[NSString stringWithFormat:@"iOS%@",getApp_Version],[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]];
            NSString * urlsharedStr = _confMess.roomUrl;
            [self addActionSheetWithShareStr:sharedStr nameStr:firstStr urlStr:urlsharedStr];
        }
        
    }else if (sender.tag == MyButtonTypeQRShare) {
        // 二维码保存
        SIMConfIDQRCodeViewController *qrcodeVC = [[SIMConfIDQRCodeViewController alloc] init];
        qrcodeVC.confURL = _confMess.roomUrl;
        [self.navigationController pushViewController:qrcodeVC animated:YES];
    }else if (sender.tag == MyButtonTypeDelete) {
        // 确定删除按钮弹窗
        [self addAlertController];
    }else if (sender.tag == MyButtonTypeShare) {
        if (_shareArr.count == 0) {
            [MBProgressHUD cc_showText:@"暂无邀请功能，请联系管理开启配置"];
            return ;
        }
        NSString *firstliveStr = SIMLocalizedString(@"MMessEditLive", nil);
        NSString *shareliveStr = SIMLocalizedString(@"MMessEditLive", nil);
        NSString *shareurlLive;
        if (liveAdressPort.length > 0) {
            shareurlLive = [NSString stringWithFormat:@"%@:%@?cid=%@",liveAdressHost,liveAdressPort,_confMessID];
        }else {
            shareurlLive = [NSString stringWithFormat:@"%@?cid=%@",liveAdressHost,_confMessID];
        }
        // 邀请联系人 直播地址发送短信等
        [self addActionSheetWithShareStr:shareliveStr nameStr:firstliveStr urlStr:shareurlLive];
    }else if (sender.tag == MyButtonTypeLook) {
        // 网页的观看直播地址
//        NSString *shareurlLive;
//        if (liveAdressPort.length > 0) {
//            shareurlLive = [NSString stringWithFormat:@"%@:%@?cid=%@",liveAdressHost,liveAdressPort,_confMessID];
//        }else {
//            shareurlLive = [NSString stringWithFormat:@"%@?cid=%@",liveAdressHost,_confMessID];
//        }
//        SIMTempCompanyViewController *tempVC = [[SIMTempCompanyViewController alloc] init];
//        tempVC.navigationItem.title = @"观看直播";
//        NSString * urlsharedStr = _confMess.roomUrl;
//        tempVC.webStr = urlsharedStr;
//        [self.navigationController pushViewController:tempVC animated:YES];
        
        
        NSString * sharedStr = [NSString stringWithFormat:@"%@%@",SIMLocalizedString(@"MMessEditConfOne", nil),firstStr];
        NSString * urlsharedStr = _confMess.roomUrl;
        [self addActionSheetWithShareStr:sharedStr nameStr:firstStr urlStr:urlsharedStr];
    }
}



#pragma mark -- UIAlertViewDelegate
- (void)addActionSheetWithShareStr:(NSString *)shareStr nameStr:(NSString *)namestr urlStr:(NSString *)urlstr{
//    NSString *shareContent = [NSString stringWithFormat:@"%@ %@%@ \n %@ %@ \n %@ %@",self.currentUser.nickname,SIMLocalizedString(@"MMessageWechatTitle", nil),shareStr,SIMLocalizedString(@"MMessageWechatSubject", nil),_confMess.name,SIMLocalizedString(@"MMessageWechatContant", nil),[NSURL URLWithString:urlstr]];
    NSString *shareContent;
    NSString *wechatContent;
    if (self.teachIDStr != nil && [self.teachorConfStr isEqualToString:@"teaching"]) {
        shareContent = [NSString stringWithFormat:SIMLocalizedString(@"ShareConfInviteOnePart_class", nil),self.currentUser.nickname,self.confMess.name,self.confMess.name,self.confMess.startTime,self.currentUser.nickname,urlstr];
        wechatContent = [NSString stringWithFormat:SIMLocalizedString(@"ShareConfInviteOnePart_classWechat", nil),self.confMess.name,self.confMess.startTime,self.currentUser.nickname,urlstr];
    }else {
        shareContent = [NSString stringWithFormat:SIMLocalizedString(@"ShareConfInviteOnePart", nil),self.currentUser.nickname,self.confMess.name,self.confMess.name,self.confMess.startTime,self.currentUser.nickname,urlstr];
        wechatContent = [NSString stringWithFormat:SIMLocalizedString(@"ShareConfInviteOnePartWechat", nil),self.confMess.name,self.confMess.startTime,self.currentUser.nickname,urlstr];
    }
    NSLog(@"shareContentshareContent %@",shareContent);
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"WeChatSend", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 直接去微信分享
//        [self shareToWeChatWithShareStr:shareStr nameStr:namestr urlStr:urlstr];
//        NSString *messStr = [NSString stringWithFormat:@"%@ %@ %@ ",SIMLocalizedString(@"MMessageWechatSubject", nil),_confMess.name,SIMLocalizedString(@"MMessageWechatContant", nil)];
        
        NSString *titleStr = [NSString stringWithFormat:@"\n%@ %@ %@",self.currentUser.nickname,SIMLocalizedString(@"MMessageWechatTitle", nil),shareStr];
        
        [[SIMShareTool shareInstace] shareToWeChatWithShareStr:wechatContent shareImage:@"share_meeting" urlStr:urlstr ShareTitle:titleStr];
    
    }];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"MessageSend", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self showMessageViewbody:shareContent viewController:self];
//        [[SIMShareTool shareInstace] showMessageViewbody:shareContent viewController:self];// 调用发送短信
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
    [alertC addAction:action4];
    alertC.popoverPresentationController.sourceView = footerView;
    alertC.popoverPresentationController.sourceRect = _inAdd.frame;
    alertC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    [self presentViewController:alertC animated:YES completion:nil];
}


#pragma mark -- UIAlertController
- (void)addAlertController {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@%@",SIMLocalizedString(@"MMessDelegate", nil),firstStr] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deletConfRequest];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [action3 setValue:RedButtonColor forKey:@"_titleTextColor"];
    [alertC addAction:action];
    [alertC addAction:action3];
    alertC.popoverPresentationController.sourceView = footerView;
    alertC.popoverPresentationController.sourceRect = _deleCof.frame;
    alertC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    [self presentViewController:alertC animated:YES completion:nil];
}
// 删除会议
- (void)deletConfRequest {
    [MBProgressHUD cc_showLoading:nil];
    if (self.confMess.isLive) {
        // 删除直播
        [MainNetworkRequest deleteLiveRequestParams:@{} cid:self.confMess.cid success:^(id success) {
            // 成功
            if ([success[@"status"] isEqualToString:@"ok"]) {
                [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
                //            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"changeMeeting"];
                
                // 如果删除了直播那么 发送首页刷新的通知
                [[NSNotificationCenter defaultCenter] postNotificationName:EditLiveSuccess object:nil];
                // 发送公开会议刷新通知
//                [[NSNotificationCenter defaultCenter] postNotificationName:NewLiveSuccess object:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }else {
                [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_DELEGATE_fail", nil)];
            }
        } failure:^(id failure) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        }];
    }else {
        // 删除会议
        [MainNetworkRequest deleteConfRequestParams:@{@"cid":self.confMess.cid} success:^(id success) {
            // 成功
            if ([success[@"code"] integerValue] == successCodeOK) {
                [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
                
                // 如果删除了会议那么 发送首页刷新的通知
                [[NSNotificationCenter defaultCenter] postNotificationName:EditConfSuccess object:nil];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else {
                [MBProgressHUD cc_showText:success[@"msg"]];
            }
        } failure:^(id failure) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        }];
    }
}

// 本页面 -- 会议详情 以及下一界面详情
- (void)requestEditData {
    if (self.confMess.isLive) {
        // 直播会议详情
        [MainNetworkRequest detailNewLiveRequestParams:nil cid:self.confMess.cid success:^(id success) {
            
            if ([success[@"status"] isEqualToString:@"ok"]) {
                _arrangeConf = [[ArrangeConfModel alloc] initWithDictionary:success];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self editBtnCan:YES titleColor:BlueButtonColor];
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self editBtnCan:NO titleColor:GrayPromptTextColor];
                });
            }
            
        } failure:^(id failure) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self editBtnCan:NO titleColor:GrayPromptTextColor];
            });
        }];
    }else {
        [MainNetworkRequest confDetailRequestParams:@{@"cid":self.confMess.cid,@"advice":@"all"} success:^(id success) {
          
            NSLog(@"succenewsssuccess %@",success);
            if ([success[@"code"] integerValue] == successCodeOK) {
                _arrangeConf = [[ArrangeConfModel alloc] initWithDictionary:success[@"data"]];
                dispatch_async(dispatch_get_main_queue(), ^{
        [self editBtnCan:YES titleColor:BlueButtonColor];
                    
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self editBtnCan:NO titleColor:GrayPromptTextColor];
                });
            }
        } failure:^(id failure) {
            [self editBtnCan:NO titleColor:GrayPromptTextColor];
        }];
    }
}
- (void)editBtnCan:(BOOL)isEdit titleColor:(UIColor *)titleColor{
    edit.enabled = isEdit;
    [edit setTitleColor:titleColor forState:UIControlStateNormal];
}



@end
