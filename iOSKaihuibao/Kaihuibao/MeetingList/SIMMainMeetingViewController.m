//
//  SIMMainMeetingViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/9/15.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMMainMeetingViewController.h"

#import "SIMMainShareViewController.h"
#import "SIMReUserInfoViewController.h"
#import "SIMLoginMainViewController.h"
#import "SIMEntranceViewController.h"
#import "SIMLabelNet.h"
#import "PopView.h"
#import "SIMVersionUpdateModel.h"
#import "SIMNMmainViewController.h"
#import "SIMLoginViewController.h"
#import "TUIKit.h"
#import <Contacts/Contacts.h>
#import "THelper.h"
#import "ChatViewController.h"
#import "PDCameraScanViewController.h"
#import "SIMFindPageViewController.h"
#import "SIMAdressViewController.h"
#import "SIMScrollTextAlertView.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "SIMTempCompanyViewController.h"

@interface SIMMainMeetingViewController ()<UIScrollViewDelegate,TIMUserStatusListener,AVAudioRecorderDelegate>

@property (nonatomic, strong) UIScrollView *baseScrollView;// 滚动视图
@property (nonatomic, strong) SIMNMmainViewController *meetingVC; // 会议的VC
@property (nonatomic, strong) NSDictionary *confDescD;
@property (nonatomic, strong) NSMutableArray <UIViewController *> *subViewControllers;
@property (nonatomic, strong) SIMLabelNet *labNetView;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@end

@implementation SIMMainMeetingViewController

-(instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutRequest) name:@"forceOffline" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reNetWorkActive) name:NetWorkReConnect object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(speakStart:) name:@"CLTalkbackSchemaSpeakButtonActionNoti" object:nil];

        
    }
    return self;
}


- (void)speakStart:(NSNotification *)notification {
    NSDictionary *dic = [notification userInfo];
    if ([dic[@"type"] isEqualToString:@"speak"]) {
        BOOL isOpen = [dic[@"value"] boolValue];
        if (isOpen) {
            [self startRecord];
        }else {
            [self stopClick:dic[@"conf_id"]];
        }
    }else if ([dic[@"type"] isEqualToString:@"chat"]) {
        UIViewController *vc = dic[@"value"];
        TConversationCellData *data = [[TConversationCellData alloc] init];
        data.convId = dic[@"conf_id"];
        data.convType = TConv_Type_Group;
        data.title = dic[@"conf_id"];
        ChatViewController *chat = [[ChatViewController alloc] init];
        chat.conversation = data;
        chat.isConfVC = YES;
        UIViewController *viewcontroller = [chat sim_wrappedByNavigationViewControllerClass:[SIMBaseNavigationViewController class]];
        viewcontroller.modalPresentationStyle = UIModalPresentationFullScreen;
        [vc presentViewController:viewcontroller animated:YES completion:nil];
    }
    
}
- (void)stopClick:(NSString *)goupID {
    NSLog(@"走了抬起按钮");
    NSString *path = [self stopRecord];
    NSURL *url = [NSURL fileURLWithPath:path];
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    int duration = (int)CMTimeGetSeconds(audioAsset.duration);
    int length = (int)[[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize];
    
    TIMConversation * c2c_conversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:goupID];
    
    TIMSoundElem * sound_elem = [[TIMSoundElem alloc] init];
    [sound_elem setPath:path];
    [sound_elem setSecond:duration];
    sound_elem.dataSize = length;
    TIMMessage * msg = [[TIMMessage alloc] init];
    [msg addElem:sound_elem];
    [c2c_conversation sendMessage:msg succ:^(){
        NSLog(@"SendMsgsound Succ");
    }fail:^(int code, NSString * err) {
        NSLog(@"SendMsgsound Failed:%d->%@", code, err);
    }];
    
}
- (NSString *)stopRecord
{
    if([_recorder isRecording]){
        [_recorder stop];
    }
    NSString *wavPath = _recorder.url.path;
    NSString *amrpath = [[wavPath stringByDeletingPathExtension] stringByAppendingString:@".amr"];
    [THelper convertWav:wavPath toAmr:amrpath];
    [[NSFileManager defaultManager] removeItemAtPath:wavPath error:nil];
    return amrpath;
}
- (void)startRecord
{
    NSLog(@"走了开始录制的按钮");
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [session setActive:YES error:&error];
    
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];
    
    NSString *path = [[NSHomeDirectory() stringByAppendingString:@"/Library/Caches/voice/"] stringByAppendingString:[THelper genVoiceName:nil withExtension:@"wav"]];
    NSURL *url = [NSURL fileURLWithPath:path];
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:nil];
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
    [_recorder record];
    [_recorder updateMeters];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 重新登录入会 -- 程序进入前台,主要是为了锁屏事件,重新调用入会 (该方法登录进入首页不会走 然后每次重启首页都先走viewdidload然后走reactive 如果在后台没被杀死不会走viewdidload就走reactive )
