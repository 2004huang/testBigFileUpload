//
//  SIMNewIMHelper.m
//  Kaihuibao
//
//  Created by mac126 on 2019/6/3.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMNewIMHelper.h"

static SIMNewIMHelper *_deviceDelegateHelper = nil;
static BOOL isCalled;
static NSString *isCancel;

static NSDictionary *enterDic;
static TIMCustomElem *all_custom_elem;

@implementation SIMNewIMHelper
+ (instancetype)shareInstance{
    if (_deviceDelegateHelper) {
        return _deviceDelegateHelper;
    }
    return [[SIMNewIMHelper alloc] init];
}
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceDelegateHelper = [super init];
//         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTheOffline) name:@"newRefreshOffline" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(revokeThemessage:) name:@"isrevokelistener" object:nil];
    });
    return _deviceDelegateHelper;
}

//+(instancetype) shareInstance
//{
//    static dispatch_once_t onceToken ;
//    dispatch_once(&onceToken, ^{
//        _deviceDelegateHelper = [[super allocWithZone:NULL] init] ;
//
//    });
//    return _deviceDelegateHelper ;
//}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        _deviceDelegateHelper = [super allocWithZone:zone];
//    });
    return _deviceDelegateHelper;
}

-(id)copyWithZone:(NSZone *)zone{
    return _deviceDelegateHelper;
}


- (void)addMessageListener {
    [[TIMManager sharedInstance] addMessageListener:self];
}

//+(id) allocWithZone:(struct _NSZone *)zone
//{
//    return [SIMNewIMHelper shareInstance] ;
//}
//
//-(id) copyWithZone:(struct _NSZone *)zone
//{
//    return [SIMNewIMHelper shareInstance];
//}
/**
 @brief 接收即时消息代理函数
 @param msgs 接收的消息
 */
