//
//  BaseNetworking.m
//  kaihuibao
//
//  Created by wangxiaoqi on 2017/5/22.
//  Copyright © 2017年 wangxiaoqi. All rights reserved.
//
#import "BaseNetworking.h"
#import "SIMLoginMainViewController.h"
#import "SIMLoginViewController.h"
#import "SIMEntranceViewController.h"
#import "sys/utsname.h"
#import "TUIKit.h"

static NSMutableArray *requestTasksPool;
static BaseNetworking *_base;
static BOOL isfirst; // 是不是第一次启动程序 想要第一次进入不提示网络状态
static BOOL noConnect; // 第一次进入app是不是没有联网的状态 no是有网 yes是没网没网的话监听到连上网络后自动发送通知刷新数据
static BOOL islogOut; // 是不是准备跳转登录页面，防止多个请求调用登出而导致登录页面多次弹出

@interface BaseNetworking()
//@property (nonatomic,assign)NSInteger networkStatus;//网络状态
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end


@implementation BaseNetworking


#pragma mark - 取消全部请求的方法
- (void)cancleAllRequest {
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(URLSessionTask  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[URLSessionTask class]]) {
                [obj cancel];
            }
        }];
        [[self allTasks] removeAllObjects];
    }
}
- (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestTasksPool == nil) requestTasksPool = [[NSMutableArray alloc] init];
    });
    
    return requestTasksPool;
}

#pragma mark - 初始化
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _base = [[BaseNetworking alloc] init];
        isfirst = YES;
        noConnect = NO;
        islogOut = NO;
    });
    return _base;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _base = [super allocWithZone:zone];
    });
    return _base;
}
- (id)copyWithZone:(NSZone *)zone{
    return _base;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return _base;
}

- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.sessionManager = [AFHTTPSessionManager manager];
        self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.sessionManager.requestSerializer.timeoutInterval = 10;
        self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        self.sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        self.sessionManager.securityPolicy.allowInvalidCertificates = YES;
        [self.sessionManager.securityPolicy setValidatesDomainName:NO];
    
    });
    return self;
}


#pragma mark - 判断网络
- (void)getReach {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSDictionary *myDictionary = [NSDictionary dictionaryWithObject:@"yesConnect" forKey:@"sendKey"];
                [[NSNotificationCenter defaultCenter] postNotificationName:connectSeverce object:nil userInfo:myDictionary];
                if (isfirst == YES) {
                    isfirst = NO;
                }else{
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NetWorkLoginReConnect object:nil];
                    [MBProgressHUD cc_showText:SIMLocalizedString(@"AllNetWorkWIFITitle", nil)];
                    
                }
                if (noConnect == YES) {
                    // 没有网络那么连上网了之后发送通知 只用于刚进入app的判断
                    [[NSNotificationCenter defaultCenter] postNotificationName:NetWorkReConnect object:nil];
                    noConnect = NO;
                }
                
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSDictionary *myDictionary = [NSDictionary dictionaryWithObject:@"yesConnect" forKey:@"sendKey"];
                [[NSNotificationCenter defaultCenter] postNotificationName:connectSeverce object:nil userInfo:myDictionary];
                if (isfirst == YES) {
                    isfirst = NO;
                }else{
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NetWorkLoginReConnect object:nil];
                    [MBProgressHUD cc_showText:SIMLocalizedString(@"AllNetWorkWLANTitle", nil) delay:2];
                }
                if (noConnect == YES) {
                    // 没有网络那么连上网了之后发送通知 只用于刚进入app的判断
                    [[NSNotificationCenter defaultCenter] postNotificationName:NetWorkReConnect object:nil];
                    noConnect = NO;
                }
                
            }
                break;
                
            case AFNetworkReachabilityStatusNotReachable:{
                
                if (isfirst == YES) {
                    if (noConnect == NO) {
                        noConnect = YES;
                    }
                    
                    isfirst = NO;
                }
                NSDictionary *myDictionary = [NSDictionary dictionaryWithObject:@"noConnect" forKey:@"sendKey"];
                [[NSNotificationCenter defaultCenter] postNotificationName:connectSeverce object:nil userInfo:myDictionary];
                [MBProgressHUD cc_showText:SIMLocalizedString(@"AllNetWorkNONETitle", nil)];
                
                
            }
                break;
            case AFNetworkReachabilityStatusUnknown:{
                
                if (isfirst == YES) {
                    if (noConnect == NO) {
                        noConnect = YES;
                    }
                    isfirst = NO;
                }
                NSDictionary *myDictionary = [NSDictionary dictionaryWithObject:@"noConnect" forKey:@"sendKey"];
                [[NSNotificationCenter defaultCenter] postNotificationName:connectSeverce object:nil userInfo:myDictionary];
                [MBProgressHUD cc_showText:SIMLocalizedString(@"AllNetWorkUNKOWNTitle", nil)];
            
            }
                break;
                
            default:
                break;
        }