- (void)reActive
{
    [self searchHasPlan];  // 检测是否有计划
//    [MBProgressHUD cc_showText:@"reActive"];
    [self enterTheConfIfInited];
}

// 重新登录入会-- （这个方法只是在第一次进入没网才会走）没网络链接,需要重新查询服务器,防止第一次进入时候就没网没查到地址
- (void)reNetWorkActive
{
    [self searchHasPlan];  // 检测是否有计划
    [self getUserList];        // 获取用户信息
//    [self searchLivingAdress]; // 查询直播地址
//    [self loginRLYMethod];     // 只有第一次没网才这样 如果中途 则不用走这个
    [self searchUpdateVersion];  // 检测版本更新
}

//- (void)enterConfBYShare:(NSNotification *)notification {
//    NSDictionary *shareTheConfEnter = [notification userInfo];
//    [self postToTabbarTheConfID:shareTheConfEnter[@"cid"] psw:shareTheConfEnter[@"psw"]];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"currentThreadcurrentThread %@",[NSThread currentThread]);
    _subViewControllers = [[NSMutableArray alloc] init];
//    if ([self.currentUser.mobile isEqualToString:@"15110191111"]) {
        // no为不展示 (当版本号相同以及后台返回为no时候 不展示)
        
        
//    }else {
//        // yes为展示 (其他情况 版本号不同 或者 当返回yes时候 都展示)
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showTheWechat"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//    [self searchHasPlan];  // 检测是否有计划
    [self searchUpdateVersion];  // 检测版本更新
//    [self loginRLYMethod];      // 登录容联云
    [self getUserList];         // 获取用户信息
//    [self searchLivingAdress];  // 查询直播地址
    [self enterTheConfIfInited];
//    [MBProgressHUD cc_showText:@"viewdidload"];
    
    [self setUpTheUI]; // 设置标题等UI
    
    _labNetView = [[SIMLabelNet alloc] initWithFrame:CGRectMake(0, 0, screen_width, 30)];
    [self.view addSubview:_labNetView];
    _labNetView.hidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"mainpageself.currentUser++%@",self.currentUser);
//        if (![AFNetworkReachabilityManager sharedManager].isReachable) {
//            [self reConnectWithDic:@"noConnect"];
//        }
        if ( self.currentUser.nickname.length == 0 && [self.currentUser.currentCompany.is_owner isEqualToString:@"1"]) {
            SIMReUserInfoViewController *cnVC = [[SIMReUserInfoViewController alloc] init];
            [self.navigationController pushViewController:cnVC animated:YES];
        }
        
    });

    
}
//- (void)reConnectWithDic:(NSString *)getsendValue {
////    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
//        NSLog(@"首次进入的横屏");
//    }else {
//        NSLog(@"首次进入的竖屏");
//        if ([getsendValue isEqualToString:@"noConnect"]) {
//            [UIView animateWithDuration:1 animations:^{
//                _labNetView.frame = CGRectMake(0, 0, screen_width, 30);
//                _baseScrollView.frame = CGRectMake(0, 30, screen_width, screen_height - StatusNavH - TabbarH);
//
//            } completion:^(BOOL finished) {
//                _labNetView.hidden = NO;
//            }];
//
//        }
//    }
//}
// 没有网络的失败视图动画
- (void)reConnectSecever:(NSNotification *)notification {
    NSString *getsendValue = [[notification userInfo] valueForKey:@"sendKey"];
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        NSLog(@"横屏");
    }else {
        NSLog(@"竖屏");
        if ([getsendValue isEqualToString:@"noConnect"]) {
            NSLog(@"竖屏noConnect");
            [UIView animateWithDuration:1 animations:^{
                _labNetView.frame = CGRectMake(0, 0, screen_width, 30);
                _baseScrollView.frame = CGRectMake(0, 30, screen_width, screen_height - StatusNavH - TabbarH);
                
            } completion:^(BOOL finished) {
                _labNetView.hidden = NO;
            }];
            
        }else if ([getsendValue isEqualToString:@"yesConnect"]) {
//            if (_labNetView.hidden == YES) {
//                return ;
//            }
            NSLog(@"竖屏yesConnect");
            [UIView animateWithDuration:1 animations:^{
                _labNetView.frame = CGRectMake(0, -30, screen_width, 30);
                _baseScrollView.frame = CGRectMake(0, 0, screen_width, screen_height - StatusNavH - TabbarH);
                
            } completion:^(BOOL finished) {
                _labNetView.hidden = YES;
            }];
        }
    }
}
- (void)setUpTheUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = SIMLocalizedString(@"TabBarMeetTitle", nil);
//#if TypeKaihuibao || TypeVideoBao
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"邀请联系人"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(moreClick)];
    self.navigationItem.rightBarButtonItem = rightBtn;