//- (void)revokeThemessage:(NSNotification *)notification {
//
//    TIMMessageLocator *locator = notification.object;
//    NSLog(@"撤销了啥 %@",locator);
//
//    for (uiMsg in _uiMsgs) {
//        TIMMessage *imMsg = uiMsg.custom;
//        if(imMsg){
//            if([imMsg respondsToLocator:locator]){
//
//                break;
//            }
//        }
//    }
//}
//- (void)onTheOffline {
//    isOffline = YES;
//    NSLog(@"腾讯IMlixiande离线的消息是 %d %d",isOffline,isCall);
//    if (isOffline == YES && isCall == YES) {
//        NSLog(@"腾讯IM接受到了离线fff的消息是 %@",all_custom_elem);
//        NSData *data = all_custom_elem.data;
//        NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:PushTheCalledPage object:nil userInfo:dictionary];
//    }
//}
- (void)onNewMessage:(NSArray*)msgs {
//    NSLog(@"腾讯IM 接受到了新的消息 %@ isCall的消息 %d",msgs,isCall);
    for (int i = 0 ; i<msgs.count ; i++) {
        TIMMessage * message = msgs[i];
        NSString *fromStr = [message sender];
        NSDate *timeSmp = [message timestamp];
        NSString *timeStr = [NSString dateTranformTimeStrFromDate:timeSmp withformat:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeInterval messageTimeSmp = [timeSmp timeIntervalSince1970];
        NSLog(@"messageTimeSmpmessageTimeSmp %f",messageTimeSmp);
//        CGFloat loginTimeSmp = [[NSUserDefaults standardUserDefaults] floatForKey:@"TIMloginTime"];
//        NSLog(@"loginTimeSmploginTimeSmp %f",loginTimeSmp);
//        if ((loginTimeSmp - messageTimeSmp) < 0) {
//            // 在线收到的
//            NSLog(@"在线收到的");
//            int cnt = [message elemCount];
//            for (int i = 0; i < cnt; i++) {
//                TIMElem * elem = [message getElem:i];
//                NSLog(@"TIMElemTIMElemTIMElem %@ %@",elem,timeStr);
//                if ([elem isKindOfClass:[TIMCustomElem class]]) {
//                    // 收到消息的服务器时间 和当前时间
//                    NSDate *date1 = timeSmp;
//                    NSDate *date2 = [NSDate date];
//                    // 创建日历
//                    NSCalendar *calendar = [NSCalendar currentCalendar];
//                    NSCalendarUnit type =  NSCalendarUnitSecond;
//                    // 利用日历对象比较两个时间的差值
//                    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
//                    NSLog(@"两个时间相差 %ld 秒",cmps.second);
//                    if (cmps.second > 60*1) {
//                        // 如果超过1分钟 那么不多这个消息进行任何处理
//
//                    }else {
//
//                        TIMCustomElem *custom_elem = (TIMCustomElem * )elem;
//                        NSLog(@"在线腾讯IM接受到了新的自定义的消息是 %@",custom_elem);
//                        NSData *data = custom_elem.data;
//                        NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//
//                        if ([[dictionary objectForKey:@"type"] isEqualToString:@"sendVideo"]) {
//                            [[NSNotificationCenter defaultCenter] postNotificationName:PushTheCalledPage object:nil userInfo:dictionary];
//                        }else if ([[dictionary objectForKey:@"type"] isEqualToString:@"maincancelVideo"]) {
//                            NSLog(@"在线腾讯IM 取消到了新的自定义的消息是 %@",dictionary);
//                            [[NSNotificationCenter defaultCenter] postNotificationName:CanclCallInConf object:nil];
//                        }else if ([[dictionary objectForKey:@"type"] isEqualToString:@"inviteAgreeVideo"]) {
//                            // 被叫方接受了视频通话邀请 并且进会
//                            [[NSNotificationCenter defaultCenter] postNotificationName:CallResponResult object:nil userInfo:dictionary];
//                        }else if ([[dictionary objectForKey:@"type"] isEqualToString:@"inviteCancelVideo"]) {
//                            // 被叫方取消视频通话邀请
//                            [[NSNotificationCenter defaultCenter] postNotificationName:CallResponResult object:nil userInfo:dictionary];
//                        }
//                    }
//
//                }
//            }
//        }else {
//            // 离线收到的
//            NSLog(@"离线收到的");
            int cnt = [message elemCount];
            for (int i = 0; i < cnt; i++) {
                TIMElem * elem = [message getElem:i];
                NSLog(@"TIMElemTIMElemTIMElem %@ %@",elem,timeStr);
                if ([elem isKindOfClass:[TIMCustomElem class]]) {
                    // 收到消息的服务器时间 和当前时间
                    NSDate *date1 = timeSmp;
                    NSDate *date2 = [NSDate date];
                    // 创建日历
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    NSCalendarUnit type =  NSCalendarUnitSecond;
                    // 利用日历对象比较两个时间的差值
                    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
                    NSLog(@"两个时间相差 %ld 秒",cmps.second);
                    if (cmps.second > 60*1) {
                        // 如果超过1分钟 那么不多这个消息进行任何处理

                    }else {

                        TIMCustomElem *custom_elem = (TIMCustomElem * )elem;
                        all_custom_elem = custom_elem;
                        NSLog(@"离线腾讯IM接受到了新的自定义的消息是 %@",custom_elem);
                        NSData *data = custom_elem.data;
                        
                        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithDictionary:dictionary];
                        [dicM setObject:fromStr forKey:@"mobile"];
                        
                        
                        NSLog(@"离线腾讯IM 接受到了新的自定义的消息是 %@",dicM);
                        if ([[dictionary objectForKey:@"type"] isEqualToString:@"mainCall"]) {
                            
                            self.pdDelayedBlockHandle = perform_block_after_delay(2.0, ^{
                                
                                NSLog(@"那么就通知对方接收000 %@",[CLConference conference].confConfig.conf_id);
                                if ([CLConference conference].confConfig.conf_id != nil) {
                                    if ([[CLConference conference].confConfig.conf_id isEqualToString:dictionary[@"confId"]]) {
                                        // 是一个会议号 那么就通知对方接收
                                        NSLog(@"那么就通知对方接收111");
                                        [self takeonMethod:fromStr];
                                    }else {
                                        // 不是一个会议号 拒绝对方
                                        NSLog(@"那么就通知对方拒绝222");
                                        [self cancelTheInviteTheConf:fromStr];
                                    }
                                }else {
                                    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"alreadyPushTheCalledPage"] || [[NSUserDefaults standardUserDefaults] boolForKey:@"alreadyPushTheCallingPage"]) {
                                        // 如果已经有界面了 那么之后的呼叫消息都不收了 返回拒绝的消息
                                        NSLog(@"那么就通知对方拒绝333");
                                        [self cancelTheInviteTheConf:fromStr];
                                    }else {
                                        NSLog(@"还是走了呼叫起来了");
                                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"alreadyPushTheCalledPage"];
                                        [[NSUserDefaults standardUserDefaults] synchroinzeCurrentUser];
                                        
                                        [[NSNotificationCenter defaultCenter] postNotificationName:PushTheCalledPage object:nil userInfo:dicM];
                                    }
                                }
                                
                            });
                            
                        }else if ([[dictionary objectForKey:@"type"] isEqualToString:@"mainCancel"]) {
                            NSLog(@"通知取消了么");
                            cancel_delayed_block(self.pdDelayedBlockHandle);
                            [[NSNotificationCenter defaultCenter] postNotificationName:CanclCallInConf object:nil];
//                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"alreadyPushTheCalledPage"];
//                            [[NSUserDefaults standardUserDefaults] synchroinzeCurrentUser];
                            
                        }else if ([[dictionary objectForKey:@"type"] isEqualToString:@"calledCall"]) {
                            // 被叫方接受了视频通话邀请 并且进会
                            [[NSNotificationCenter defaultCenter] postNotificationName:CallResponResult object:nil userInfo:dicM];
                        }else if ([[dictionary objectForKey:@"type"] isEqualToString:@"calledCancel"]) {
                            // 被叫方取消视频通话邀请
                            [[NSNotificationCenter defaultCenter] postNotificationName:CallResponResult object:nil userInfo:dicM];
                        }
                    }

                }
            }