//        _networkStatus = status;
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
- (NSMutableDictionary *)addBaseObjectToParams:(NSDictionary *)params {
    NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithDictionary:params];
    // 软件版本标识信息
    [dicM setObject:getApp_Version forKey:@"app_version"];
    [dicM setObject:getApp_ownVersion forKey:@"app_ownversion"];
    // 设备唯一标识
    UIDevice *myDecive = [UIDevice currentDevice];
    [dicM setObject:myDecive.identifierForVendor forKey:@"device_id"];
    // 当前时间
    NSInteger timeSp = [[NSDate date] timeIntervalSince1970];
    [dicM setObject:@(timeSp) forKey:@"time"];
    // 平台类型
    [dicM setObject:@"1" forKey:@"device_plat"];
    // 发型渠道
    [dicM setObject:@"app_store" forKey:@"channel"];
    // 手机型号
    NSString * phoneModel =  [self deviceVersion];
    [dicM setObject:phoneModel forKey:@"device_brand"];
    // 国际化多语言
    NSString *langStr = [SIMInternationalController userLanguage];
    [dicM setObject:langStr forKey:@"lang"];
    // app的名字用于和后台区分是哪个app
    [dicM setObject:APPNameTitle forKey:@"appname"];
    NSLog(@"软件版本标识信息:%@ 内部版本:%@ 设备唯一标识:%@ 当前时间:%ld 手机型号:%@ 当前用户语言:%@",getApp_Version,getApp_ownVersion,myDecive.identifierForVendor,timeSp,phoneModel,langStr);

    
    return dicM;
}

#pragma mark - GET 不带token
- (void)startWithGetURL:(NSString *)url
                 params:(NSDictionary *)params
                success:(SuccessBlock)successBase
                failure:(FailureBlock)failureBase
{
    NSMutableDictionary *newparams = [self addBaseObjectToParams:params];
    
    NSLog(@"url = %@\nparams = %@",url,params);
    __block URLSessionTask *session = [self.sessionManager GET:url parameters:newparams headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"请求成功");
//        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
//        NSDictionary *allHeaders = response.allHeaderFields;
//
//        NSLog(@"res.allHeaderFields %@",allHeaders);
        
        NSDictionary *successDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([successDic[@"code"] integerValue] == successCodeOK) {
            successBase(successDic);
        }else {
//            [MBProgressHUD cc_showText:successDic[@"msg"]];
            successBase(successDic);
        }
        [[_base allTasks] removeObject:session];
        NSLog(@"url = %@\n %@",task.response.URL,successDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBase(error);
        [[_base allTasks] removeObject:session];
        NSLog(@"请求失败-----%@",error);
        if (error.code == -1009) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_theNet", nil)];
        }else {
            failureBase(error);
        }
    }];
    [[_base allTasks] addObject:session];
    // 启动任务
    [session resume];
}