//#endif
//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"main_popview_扫一扫"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(scanErweimaClick)];
//    if ([self.cloudVersion.live boolValue]) {
//        UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"直播" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
//        self.navigationItem.leftBarButtonItem = leftBtn;
//    }
    self.view.backgroundColor = TableViewBackgroundColor;
    [self addScrollViews];// 添加分段控制器以及滚动子视图
}
//- (void)leftBtnClick {
//    NSLog(@"点击了直播导航左按钮");
//    [MBProgressHUD cc_showText:@"功能即将开放"];
//}

- (void)addScrollViews {
    //添加滚动视图 注！！！！！！！这个滚动视图先不删 怕以后加回来 所以先让滚动视图为一页
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH - TabbarH)];
    _baseScrollView.contentSize = CGSizeMake(screen_width, _baseScrollView.frame.size.height);
    _baseScrollView.bounces = NO;
    _baseScrollView.delegate = self;
    _baseScrollView.scrollEnabled = NO;
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_baseScrollView];
    
    //注！！！！！！！这个滚动视图先不删 怕以后加回来 所以先让滚动视图为一页 目前只加一个VC到控制器
    _baseScrollView.contentSize = CGSizeMake(screen_width, _baseScrollView.frame.size.height);
    _meetingVC = [[SIMNMmainViewController alloc] init];
    _meetingVC.view.frame = CGRectMake(0, 0, screen_width, _baseScrollView.frame.size.height);
    [self addChildViewController:_meetingVC];
    [_baseScrollView addSubview:_meetingVC.view];
    
    [self.subViewControllers addObject:_meetingVC];
}


///onzoom pop显示
-(void)typeXviewArray{
    NSMutableArray *picArr = [NSMutableArray array];
    NSMutableArray *titleArr = [NSMutableArray array];
    [picArr addObject:@"main_popview_分享链接"];
    [titleArr addObject:SIMLocalizedString(@"ShareTheDownLoadTitle", nil)];
    [picArr addObject:@"main_popview_邀请使用"];
    [titleArr addObject:SIMLocalizedString(@"ShareFromAdressBookTitle", nil)];
    [picArr addObject:@"main_popview_扫一扫"];
    [titleArr addObject:SIMLocalizedString(@"ShareTheScanTitle", nil)];
    [picArr addObject:@"main_popview_联系客服"];
    [titleArr addObject:SIMLocalizedString(@"ShareTheConnectServceTitle", nil)];
    [self thePopViewWithTitleArr:titleArr picArr:picArr];
}

// 其他pop显示
-(void)oldtypeArray{
        NSMutableArray *picArr = [NSMutableArray array];
        NSMutableArray *titleArr = [NSMutableArray array];
    //    if ([self.cloudVersion.find boolValue] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
    //        [picArr addObject:@"main_popview_发现"];
    //        [titleArr addObject:SIMLocalizedString(@"TabBarFindTitle", nil)];
    //    }
        [picArr addObject:@"main_popview_联系客服"];
        [titleArr addObject:SIMLocalizedString(@"ShareTheConnectServceTitle", nil)];
    #if TypeKaihuibao
        [picArr addObject:@"main_popview_分享链接"];
        [titleArr addObject:SIMLocalizedString(@"ShareTheDownLoadTitle", nil)];
    #else
    #endif
        if ([self.cloudVersion.invite boolValue]) {
            [picArr addObject:@"main_popview_邀请使用"];
            [titleArr addObject:SIMLocalizedString(@"ShareFromAdressBookTitle", nil)];
            [picArr addObject:@"main_popview_添加好友"];
            [titleArr addObject:SIMLocalizedString(@"CCAddTheFriendsTitle", nil)];
        }
        [picArr addObject:@"main_popview_扫一扫"];
        [titleArr addObject:SIMLocalizedString(@"ShareTheScanTitle", nil)];
        [picArr addObject:@"main_popview_投屏"];
        [titleArr addObject:@"投屏"];
        [picArr addObject:@"main_popview_新建直播"];
        [titleArr addObject:SIMLocalizedString(@"MArrangeNewLive", nil)];
    [self thePopViewWithTitleArr:titleArr picArr:picArr];
}

