//
//  ConversationController.m
//  UIKit
//
//  Created by kennethmiao on 2018/9/14.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "TConversationController.h"
#import "TConversationCell.h"
#import "TPopView.h"
#import "TPopCell.h"
#import "THeader.h"
#import "TUIKit.h"
#import "TNaviBarIndicatorView.h"
#import "TLocalStorage.h"
#import "SIMMessNotifListViewController.h"
#import "SIMMessNotiModel.h"
#import "SIMMessNotifListTableViewCell.h"

@import ImSDK;

@interface TConversationController () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) TNaviBarIndicatorView *titleView;
@property (nonatomic, strong) NSMutableArray *messlistArr;
@end

@implementation TConversationController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _convFilter = TGroupMessage | TC2CMessage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _messlistArr = [NSMutableArray array];
    [self setupNavigation];
    [self setupViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRefreshConversations:) name:TUIKitNotification_TIMRefreshListener object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkChanged:) name:TUIKitNotification_TIMConnListener object:nil];
    if ([self.cloudVersion.find boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
        [self requestData];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupNavigation
{
    _titleView = [[TNaviBarIndicatorView alloc] init];
    [_titleView setTitle:SIMLocalizedString(@"IMNewChatTitle", nil)];
    self.navigationItem.titleView = _titleView;
    self.parentViewController.navigationItem.titleView = _titleView;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}


- (void)setupViews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH - TabbarH)];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = TConversationController_Background_Color;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    if ([self.cloudVersion.find boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
        MJRefreshNormalHeader *refreshHead = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
        refreshHead.lastUpdatedTimeLabel.hidden = YES;
        self.tableView.mj_header = refreshHead;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateConversations];
}

- (void)updateConversations
{
    _data = [NSMutableArray array];
    TIMManager *manager = [TIMManager sharedInstance];
    NSArray *convs = [manager getConversationList];
    for (TIMConversation *conv in convs) {
        if([conv getType] == TIM_SYSTEM){
            continue;
        }
        if ([conv getType] == TIM_C2C) {
            if (!(self.convFilter & TC2CMessage)) {
                continue;
            }
        }
        if ([conv getType] == TIM_GROUP) {
            if (!(self.convFilter & TGroupMessage)) {
                continue;
            }
        }

//        [conv getMessage:[[TUIKit sharedInstance] getConfig].msgCountPerRequest last:nil succ:nil fail:nil];
        
        TIMMessage *msg = [conv getLastMsg];
        TConversationCellData *data = [[TConversationCellData alloc] init];
        data.unRead = [conv getUnReadMessageNum];
        data.time = [self getDateDisplayString:msg.timestamp];
        
        data.subTitle = [self getLastDisplayString:conv];
        
        data.convId = [conv getReceiver];
        data.convType = (TConvType)[conv getType];
        
        if([conv getType] == TIM_C2C){
            [[TIMFriendshipManager sharedInstance] getUsersProfile:@[data.convId] forceUpdate:NO succ:^(NSArray * arr) {
                for (TIMUserProfile * profile in arr) {
                    NSLog(@"headfaceURLconversation %@ %@",profile.faceURL,profile.nickname);
                    data.head = profile.faceURL;
                    if (profile.nickname.length <= 0) {
                        data.title = data.convId;
                    }else {
                        data.title = profile.nickname;
                    }
                }
                [_tableView reloadData];
            }fail:^(int code, NSString * err) {
                data.head = TUIKitResource(@"default_head");
                data.title = data.convId;
                NSLog(@"腾讯云IM GetFriendsProfile fail: code=%d err=%@", code, err);
                [_tableView reloadData];
            }];
            
        }else if([conv getType] == TIM_GROUP){
            data.head = TUIKitResource(@"default_group");
        }
        if(data.convType == TConv_Type_C2C){
            
        }
        else if(data.convType == TConv_Type_Group){
            data.title = [conv getGroupName];
        }
        [_data addObject:data];
        [self reorderData];
        
    }
      [_tableView reloadData];
}