#pragma mark - POST 不带token
- (void)startWithPostURL:(NSString *)url
                  params:(NSDictionary *)params
                 success:(SuccessBlock)successBase
                 failure:(FailureBlock)failureBase
{
    // 网络超时
    [self.sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.sessionManager.requestSerializer.timeoutInterval = 15.0f;
    [self.sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSMutableDictionary *newparams = [self addBaseObjectToParams:params];
    NSLog(@"url = %@\nparams = %@",url,newparams);
    __block URLSessionTask *session = [self.sessionManager POST:url parameters:newparams headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
//        NSDictionary *allHeaders = response.allHeaderFields;
//
//        NSLog(@"res.allHeaderFields %@",allHeaders);
        NSDictionary *successDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"请求成功 %@",successDic[@"code"]);
        if ([successDic[@"code"] integerValue] == successCodeOK) {
            successBase(successDic);
        }else {
//            [MBProgressHUD cc_showText:successDic[@"msg"]];
            successBase(successDic);
            
        }
        [[self allTasks] removeObject:session];
        NSLog(@"url = %@\n %@",task.response.URL,successDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBase(error);
        
        [[self allTasks] removeObject:session];
        if (error.code == -1009) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_theNet", nil)];
        }else {
            failureBase(error);
        }
        NSLog(@"请求失败-----%@",error);
    }];
    [[self allTasks] addObject:session];
    [session resume];
}
#pragma mark - GET 带请求头token
- (void)startWithHeaderGetURL:(NSString *)url
                       params:(NSDictionary *)params
                      success:(SuccessBlock)successBase
                      failure:(FailureBlock)failureBase
{
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
//    [self.sessionManager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"token"];
    
    NSLog(@"requestSerializerrequestSerializer %@",self.sessionManager.requestSerializer.HTTPRequestHeaders);
    
    NSMutableDictionary *newparams = [self addBaseObjectToParams:params];
    NSLog(@"url = %@\nparams = %@",url,newparams);

    __block URLSessionTask *session = [self.sessionManager GET:url parameters:newparams headers:@{@"token":tokenStr} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功");
        NSDictionary *successDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"url = %@\n %@",task.response.URL,successDic);

        if ([successDic[@"code"] integerValue] == successCodeOK) {
            successBase(successDic);
        }else if ([successDic[@"code"] integerValue] == 401) {
            // 未登录
            if (islogOut == NO) {
                islogOut = YES;
                [self logoutRequest];
            }
        }else if ([successDic[@"code"] integerValue] == 403) {
            // 没权限
            [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_PERMISSION_DENIED", nil)];
            successBase(successDic);
        }else {
//            [MBProgressHUD cc_showText:successDic[@"msg"]];
            successBase(successDic);
        }
        
        [[_base allTasks] removeObject:session];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBase(error);
        NSLog(@"请求失败-----%@",error);
        [[_base allTasks] removeObject:session];
        
    }];
    [[self allTasks] addObject:session];
    // 启动任务
    [session resume];
}

#pragma mark - POST 带请求头
- (void)startWithHeaderPostURL:(NSString *)url
                        params:(NSDictionary *)params
                       success:(SuccessBlock)successBase
                       failure:(FailureBlock)failureBase
{
    // 设置请求头
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
//    NSString *tokenStr = @"c0d36050-c4e5-4140-863d-beb646b0603a";
//    [self.sessionManager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"token"];
    NSLog(@"requestSerializerrequestSerializer%@",self.sessionManager.requestSerializer.HTTPRequestHeaders);
    // 网络超时
    [self.sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.sessionManager.requestSerializer.timeoutInterval = 15.0f;
    [self.sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSMutableDictionary *newparams = [self addBaseObjectToParams:params];
    NSLog(@"url = %@\nparams = %@",url,newparams);
    
    __block URLSessionTask *session = [self.sessionManager POST:url parameters:newparams headers:@{@"token":tokenStr} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功");
        NSDictionary *successDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"url = %@\n %@",task.response.URL,successDic);
        if ([successDic[@"code"] integerValue] == successCodeOK) {
            successBase(successDic);
        }else if ([successDic[@"code"] integerValue] == 401) {
            if (islogOut == NO) {
                islogOut = YES;
                [self logoutRequest];
            }
        }else if ([successDic[@"code"] integerValue] == 403) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_PERMISSION_DENIED", nil)];
            successBase(successDic);
        }else {
//            [MBProgressHUD cc_showText:successDic[@"msg"]];
            successBase(successDic);
        }
        
        
        [[self allTasks] removeObject:session];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBase(error);
        
        NSLog(@"请求失败-----%@",error);
        [[self allTasks] removeObject:session];
        
    }];
    [[self allTasks] addObject:session];
    [session resume];
}