-(void)thePopViewWithTitleArr:(NSMutableArray *)titleArr picArr:(NSMutableArray *)picArr{
    [PopView configCustomPopViewWithFrame:CGRectMake(screen_width - 235, StatusNavH, 230, picArr.count * 50) imagesArr:picArr dataSourceArr:titleArr seletedRowForIndex:^(NSInteger index) {
        NSString *titleStr = titleArr[index];
        if ([titleStr isEqualToString:SIMLocalizedString(@"TabBarFindTitle", nil)]) {
            // 发现
            SIMFindPageViewController *subVC = [[SIMFindPageViewController alloc] init];
            [self.navigationController pushViewController:subVC animated:YES];
        }else if ([titleStr isEqualToString:SIMLocalizedString(@"ShareTheConnectServceTitle", nil)]) {
            // 联系客服 跳转官网
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kApiBaseUrl]];
        }else if ([titleStr isEqualToString:SIMLocalizedString(@"ShareTheDownLoadTitle", nil)]) {
            // 分享链接
            SIMMainShareViewController *shareVC = [[SIMMainShareViewController alloc] init];
            [self.navigationController pushViewController:shareVC animated:YES];

        }else if ([titleStr isEqualToString:SIMLocalizedString(@"ShareTheScanTitle", nil)]) {
            // 扫一扫
            [self scanErweimaClick];
        }else if ([titleStr isEqualToString:SIMLocalizedString(@"ShareFromAdressBookTitle", nil)] || [titleStr isEqualToString:SIMLocalizedString(@"CCAddTheFriendsTitle", nil)]) {
            // 邀请好友入会 通讯录
            [self requestAuthorizationToAdd:SIMLocalizedString(@"ShareFromAdressBookTitle", nil) isNeedChange:NO];
        }else {
            NSLog(@"点击了其他的没实现的功能");
        }
    } animation:YES timeForCome:0.4 timeForGo:0.2];
}

// 导航右按钮点击事件
- (void)moreClick {
    #if TypeKaihuibao
        [self oldtypeArray];
    #elif TypeVideoBao
        [self oldtypeArray];
    #elif TypeClassBao
        [self oldtypeArray];
    #elif TypeJianshenBao
        [self oldtypeArray];
    #elif TypeXviewPrivate
        [self typeXviewArray];
    #endif
}

- (void)scanErweimaClick {
    // 扫描二维码
    PDCameraScanViewController *shareVC = [[PDCameraScanViewController alloc] init];
    [self.navigationController pushViewController:shareVC animated:YES];
}