- (void)reorderData
{
    NSArray *top = [[TLocalStorage sharedInstance] topConversationList];
    NSEnumerator *enumerator = [top reverseObjectEnumerator];
    NSString *conv;
    while ((conv = [enumerator nextObject])) {
        for (int i = 0; i < _data.count; i++) {
            TConversationCellData *data = _data[i];
            if ([data.convId isEqualToString:conv]) {
                data.isOnTop = YES;
                [_data removeObjectAtIndex:i];
                [_data insertObject:data atIndex:0];
                break;
            }
        }
    }
}

- (void)onRefreshConversations:(NSNotification *)notification
{
    [self updateConversations];
}

- (void)onNetworkChanged:(NSNotification *)notification
{
    TNetStatus status = (TNetStatus)[notification.object intValue];
    switch (status) {
        case TNet_Status_Succ:
            [_titleView setTitle:SIMLocalizedString(@"IMNewChatTitle", nil)];
            [_titleView stopAnimating];
            break;
        case TNet_Status_Connecting:
            [_titleView setTitle:SIMLocalizedString(@"IMNewChatingTitle", nil)];
            [_titleView startAnimating];
            break;
        case TNet_Status_Disconnect:
            [_titleView setTitle:SIMLocalizedString(@"IMNewNoChatTitle", nil)];
            [_titleView stopAnimating];
            break;
        case TNet_Status_ConnFailed:
            [_titleView setTitle:SIMLocalizedString(@"IMNewNoChatTitle", nil)];
            [_titleView stopAnimating];
            break;
            
        default:
            break;
    }
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _messlistArr.count;
    }else {
        return _data.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TConversationCell getSize].height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    }else {
        return YES;
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleNone;
    }else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SIMLocalizedString(@"MMessDelegate", nil);
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {

    }else if (indexPath.section == 1) {
        TConversationCellData *conv = _data[indexPath.row];
        [_data removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        TIMConversationType type = TIM_C2C;
        if(conv.convType == TConv_Type_Group){
            type = TIM_GROUP;
        }
        else if(conv.convType == TConv_Type_C2C){
            type = TIM_C2C;
        }
        [[TIMManager sharedInstance] deleteConversation:type receiver:conv.convId];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        // 通知类和营销类
        SIMMessNotiModel *model = _messlistArr[indexPath.row];
        SIMMessNotifListViewController *messVC = [[SIMMessNotifListViewController alloc] init];
        messVC.title = SIMLocalizedString(@"TabBarMessageTitle", nil);
        messVC.classification_id = [model.classification_id stringValue];
        [self.navigationController pushViewController:messVC animated:YES];
    }else {
        if(_delegate && [_delegate respondsToSelector:@selector(conversationController:didSelectConversation:)]){
            [_delegate conversationController:self didSelectConversation:_data[indexPath.row]];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SIMMessNotifListTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"SIMMessNotifListTableViewCell"];
        if(!cell){
            cell = [[SIMMessNotifListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SIMMessNotifListTableViewCell"];
        }
        SIMMessNotiModel *model = _messlistArr[indexPath.row];
        cell.model = model;
//        static NSString *reuse = @"ClassMineCell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse];
//        }
//
//        NSString *newFaceValue = [NSString stringWithFormat:@"%@%@",kApiBaseUrl,model.image];
//        NSLog(@"newFaceValuenew %@",newFaceValue);
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:newFaceValue]];
//        cell.textLabel.text = model.classification_name;
//        cell.textLabel.font = FontRegularName(16);
//        cell.textLabel.textColor = [UIColor blackColor];
//
//        cell.detailTextLabel.text = model.descriptionStr;
//        cell.detailTextLabel.font = FontRegularName(14);
//        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        return cell;
    }else {
        
        TConversationCell *cell  = [tableView dequeueReusableCellWithIdentifier:TConversationCell_ReuseId];
        if(!cell){
            cell = [[TConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TConversationCell_ReuseId];
        }
        [cell setData:[_data objectAtIndex:indexPath.row]];
        return cell;
    }
    
}
- (void)requestData {
    [MainNetworkRequest messageClassificationRequestParams:nil success:^(id success) {
        NSLog(@"messageClassificationList %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [_messlistArr removeAllObjects];
            for (NSDictionary *dic in success[@"data"]) {
                SIMMessNotiModel *model = [[SIMMessNotiModel alloc] initWithDictionary:dic];
                [_messlistArr addObject:model];
            }
            [_tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}

- (void)setData:(NSMutableArray *)data
{
    _data = data;
    [_tableView reloadData];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

//- (UIModalPresentationStyle)

- (NSString *)getLastDisplayString:(TIMConversation *)conv
{
    NSString *str = @"";
    TIMMessageDraft *draft = [conv getDraft];
    if(draft){
        for (int i = 0; i < draft.elemCount; ++i) {
            TIMElem *elem = [draft getElem:i];
        
            if([elem isKindOfClass:[TIMTextElem class]]){
                TIMTextElem *text = (TIMTextElem *)elem;
                str = [NSString stringWithFormat:@"%@%@",SIMLocalizedString(@"IMConverseListCao", nil), text.text];
                break;
            }
            else{
                continue;
            }
        }
        return str;
    }
    
    TIMMessage *msg = [conv getLastMsg];
    if(msg.status == TIM_MSG_STATUS_LOCAL_REVOKED){
        if(msg.isSelf){
            return @"你撤回了一条消息";
        }
        else{
            return [NSString stringWithFormat:@"\"%@\"撤回了一条消息", msg.sender];
        }
    }
    for (int i = 0; i < msg.elemCount; ++i) {
        TIMElem *elem = [msg getElem:i];
        if([elem isKindOfClass:[TIMTextElem class]]){
            TIMTextElem *text = (TIMTextElem *)elem;
            str = text.text;
            break;
        }
        
        else if([elem isKindOfClass:[TIMCustomElem class]]){
            TIMCustomElem *custom = (TIMCustomElem *)elem;
            NSData *datacustom = custom.data;
            NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:datacustom options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"在线腾讯IM提示 接受到了新的自定义的消息是 %@",dictionary);
            if ([[dictionary objectForKey:@"type"] isEqualToString:@"mainCall"]) {
                // 主叫方发出视频通话邀请
                str =  msg.isSelf?@"您发送了视频通话邀请":@"您接收了一条视频通话邀请";
            }else if ([[dictionary objectForKey:@"type"] isEqualToString:@"mainCancel"]) {
                // 主叫方取消视频通话
                str = msg.isSelf?@"您取消视频通话":@"对方取消视频通话";
                
            }else if ([[dictionary objectForKey:@"type"] isEqualToString:@"calledCall"]) {
                // 被叫方接受了视频通话邀请 并且进会
                str = msg.isSelf?@"您接收了视频通话":@"对方接受了视频通话";
            }else if ([[dictionary objectForKey:@"type"] isEqualToString:@"calledCancel"]) {
                if ([[dictionary objectForKey:@"reason"] intValue] == 1) {
                    // 对方忙 或者您正忙
                    str = msg.isSelf?@"您正忙拒绝了视频通话":@"对方忙，请稍后再联系";
                }else {
                    // 被叫方取消视频通话邀请 对方取消了视频通话
                    str = msg.isSelf?@"您拒绝了视频通话":@"对方拒绝了视频通话";
                }
                
            }
            
            break;
        }
        else if([elem isKindOfClass:[TIMImageElem class]]){
            str = SIMLocalizedString(@"IMConverseListPic", nil);
            break;
        }
        else if([elem isKindOfClass:[TIMSoundElem class]]){
            str = SIMLocalizedString(@"IMConverseListVio", nil);
            break;
        }
        else if([elem isKindOfClass:[TIMVideoElem class]]){
            str = SIMLocalizedString(@"IMConverseListVid", nil);
            break;
        }
        else if([elem isKindOfClass:[TIMFaceElem class]]){
            str = SIMLocalizedString(@"IMConverseListEmo", nil);
            break;
        }
        else if([elem isKindOfClass:[TIMFileElem class]]){
            str = SIMLocalizedString(@"IMConverseListDoc", nil);
            break;
        }
        else if([elem isKindOfClass:[TIMLocationElem class]]){
            str = SIMLocalizedString(@"IMConverseListLoc", nil);
            break;
        }
        else if([elem isKindOfClass:[TIMGroupTipsElem class]]){
            TIMGroupTipsElem *tips = (TIMGroupTipsElem *)elem;
            switch (tips.type) {
                case TIM_GROUP_TIPS_TYPE_INFO_CHANGE:
                {
                    for (TIMGroupTipsElemGroupInfo *info in tips.groupChangeList) {
                        switch (info.type) {
                            case TIM_GROUP_INFO_CHANGE_GROUP_NAME:
                            {
                                str = [NSString stringWithFormat:@"\"%@\"修改群名为\"%@\"", tips.opUser, info.value];
                            }
                                break;
                            case TIM_GROUP_INFO_CHANGE_GROUP_INTRODUCTION:
                            {
                                str = [NSString stringWithFormat:@"\"%@\"修改群简介为\"%@\"", tips.opUser, info.value];
                            }
                                break;
                            case TIM_GROUP_INFO_CHANGE_GROUP_NOTIFICATION:
                            {
                                str = [NSString stringWithFormat:@"\"%@\"修改群公告为\"%@\"", tips.opUser, info.value];
                            }
                                break;
                            case TIM_GROUP_INFO_CHANGE_GROUP_OWNER:
                            {
                                str = [NSString stringWithFormat:@"\"%@\"修改群主为\"%@\"", tips.opUser, info.value];
                            }
                                break;
                            default:
                                break;
                        }
                    }
                }
                    break;
                case TIM_GROUP_TIPS_TYPE_KICKED:
                {
                    NSString *users = [tips.userList componentsJoinedByString:@"、"];
                    str = [NSString stringWithFormat:@"\"%@\"将\"%@\"剔出群组", tips.opUser, users];
                }
                    break;
                case TIM_GROUP_TIPS_TYPE_INVITE:
                {
                    NSString *users = [tips.userList componentsJoinedByString:@"、"];
                    str = [NSString stringWithFormat:@"\"%@\"邀请\"%@\"加入群组", tips.opUser, users];
                }
                    break;
                default:
                    break;
            }
        }
        else{
            continue;
        }
    }
    return str;
}

- (NSString *)getDateDisplayString:(NSDate *)date
{
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:date];
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc ] init ];
    
    NSDateComponents *comp =  [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy/MM/dd";
    }
    else{
        
        if (nowCmps.day==myCmps.day) {
            dateFmt.AMSymbol = SIMLocalizedString(@"IMDateAM", nil);
            dateFmt.PMSymbol = SIMLocalizedString(@"IMDatePM", nil);
            dateFmt.dateFormat = @"aaa hh:mm";
        } else if((nowCmps.day-myCmps.day)==1) {
            dateFmt.AMSymbol = SIMLocalizedString(@"IMDateAM", nil);
            dateFmt.PMSymbol = SIMLocalizedString(@"IMDatePM", nil);
            dateFmt.dateFormat = SIMLocalizedString(@"TimeYesterdayAndTimeList", nil);
        } else {
            if ((nowCmps.day-myCmps.day) <=7) {
                switch (comp.weekday) {
                    case 1:
                        dateFmt.dateFormat = SIMLocalizedString(@"IMDateSun", nil);
                        break;
                    case 2:
                        dateFmt.dateFormat = SIMLocalizedString(@"IMDateMon", nil);
                        break;
                    case 3:
                        dateFmt.dateFormat = SIMLocalizedString(@"IMDateTus", nil);
                        break;
                    case 4:
                        dateFmt.dateFormat = SIMLocalizedString(@"IMDateWen", nil);
                        break;
                    case 5:
                        dateFmt.dateFormat = SIMLocalizedString(@"IMDateThur", nil);
                        break;
                    case 6:
                        dateFmt.dateFormat = SIMLocalizedString(@"IMDateFri", nil);
                        break;
                    case 7:
                        dateFmt.dateFormat = SIMLocalizedString(@"IMDateSat", nil);
                        break;
                    default:
                        break;
                }
            }else {
                dateFmt.dateFormat = @"yyyy/MM/dd";
            }
        }
    }
    return [dateFmt stringFromDate:date];
}

@end