#pragma mark - DELETE 删除
- (void)requestDELETEDataWithUrl:(NSString *)url
                   withParamters:(NSDictionary *)params
                         success:(SuccessBlock)successBase
                         failure:(FailureBlock)failureBase
{
    // 设置请求头
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
//    [self.sessionManager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"token"];
    NSLog(@"%@",self.sessionManager.requestSerializer.HTTPRequestHeaders);
    NSMutableDictionary *newparams = [self addBaseObjectToParams:params];
    NSLog(@"url = %@\nparams = %@",url,newparams);

    __block URLSessionTask *session = [self.sessionManager DELETE:url parameters:newparams headers:@{@"token":tokenStr} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *successDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功");
        NSLog(@"url = %@\n %@",task.response.URL,successDic);
        if ([successDic[@"code"] integerValue] == successCodeOK) {
            successBase(successDic);
        }else if ([successDic[@"code"] integerValue] == 401) {
            if (islogOut == NO) {
                islogOut = YES;
                [self logoutRequest];
            }
        }else if ([successDic[@"code"] integerValue] == 403) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"ERROR_PERMISSION_DENIED", nil)];
            successBase(successDic);
        }else {
//            [MBProgressHUD cc_showText:successDic[@"msg"]];
            successBase(successDic);
        }
        [[self allTasks] removeObject:session];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBase(error);
        [[self allTasks] removeObject:session];
        NSLog(@"请求失败-----%@",error);
    }];
    [[self allTasks] addObject:session];
    [session resume];
    
}

#pragma mark - POST 带请求头 头像上传封装
- (void)startPicWithHeaderPostURL:(NSString *)url
                           params:(NSDictionary *)params
                            bodys:(BodysBlock)bodysBase
                         progress:(ProgressBlock)progressBase
                          success:(SuccessBlock)successBase
                          failure:(FailureBlock)failureBase
{
    // 设置请求头
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
//    [self.sessionManager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"token"];
    // 网络超时
    [self.sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.sessionManager.requestSerializer.timeoutInterval = 15.0f;
    [self.sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    // 接受类型
    self.sessionManager.responseSerializer.acceptableContentTypes = [self.sessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"multipart/form-data"];
    
    NSMutableDictionary *newparams = [self addBaseObjectToParams:params];
    NSLog(@"url = %@\nparams = %@",url,newparams);

    __block URLSessionTask *session = [self.sessionManager POST:url parameters:newparams headers:@{@"token":tokenStr} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        bodysBase(formData);
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progressBase(uploadProgress);
        //打印上传进度
        CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        NSLog(@"%.2lf%%", progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *successDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        successBase(successDic);
        [[self allTasks] removeObject:session];
        NSLog(@"url = %@\n %@",task.response.URL,successDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBase(error);
        NSLog(@"cuowushi%@",error);
        [[self allTasks] removeObject:session];
    }];
    [[self allTasks] addObject:session];
    [session resume];
}

// 退出登录网络请求
- (void)logoutRequest {
    [MBProgressHUD cc_showLoading:nil];
    // 登出  现在做的是不管成功与否都 回到登录界面 防止切换了服务器啥的导致没法收到接口回调退步出去和web同步协定改的
//    [MainNetworkRequest logoutRequestParams:@{} success:^(id success) {
//        [self logoutRequestAfter];
//    } failure:^(id failure) {
//        [self logoutRequestAfter];
//    }];
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
    
    self.currentCompany = [SIMCompany new];// 释放公司模型
    self.currentUser.currentCompany = [SIMCompany new];
    self.currentUser = [CCUser new]; // 释放主用户对象
    [self.currentCompany synchroinzeCurrentCompany];
    [self.currentUser synchroinzeCurrentUser];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userToken"]; // 立即清token
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MYCONF"];// 清空我的会议室model
    //    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MYLIVE"];// 清空我的直播间model
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentPlanName"]; // 当前的会议计划名称
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentPlanID"]; // 当前的会议计划名称
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsHaveAdressBook"]; // 是否传了通讯录
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"showTheWechat"];// 是否上线显示微信
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OneConfServerAdress"]; // 链接入会一次性地址 也要删掉 防止链接唤起app被挤掉线
    [self cancleAllRequest];
    
    // 注意！！延时是为了 开会中 账号互踢 被踢出会议时sdk先给的被踢回调 收到被踢就会调用下面的登录界面 之后sdk才走的退会 不退会没法释放当前VC  所以延时2秒 让sdk先释放VC
    [SIMNewEnterConfTool exitTheConf];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 且根视图 返回登录页
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
        
        islogOut = NO;
        
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
- (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    return deviceString;
}




@end