// 获取用户信息列表
- (void)getUserList {
    [MainNetworkRequest getInfoRequestParams:nil success:^(id success) {
        // 成功
        if ([success[@"code"] integerValue] == successCodeOK) {
            // 字典 加入一个token值 用来初始化CCUser
            NSMutableDictionary *dicMM = [[NSMutableDictionary alloc] initWithDictionary:success[@"data"]];
            
            for (int i =0; i<dicMM.count; i++) {
                if ([[dicMM objectForKey:dicMM.allKeys[i]] isKindOfClass:[NSNumber class]]) {
                    NSString *key = dicMM.allKeys[i];
                    NSNumber *longn = [NSNumber numberWithLong:[[dicMM objectForKey:key] longValue]];
                    NSString *longss = [longn stringValue];
                    [dicMM removeObjectForKey:key];
                    [dicMM setObject:longss forKey:key];
                }
            }
            
            if ([[dicMM objectForKey:@"avatar"] length] >0) {
                // 将face的value取出来 然后拼接
                NSString *faceValue = [dicMM objectForKey:@"avatar"];
                NSString *newFaceValue = [NSString stringWithFormat:@"%@%@",kApiBaseUrl,faceValue];
                
                [dicMM removeObjectForKey:@"avatar"];
                [dicMM setObject:newFaceValue forKey:@"avatar"];
            }
            
            //  登录或注册服务器默认有的参数 赋值给self.currentUser以后全局可用 主要是不可以改变
            CCUser *myUser = [[CCUser alloc] initWithDictionary:dicMM];
            self.currentUser = myUser;
            
            self.currentUser.currentCompany = self.currentCompany;
            
            [self.currentUser synchroinzeCurrentUser];
            NSLog(@"newcurrentUser:+++%@",self.currentUser);
            
//            NSLog(@"newcomcom %@ %@",self.currentUser.currentCompany.company_id,self.currentUser.currentCompany.company_name);
//            NSLog(@"newcomcomteo %@ %@", self.currentCompany.company_id, self.currentCompany.company_name);
            if ([self.cloudVersion.im boolValue]) {
                [self loginRLYMethod];
            }
        }
        
    } failure:^(id failure) {
        
    }];
}


- (void)enterTheConfIfInited {
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    if (app.isShareEnter==YES) {
        app.isShareEnter = NO;
        // 让tabbar进会
        NSLog(@"断连重新查询成功后，通知让tabbar进");
//        [_arl dismissWithClickedButtonIndex:0 animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self postToTabbarTheConfID:app.shareTheConfEnter];
    }
}

// 链接唤起入会的时候 先保证服务器地址设置成功之后进会
- (void)postToTabbarTheConfID:(NSDictionary *)confDetail{
    // 写成这个形式 是为了和呼叫标准key一致 公用一个方法就行了
//    NSDictionary *myDictionary = @{@"confId":confDetail[@"cid"]};
    [[NSNotificationCenter defaultCenter] postNotificationName:CallAccpectInConf object:nil userInfo:confDetail];
    NSLog(@"调用一次就好哈");
}

- (void)loginRLYMethod {
    NSString *identifier = self.currentUser.username; //填入登录用户名
    NSString *userSig = self.currentUser.userSig;        //填入签名 userSig
    __weak typeof(self)weakSelf = self;
    [[TUIKit sharedInstance] loginKit:identifier userSig:userSig succ:^{
        NSLog(@"腾讯IM Login Succ");
//        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
//        NSLog(@"timeInterval%f",timeInterval);
//        [[NSUserDefaults standardUserDefaults] setFloat:timeInterval forKey:@"TIMloginTime"];
        [weakSelf timLoginSuccessMethod];
    } fail:^(int code, NSString *msg) {
        NSLog(@"腾讯IM  Login Failed: %d  %@", code, msg);
        if (code == ERR_IMSDK_KICKED_BY_OTHERS) {
            //互踢重联，重新再登录一次
//            [self logoutRequest];
            NSLog(@"ERR_IMSDK_KICKED_BY_OTHERS");
        }
    }];
}
- (void)timLoginSuccessMethod {
    TIMTokenParam *param = [[TIMTokenParam alloc] init];
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];

#if DEBUG
    param.busiId = TengXunIMAPPIDDebug;
#else
    param.busiId = TengXunIMAPPIDRelease;