//        }
    }
}
// 被叫方点击了取消按钮
- (void)cancelTheInviteTheConf:(NSString *)sender {
    TIMConversation * c2c_conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:sender];
    NSDictionary *videoStr = @{@"type":@"calledCancel",@"reason":@(1)};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:videoStr options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"视频被叫方取消通话JSON: %@", jsonData);
    TIMCustomElem * custom_elem = [[TIMCustomElem alloc] init];
    [custom_elem setData:jsonData];
    TIMMessage * msg = [[TIMMessage alloc] init];
    TIMOfflinePushInfo *offlineInfo = [[TIMOfflinePushInfo alloc] init];
    offlineInfo.desc = @"对方拒绝了视频通话";
    offlineInfo.ext = @"对方拒绝了视频通话";
    [msg setOfflinePushInfo:offlineInfo];
    [msg addElem:custom_elem];
//    __weak typeof(self)weakSelf = self;
    [c2c_conversation sendMessage:msg succ:^(){
        NSLog(@"SendcustomMsg Succ");
    }fail:^(int code, NSString * err) {
        NSLog(@"SendcustomMsg Failed:%d->%@", code, err);
    }];
}
// 直接通知对方进会接听
- (void)takeonMethod:(NSString *)sender {
    TIMConversation * c2c_conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:sender];
    NSDictionary *videoStr = @{@"type":@"calledCall"};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:videoStr options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"视频被叫方接听通话JSON: %@", jsonData);
    TIMCustomElem * custom_elem = [[TIMCustomElem alloc] init];
    [custom_elem setData:jsonData];
    TIMMessage * msg = [[TIMMessage alloc] init];
    TIMOfflinePushInfo *offlineInfo = [[TIMOfflinePushInfo alloc] init];
    offlineInfo.desc = @"接听了通话";
    offlineInfo.ext = @"接听了通话";
    [msg setOfflinePushInfo:offlineInfo];
    [msg addElem:custom_elem];
    [c2c_conversation sendMessage:msg succ:^(){
        NSLog(@"SendcustomMsg Succ");
    }fail:^(int code, NSString * err) {
        NSLog(@"SendcustomMsg Failed:%d->%@", code, err);
    }];
}
static PDDelayedBlockHandle perform_block_after_delay(CGFloat seconds, dispatch_block_t block) {
    if (block == nil) {
        return nil;
    }
    
    __block dispatch_block_t blockToExecute = [block copy];
    __block PDDelayedBlockHandle delayHandleCopy = nil;
    
    PDDelayedBlockHandle delayHandle = ^(BOOL cancel) {
        if (!cancel && blockToExecute) {
            blockToExecute();
        }
#if !__has_feature(objc_arc)
        
        [blockToExecute release];
        [delayHandleCopy release];
#endif
        
        blockToExecute = nil;
        delayHandleCopy = nil;
    };
    // delayHandle also needs to be moved to the heap.
    delayHandleCopy = [delayHandle copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (nil != delayHandleCopy) {
            delayHandleCopy(NO);
        }
        
    });
    
    return delayHandleCopy;
}


