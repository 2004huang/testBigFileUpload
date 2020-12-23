//
//  SIMTempCompanyViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/18.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMTempCompanyViewController.h"
#import <WebKit/WebKit.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "SIMShareTool.h"
@interface SIMTempCompanyViewController ()<WKUIDelegate, WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic, strong) NSString *shareUrl;

@end

@implementation SIMTempCompanyViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //重要：注册本地方法
//    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"jumpOut"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 移除对网页进度加载的监听观察者
    [_webView removeObserver:self
                  forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
//    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"jsToOc"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *tempButItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"returnicon"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    tempButItem.imageInsets = UIEdgeInsetsMake(0, -10,0, 0);
    self.navigationItem.leftBarButtonItem = tempButItem;
    
    

    if (self.hasShare && [self.cloudVersion.wechat boolValue]) {
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"邀请联系人"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addShareClick)];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
    if (self.mainShare) {
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"邀请联系人"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(imageShareClick)];
        self.navigationItem.rightBarButtonItem = rightBtn;
    }
    
    _shareUrl = [NSString stringWithFormat:@"%@&awview=0",self.webStr];
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"jsToOc"];
    config.userContentController = userContentController;
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 10.0;
    config.preferences.javaScriptEnabled = YES;
    config.preferences = preferences;
     // 创建WKWebView
     _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH) configuration:config];
     // UI代理
     _webView.UIDelegate = self;
     // 导航代理
     _webView.navigationDelegate = self;
     [self.view addSubview:_webView];
    
    
     // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
     _webView.allowsBackForwardNavigationGestures = YES;
    // WKWebView加载请求
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webStr]]];
    
    //添加监测网页加载进度的观察者
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:0
                      context:nil];
    [self.view addSubview:self.progressView];
    
}
#pragma mark - WKScriptMessageHandler
// WKWebView收到ScriptMessage时回调此方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"name: %@  body: %@",message.name,message.body);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",message.body]]];
}
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if (challenge.previousFailureCount == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }

}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败%@", error.userInfo);
}
-(void)goBack
{
//    if ([self.webView canGoBack]) {
//        [self.webView goBack];
//    }else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    // 可返回的页面列表, 存储已打开过的网页
    WKBackForwardList *backForwardList = [_webView backForwardList];
    if (backForwardList.backList.count > 0) {
        //页面后退
        [_webView goBack];
    }else {
        if (self.isPresent) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
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
- (void)imageShareClick {
#if TypeXviewPrivate
    NSString * iconname = @"share_onzoomicon";
#else
    NSString * iconname = @"share_khbicon";
#endif
    [[SIMShareTool shareInstace] shareToWeChatWithShareStr:self.imageModel.descripStr shareImage:iconname urlStr:self.webStr ShareTitle:self.imageModel.title];
}

- (void)addShareClick {
    NSString *newFaceValue = [NSString stringWithFormat:@"%@%@",kApiBaseUrl,_model.image];
    
    NSLog(@"_webAdress.url %@  %@  %@  %@",self.model.title,self.model.descriptionStr,_shareUrl,newFaceValue);
    SSUIPlatformItem *itemMessage = [[SSUIPlatformItem alloc] init];
    itemMessage.iconNormal = [UIImage imageNamed:@"share_dx"];//默认版显示的图标
    itemMessage.iconSimple = [UIImage imageNamed:@"share_dx"];//简洁版显示的图标
    itemMessage.platformName = SIMLocalizedString(@"ShareInContant", nil);
    itemMessage.platformId = @"message";
    //添加点击事件
    [itemMessage addTarget:self action:@selector(costomPlatFormClick:)];
    
    SSUIPlatformItem *itemBrowser = [[SSUIPlatformItem alloc] init];
    itemBrowser.iconNormal = [UIImage imageNamed:@"share_liulanq"];//默认版显示的图标
    itemBrowser.iconSimple = [UIImage imageNamed:@"share_liulanq"];//简洁版显示的图标
    itemBrowser.platformName = SIMLocalizedString(@"ShareInBrowser", nil);
    itemBrowser.platformId = @"browser";
    
    //添加点击事件
    [itemBrowser addTarget:self action:@selector(costomPlatFormClick:)];
    
    NSArray * platforms =@[ @(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),itemMessage,itemBrowser];

    NSMutableDictionary *shareParams = [[NSMutableDictionary alloc] init];
    [shareParams SSDKSetupShareParamsByText:self.model.descriptionStr
                                     images:newFaceValue
                                        url:[NSURL URLWithString:_shareUrl]
                                      title:self.model.title
                                       type:SSDKContentTypeAuto];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(10, screen_height - 120, screen_width - 20, 100)];
    [self.view addSubview:view];
    [ShareSDK showShareActionSheet:view customItems:platforms shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {

                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:SIMLocalizedString(@"AlertCShareSuccess", nil)
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           NSString *errorStr;
                           if (error.code == 105) {
                               NSLog(@"error%@",error);
                               errorStr = [NSString stringWithFormat:@"%@",SIMLocalizedString(@"AdressBookShareERROR", nil)];
                           }else {
                               errorStr = [NSString stringWithFormat:@"%@",SIMLocalizedString(@"AlertCShareFail", nil)];
                           }
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SIMLocalizedString(@"AlertCShareFail", nil)
                                                                           message:errorStr
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       default:
                           break;
                   }

               }];
}
- (void)costomPlatFormClick:(SSUIPlatformItem *)item
{
    if ([item.platformId isEqualToString:@"browser"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_shareUrl]];// 跳到浏览器
    }else {
        NSString *shareStr = [NSString stringWithFormat:@"%@\n%@ %@",self.model.title,self.model.descriptionStr,_shareUrl];
//        [[SIMShareTool shareInstace] showMessageViewbody:shareStr viewController:self];// 调用发送短信
        [self showMessageViewbody:shareStr viewController:self];
    }
    NSLog(@"点击了通讯录%s,---->%@",__func__,item.platformId);
}
@end
