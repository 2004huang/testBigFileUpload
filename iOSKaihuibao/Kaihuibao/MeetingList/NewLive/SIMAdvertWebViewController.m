//
//  SIMLiveInterestingViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/9/15.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMAdvertWebViewController.h"
//#import "WebviewProgressLine.h"
#import <WebKit/WebKit.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import "SIMAdressBookViewController.h"


@interface SIMAdvertWebViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic,strong) UIProgressView *progressView;

@end

@implementation SIMAdvertWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 发现界面带分享按钮
    UIBarButtonItem *rbut=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"会议_03"] style:UIBarButtonItemStylePlain target:self action:@selector(moreClick)];
    self.navigationItem.rightBarButtonItem=rbut;
    UIBarButtonItem *tempButItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"returnicon"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    tempButItem.imageInsets = UIEdgeInsetsMake(0, -10,0, 0);

    self.navigationItem.leftBarButtonItem = tempButItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 创建WKWebView
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH) configuration:config];
    // WKWebView加载请求
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webStr]]];
    [self.view addSubview:_webView];
    // UI代理
    _webView.UIDelegate = self;
    // 导航代理
    _webView.navigationDelegate = self;
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    _webView.allowsBackForwardNavigationGestures = YES;
   

    
    //添加监测网页加载进度的观察者
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:0
                      context:nil];
    //添加监测网页标题title的观察者
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.view addSubview:self.progressView];
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//    if (@available(iOS 12.0, *))
//    {//iOS11也有这种获取方式，但是我使用的时候iOS11系统可以在response里面直接获取到，只有iOS12获取不到
//        WKHTTPCookieStore *cookieStore = _webView.configuration.websiteDataStore.httpCookieStore;
//        [cookieStore getAllCookies:^(NSArray* cookies) {
//            //            [self setCookie:cookies];
//            NSLog(@"cookiescookies12222 %@",cookies);
//        }];
//    }else {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
        NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
        NSLog(@"cookiescookies1111 %@",cookies);
//        [self setCookie:cookies];
//    }
}
//kvo 监听进度 必须实现此方法
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == _webView) {
//        NSLog(@"网页加载进度 = %f",_webView.estimatedProgress);
        self.progressView.progress = _webView.estimatedProgress;
        if (_webView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
    }else if([keyPath isEqualToString:@"title"]
             && object == _webView){
        self.navigationItem.title = _webView.title;
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除观察者
    [_webView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [_webView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(title))];
}

-(void)goBack
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)costomPlatFormClick:(SSUIPlatformItem *)item
{
//    //自定义item被点击的处理逻辑
//    SIMAdressBookViewController *adressBook = [[SIMAdressBookViewController alloc] init];
//    adressBook.shareType = self.webTypeShare;// 开会为1005或者1006
//    adressBook.webAdress = self.webAdress;
//    [self.navigationController pushViewController:adressBook animated:YES];
//
//    NSLog(@"点击了通讯录%s,---->%@",__func__,item.platformId);
//    // do ......
}

// 导航右按钮点击事件
-(void)moreClick {
//    [self shareContentMethod];
}
//- (void)shareContentMethod {
//    SSUIPlatformItem *itemMessage = [[SSUIPlatformItem alloc] init];
//    itemMessage.iconNormal = [UIImage imageNamed:@"share_dx.png"];//默认版显示的图标
//    itemMessage.iconSimple = [UIImage imageNamed:@"share_dx.png"];//简洁版显示的图标
//    itemMessage.platformName = SIMLocalizedString(@"ShareInContant", nil);
//    itemMessage.platformId = SIMLocalizedString(@"ShareInContant", nil);
//    //添加点击事件
//    [itemMessage addTarget:self action:@selector(costomPlatFormClick:)];
////    __weak typeof(self) weakSelf = self;
////    SSUIShareActionSheetCustomItem *itemMessage = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"share_dx.png"] label:SIMLocalizedString(@"ShareInContant", nil) onClick:^{
////        //自定义item被点击的处理逻辑
////        SIMAdressBookViewController *adressBook = [[SIMAdressBookViewController alloc] init];
////        adressBook.shareType = weakSelf.webTypeShare;// 开会为1005或者1006
////        adressBook.webAdress = weakSelf.webAdress;
////        [weakSelf.navigationController pushViewController:adressBook animated:YES];
////
////    }];
//    NSString *messStr;
//    NSString *imageStr;
////    if (_webTypeShare == 1005) {
//        // 发现页
//        messStr = _webAdress.detail;
//        imageStr = @"share_clickshare";
////    }else if (_webTypeShare == 1006) {
////        messStr = @"每月低至9.9元，每年节约几十万差旅费，视频会议随时开";
////        imageStr = @"share_device_find";
////    }
//    NSLog(@"_webAdress.url_webAdress.url%@",_webAdress.url);
//    // 获取web的url  便利去掉app = app
//    NSString *urlSs = _webAdress.url;
//
//    if ([urlSs containsString:@"list/boss"]) {
//        NSLog(@"老板理财");
//        urlSs = [NSString stringWithFormat:@"https://www.kaihuibao.net/app/list/boss.html?app=app&userToken=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]];
//
//    }else {
//        urlSs = _webAdress.url;
//    }
//
//    NSString *stringFin = [urlSs stringByReplacingOccurrencesOfString:@"app=app" withString:@"app="];
//
//    NSLog(@"stringFinstringFinstringFin    %@",stringFin);
//    NSArray * platforms =@[@(SSDKPlatformSubTypeQQFriend),
//                           @(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),itemMessage];
//
//    NSMutableDictionary *shareParams = [[NSMutableDictionary alloc] init];
//    [shareParams SSDKSetupShareParamsByText:messStr
//                                     images:[UIImage imageNamed:imageStr]
//                                        url:[NSURL URLWithString:stringFin]
//                                      title:messStr
//                                       type:SSDKContentTypeAuto];
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(10, screen_height - 120, screen_width - 20, 100)];
//    [self.view addSubview:view];
//    [ShareSDK showShareActionSheet:view customItems:platforms shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//
//                   switch (state) {
//                       case SSDKResponseStateSuccess:
//                       {
//                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:SIMLocalizedString(@"AlertCShareSuccess", nil)
//                                                                               message:nil
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil];
//                           [alertView show];
//                           break;
//                       }
//                       case SSDKResponseStateFail:
//                       {
//                           NSString *errorStr;
//                           if (error.code == 105) {
//                               NSLog(@"error%@",error);
//                               errorStr = [NSString stringWithFormat:@"%@",SIMLocalizedString(@"AdressBookShareERROR", nil)];
//                           }else {
//                               errorStr = [NSString stringWithFormat:@"%@",SIMLocalizedString(@"AlertCShareFail", nil)];
//                           }
//                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SIMLocalizedString(@"AlertCShareFail", nil)
//                                                                           message:errorStr
//                                                                          delegate:nil
//                                                                 cancelButtonTitle:@"OK"
//                                                                 otherButtonTitles:nil, nil];
//                           [alert show];
//                           break;
//                       }
//                       default:
//                           break;
//                   }
//
//               }];
//}

- (UIProgressView *)progressView {
    if (!_progressView) {
        
        //进度条高度不可修改
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 2)];
        
        //设置进度条的颜色
        _progressView.progressTintColor = BlueButtonColor;
        
        _progressView.progressViewStyle = UIProgressViewStyleDefault;
    }
    return _progressView;
}

@end