static void cancel_delayed_block(PDDelayedBlockHandle delayedHandle) {
    if (nil == delayedHandle) {
        return;
    }
    
    dispatch_sync(dispatch_queue_create("com.mango.matchCancelQueue", NULL), ^{
        delayedHandle(YES);
    });
}
//- (void)onNewMessage:(NSArray*)msgs {
//    NSLog(@"腾讯IM 接受到了新的消息 %@",msgs);
//    NSArray *arr = [[SIMMessageFMDB sharedData] selectDataChat];
//    for (int i = 0 ; i<msgs.count ; i++) {
//        TIMMessage * message = msgs[i];
//        NSString *fromStr = [message sender];
//        NSDate *timeSmp = [message timestamp];
//        NSString *timeStr = [NSString dateTranformTimeStrFromDate:timeSmp withformat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[timeSmp timeIntervalSince1970]];
//        int cnt = [message elemCount];
//        for (int i = 0; i < cnt; i++) {
//            TIMElem * elem = [message getElem:i];
//            NSLog(@"TIMElemTIMElemTIMElem %@ %@",elem,timeStr);
//            if ([elem isKindOfClass:[TIMTextElem class]]) {
//                TIMTextElem * text_elem = (TIMTextElem * )elem;
//                NSLog(@"腾讯IM接受到了新的消息文字消息是 %@",text_elem);
//                ZXMessageModel *recMessage = [[ZXMessageModel alloc] init];
//                recMessage.messageType = ZXMessageTypeText;
//                recMessage.ownerTyper = ZXMessageOwnerTypeOther;
//                recMessage.dateSp = [timeSp integerValue];
//                recMessage.text = text_elem.text;
//                recMessage.toMan = fromStr;
//                //            recMessage.toMan = self.currentUser.mobile;
//                [[SIMMessageFMDB sharedData] insertData:recMessage];
//                // 发送刷新通知
//                NSDictionary *mySendDic = @{@"recMessage":recMessage};
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTheMessageVC" object:nil userInfo:mySendDic];
//
//                ZXUserModel *item1 = [[ZXUserModel alloc] init];
//                item1.fromMan = fromStr;
//                item1.message = text_elem.text;
//
//                for (ZXUserModel *mm in arr) {
//                    if ([mm.fromMan isEqualToString:fromStr]) {
//                        item1.messageCount = mm.messageCount + 1;
//                        break ;
//                    }
//                }
//                item1.date = timeSmp;
//                item1.dateSp = [timeSp integerValue];
//
//                NSLog(@"item1.messageCount  %d %ld",item1.messageCount,item1.dateSp);
//
//                [[SIMMessageFMDB sharedData] insertDataChat:item1];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTheChatVC" object:nil];
//            }
//            else if ([elem isKindOfClass:[TIMImageElem class]]) {
//                TIMImageElem * image_elem = (TIMImageElem * )elem;
//                NSLog(@"腾讯IM接受到了新的消息图片消息是 %@",image_elem);
//
//                NSLog(@"腾讯IM图片文件arr路径------%@",image_elem.imageList);
//
//                //遍历所有图片规格(缩略图、大图、原图)
//                NSArray * imgList = [image_elem imageList];
//
//
//                for (TIMImage * image in imgList) {
//
//                    if (image.type == 2) {
//                        NSString *urlthender = image.url;
//                        NSLog(@"腾讯IM缩略图片文件remote路径------%@",urlthender);
//                        NSString *NameStr = [NSString stringWithFormat:@"%lf", [[NSDate date]timeIntervalSince1970]];
//                        NSString *fullPath = [PATH_DOCUMENT stringByAppendingPathComponent:NameStr];
//                        //获取网络请求中的url地址
//                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlthender]];
//                        //转换为图片保存到以上的沙盒路径中
//                        UIImage * currentImage = [UIImage imageWithData:data];
//                        [UIImageJPEGRepresentation(currentImage, 0.5) writeToFile:fullPath atomically:YES];
//
//                        NSLog(@"fullPath收到的图片路径 %@",fullPath);
//
////                        [image getImage:fullPath succ:^(){  //接收成功
//                            NSLog(@"SUCC: pic store to %@", fullPath);
//                            ZXMessageModel *recMessage = [[ZXMessageModel alloc] init];
//                            recMessage.messageType = ZXMessageTypeImage;
//                            recMessage.ownerTyper = ZXMessageOwnerTypeOther;
//                            recMessage.imagePath = NameStr;
//                            recMessage.toMan = fromStr;
//                            //            recMessage.toMan = self.currentUser.mobile;
//                            recMessage.dateSp = [timeSp integerValue];
//
//                            [[SIMMessageFMDB sharedData] insertData:recMessage];
//
//                            // 发送刷新通知
//                            NSDictionary *mySendDic = @{@"recMessage":recMessage};
//                            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTheMessageVC" object:nil userInfo:mySendDic];
//
//
//                            ZXUserModel *item1 = [[ZXUserModel alloc] init];
//                            item1.fromMan = fromStr;
//                            item1.message = @"[图片]";
//                            //            item1.avatarURL = [NSString stringWithFormat: @"%@", [NSURL URLWithString:@"10.jpeg"]];
//                            item1.messageCount = 0;
//                            item1.date = [NSDate date];
//                            item1.dateSp = [timeSp integerValue];
//                            for (ZXUserModel *mm in arr) {
//                                if ([mm.fromMan isEqualToString:fromStr]) {
//                                    item1.messageCount = mm.messageCount + 1;
//                                    break ;
//                                }
//                            }
//
//                            [[SIMMessageFMDB sharedData] insertDataChat:item1];
//
//                            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTheChatVC" object:nil];
////                        }fail:^(int code, NSString * err) {  //接收失败
////                            NSLog(@"ERR: code=%d, err=%@", code, err);
////                        }];
//                    }
//                }
//
//            }else if ([elem isKindOfClass:[TIMCustomElem class]]) {
//                // 收到消息的服务器时间 和当前时间
//                NSDate *date1 = timeSmp;
//                NSDate *date2 = [NSDate date];
//                // 创建日历
//                NSCalendar *calendar = [NSCalendar currentCalendar];
//                NSCalendarUnit type =  NSCalendarUnitSecond;
//                // 利用日历对象比较两个时间的差值
//                NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
//                NSLog(@"两个时间相差 %ld 秒",cmps.second);
//                if (cmps.second > 60*1) {
//                    // 如果超过两分钟 那么不多这个消息进行任何处理
//
//                }else {
//                    TIMCustomElem * custom_elem = (TIMCustomElem * )elem;
//                    NSLog(@"腾讯IM接受到了新的自定义的消息是 %@",custom_elem);
//                    NSData *data = custom_elem.data;
//                    NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                    NSLog(@"腾讯IM 接受到了新的自定义的消息是 %@",dictionary);
//
//                    if ([[dictionary objectForKey:@"type"] isEqualToString:@"maincancelVideo"]) {
//                        // 主叫方取消视频通话
//                        [[NSNotificationCenter defaultCenter] postNotificationName:CanclCallInConf object:nil];
////                        return ;
//                    }else if ([[dictionary objectForKey:@"type"] isEqualToString:@"sendVideo"]) {
//                        // 主叫方发出视频通话邀请
//                        [[NSNotificationCenter defaultCenter] postNotificationName:PushTheCalledPage object:nil userInfo:dictionary];
//                    }else if ([[dictionary objectForKey:@"type"] isEqualToString:@"inviteAgreeVideo"]) {
//                        // 被叫方接受了视频通话邀请 并且进会
//                        [[NSNotificationCenter defaultCenter] postNotificationName:CallResponResult object:nil userInfo:dictionary];
//                    }else if ([[dictionary objectForKey:@"type"] isEqualToString:@"inviteCancelVideo"]) {
//                        // 被叫方取消视频通话邀请
//                        [[NSNotificationCenter defaultCenter] postNotificationName:CallResponResult object:nil userInfo:dictionary];
//                    }
//                }
//
//            }
//        }
//    }
//
//}


@end