#endif

    [param setToken:app.deviceToken];
    [[TIMManager sharedInstance] setToken:param succ:^{
        NSLog(@"腾讯IM -----> 上传 token 成功 ");
    } fail:^(int code, NSString *msg) {
        NSLog(@"腾讯IM -----> 上传 token 失败 ");
    }];
    if (self.currentUser.nickname == nil) {
        
    }else {
        [[TIMFriendshipManager sharedInstance] modifySelfProfile:@{TIMProfileTypeKey_Nick:self.currentUser.nickname,TIMProfileTypeKey_FaceUrl:self.currentUser.avatar} succ:^{
            NSLog(@"腾讯IM -----> 上传成功头像 ");
        } fail:^(int code, NSString *msg) {
            NSLog(@"腾讯IM -----> 上传失败头像 ");
        }];
    }
    //获取未读计数
    int unReadCount = 0;
    NSArray *convs = [[TIMManager sharedInstance] getConversationList];
    for (TIMConversation *conv in convs) {
        if([conv getType] == TIM_SYSTEM){
            continue;
        }
        unReadCount += [conv getUnReadMessageNum];
        
    }
    NSLog(@"unReadCountunReadCount %d",unReadCount);
    if (unReadCount > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HaveNotification" object:nil userInfo:@{@"type":@"showRedBtn"}];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HaveNotification" object:nil userInfo:@{@"type":@"hideRedBtn"}];
    }
}
//- (void)onForceOffline {
//    NSLog(@"腾讯IM被踢出掉线");这里注释掉了 改为了 他里面实现的这个回调 然后发送通知 通知本页面退出登录
//    [self logoutRequest];
//}
// 退出登录网络请求
- (void)logoutRequest {
    NSLog(@"腾讯IM被踢出掉线");
    [MBProgressHUD cc_showLoading:nil];
    // 登出  现在做的是不管成功与否都 回到登录界面 防止切换了服务器啥的导致没法收到接口回调退步出去和web同步协定改的
    [MainNetworkRequest logoutRequestParams:@{} success:^(id success) {
        NSLog(@"logoutResult %@",success[@"msg"]);
        
    } failure:^(id failure) {
        //        [self logoutRequestAfter];
    }];
    __weak typeof(self)weakSelf = self;
    [[TUIKit sharedInstance] logoutKit:^{
        NSLog(@"logout succ");
        [weakSelf logoutRequestAfter];
    } fail:^(int code, NSString *msg) {
        [weakSelf logoutRequestAfter];
        NSLog(@"logout fail: code=%d err=%@", code, msg);
    }];
    
}
// 退出登录网络请求 之后的操作
- (void)logoutRequestAfter {
    self.currentUser.currentCompany = [SIMCompany new];
    self.currentUser = [CCUser new]; // 释放主用户对象
    self.currentCompany = [SIMCompany new];// 释放公司模型
    [self.currentCompany synchroinzeCurrentCompany];
    [self.currentUser synchroinzeCurrentUser];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userToken"]; // 立即清token
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MYCONF"];// 清空我的会议室model
    //    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MYLIVE"];// 清空我的直播间model
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentPlanName"]; // 当前的会议计划名称
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentPlanID"]; // 当前的会议计划名称
    //    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginConfServerSuccess"];// 登录服务器的状态记录
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsHaveAdressBook"]; // 是否传了通讯录
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"showTheWechat"];// 是否上线显示微信
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OneConfServerAdress"]; // 链接入会一次性地址 也要删掉 防止链接唤起app被挤掉线
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [MainNetworkRequest cancelAllRequest];
    
    // 注意！！延时是为了 开会中 账号互踢 被踢出会议时sdk先给的被踢回调 收到被踢就会调用下面的登录界面 之后sdk才走的退会 不退会没法释放当前VC  所以延时2秒 让sdk先释放VC
    [SIMNewEnterConfTool exitTheConf];
//    [self.navigationController dismissViewControllerAnimated:NO completion:^{}];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 且根视图 返回登录页
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
        
        UIViewController *loginNavigationViewController = [[SIMEntranceViewController alloc] init];
        windowRootViewController = loginNavigationViewController;
        
//        if ([self.cloudVersion.version isEqualToString:@"privatization"]) {
//            // 私有 判断私有 因为私有界面特殊 其余情况全部正常界面
//            UIViewController *loginVC = [[[SIMLoginViewController alloc] init] sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
//            loginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//            loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
//            [loginNavigationViewController presentViewController:loginVC animated:YES completion:nil];
//        }else {
//            // 公有
//            UIViewController *loginVC = [[[SIMLoginMainViewController alloc] init] sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
//            loginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//            loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
//            [loginNavigationViewController presentViewController:loginVC animated:YES completion:nil];
//        }
        
    });
}

// 通过查询后台接口是版本号需要更新还是强制更新
- (void)searchUpdateVersion {
    NSDictionary *dic = @{@"versionCode":[NSString getLocalAppVersion],@"packageName":[NSString getBundleID],@"device":@"ios"};
    NSLog(@"searchupdateversiondic  %@",dic);
    [MainNetworkRequest updateVersionRequestParams:dic success:^(id success) {
        // 成功
//        NSLog(@"searchupdateversionSuccess  %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            
            NSDictionary *dic = success[@"data"];
            SIMVersionUpdateModel *model = [[SIMVersionUpdateModel alloc] initWithDictionary:dic];
            if (model.needUpdate && !model.enforce) {
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%@",SIMLocalizedString(@"UpdateTitleText", nil),model.appName] message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"UpdateTitleYES", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString *urls = model.downloadurl;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urls]];
                }]];
                [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"UpdateTitleNO", nil) style:UIAlertActionStyleDefault handler:nil]];
                
                [self presentViewController:alertView animated:YES completion:nil];
            }
            if (model.needUpdate && model.enforce) {
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%@",SIMLocalizedString(@"UpdateTitleText", nil),model.appName] message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"UpdateTitleYES", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString *urls = model.downloadurl;
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urls]];
                }]];
                [self presentViewController:alertView animated:YES completion:nil];
            }
        }
    } failure:^(id failure) {
    }];
}

- (void)searchHasPlan {
    [MainNetworkRequest hidePlanRequestParams:nil success:^(id success) {
        // 成功
//        NSLog(@"mainpagehidePlanRequestSuccess  %@",success);
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
        }
    } failure:^(id failure) {
        
    }];
}
- (void)requestAuthorizationToAdd:(NSString *)title isNeedChange:(BOOL)isNeedChange {
    
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if(authorizationStatus ==CNAuthorizationStatusNotDetermined) {
        
        CNContactStore*contactStore = [[CNContactStore alloc]init];
        
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted,NSError*_Nullable error) {
            if(granted) {
                NSLog(@"通讯录获取授权成功==");
                
            }else{
                NSLog(@"授权失败, error=%@", error);
            }
        }];
    }
    else if (authorizationStatus == CNAuthorizationStatusRestricted ||authorizationStatus == CNAuthorizationStatusDenied) {
        NSLog(@"用户没有授权==");
        [self addAdressAlertViewController];
    }
    else if(authorizationStatus ==CNAuthorizationStatusAuthorized){
        NSLog(@"已经授权过了通讯录==");
        // 跳转通讯录
        SIMAdressViewController *adbVC = [[SIMAdressViewController alloc] init];
        adbVC.isNeedChange = isNeedChange;
        adbVC.navigationItem.title = title;
        [self.navigationController pushViewController:adbVC animated:YES];
    }
    
}

// 通讯录未开启权限弹框
- (void)addAdressAlertViewController {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:SIMLocalizedString(@"CCInfoPlistAdress", nil) message:SIMLocalizedString(@"CCInfoPlistAdressTEST", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCSet", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳入当前App设置界面,
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if( [[UIApplication sharedApplication]canOpenURL:url] ) {
            [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL        success) {
            }];
        }
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVc presentViewController:alertView animated:YES completion:nil];
}

- (void)pushThePrivateAlert {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.2;
    backView.tag = 1000;
    [window addSubview:backView];
    NSLog(@"window添加了backView");
    
    SIMScrollTextAlertView *privateAlertView = [[SIMScrollTextAlertView alloc] init];
    privateAlertView.tag = 1001;
    [window addSubview:privateAlertView];
    NSLog(@"window添加了privateAlertView");
    [privateAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(kWidthScale(50));
        make.right.mas_equalTo(-kWidthScale(50));
    }];
    NSLog(@"window添加了privateAlertView");
    
    privateAlertView.buttonSerialBlock = ^(NSInteger index) {
//        if (index == 1) {
//            // 代表同意 以后不用弹了
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"privateAlertView"];
//        }
        [[[UIApplication sharedApplication].keyWindow viewWithTag:1000] removeFromSuperview];
        [[[UIApplication sharedApplication].keyWindow viewWithTag:1001] removeFromSuperview];
    };
    NSString *privateStr = @"《隐私协议》";
    [privateAlertView.content yb_addAttributeTapActionWithStrings:@[privateStr] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
        // 跳到隐私政策
        SIMTempCompanyViewController *webVC = [[SIMTempCompanyViewController alloc] init];
        UIViewController* navVC = [webVC sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
        navVC.modalPresentationStyle = UIModalPresentationFullScreen;
        webVC.isPresent = YES;
        webVC.navigationItem.title = SIMLocalizedString(@"KHBseverceAndListPrivateClick", nil);
        webVC.webStr = [NSString stringWithFormat:@"%@%@",kApiBaseUrl,self.cloudVersion.privacy_path];
        [self presentViewController:navVC animated:YES completion:nil];
    
    }];
    
}


@end
