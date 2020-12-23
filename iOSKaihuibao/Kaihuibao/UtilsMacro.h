//
//  UtilsMacro.h
//  SIMChat
//
//  Created by Ferris on 15/8/15.
//  Copyright (c) 2015年 Ferris. All rights reserved.
//
#ifndef UtilsMacro_h
#define UtilsMacro_h

/*
* 三方sdk相关key和appID
*/
#define PrivateRequestType @"publicTYPE"
#define BuglyAPPID @"ddaca0b4e1"
#define AMapAPPID @"2f836dda6fa49c587c27960fe9a5a54f"

#if TypeKaihuibao
#define APP_storeID @"1231422672"
#define APPWechatTitle @"wechat_yhy"
#define APPNameTitle @"khbyhy"
#define ThreePlantID @"2"
#define WeichatAPPID @"wxd2d7ac44d428db3b" //@"wxd2d7ac44d428db3b" //@"wx12db0878d5cdeff0"
#define WeichatAPPSecret @"37bf853d6256074bd7bff78b03b9ec62" //@"37bf853d6256074bd7bff78b03b9ec62" //@"a233821c6011deea6a44d20233dacc6d" 36844DC89328CF863CEB8667FFE58F4E

#define QQAPPID @"101699047"
#define QQAPPSecret @"8fced2eed811ecb8b45f6376b2a34999"
#define TengXunIMAPPIDDebug 14316
#define TengXunIMAPPIDRelease 14315
#define JoinPageURL @"znkhbjoin"
#define HomePageURL @"kaihuibao"
#define EnterConfURL @"znkhb"
#define WXuniversalLink @"https://wx12db0878d5cdeff0/"

#elif TypeVideoBao
#define APP_storeID @"1170421091"
#define APPWechatTitle @"wechat"
#define APPNameTitle @"khb"
#define ThreePlantID @"1"
#define WeichatAPPID @"wx1ec3066f701c018b"
#define WeichatAPPSecret @"00b27c5a78b4ecd444c5b8680a869fc9"
#define QQAPPID @"101578614"
#define QQAPPSecret @"be2d18cd74619cf841154875b5be678d"
#define TengXunIMAPPIDDebug 14005
#define TengXunIMAPPIDRelease 14002
#define JoinPageURL @"znkhbjoin"
#define HomePageURL @"kaihuibao"
#define EnterConfURL @"znkhb"
#define WXuniversalLink @"https://www.vytalk.com/" //暂用vytalk的

#elif TypeClassBao
#define APP_storeID @"1273688173"
#define APPWechatTitle @"wechat_skb"
#define APPNameTitle @"skb"
#define ThreePlantID @"3"
#define WeichatAPPID @"wxd951035cc1889308"
#define WeichatAPPSecret @"4524aa7c0a83fe5346696a73eae76ce6"
#define QQAPPID @"1106544248"
#define QQAPPSecret @"2fcHMvy3jRdNfhIN"
#define TengXunIMAPPIDDebug 14316
#define TengXunIMAPPIDRelease 14315
#define JoinPageURL @"shangkebaojoin"
#define HomePageURL @"shangkebaohome"
#define EnterConfURL @"shangkebao"
#define WXuniversalLink @"https://www.vytalk.com/" //暂用vytalk的

#elif TypeJianshenBao
#define APP_storeID @"1302780962"
#define APPWechatTitle @"wechat_jsb"
#define APPNameTitle @"jsb"
#define ThreePlantID @"5"
#define WeichatAPPID @"wx8d0f9ce321c1f29d"
#define WeichatAPPSecret @"a414d2c33f95e3d99b309038052353b5"
#define QQAPPID @"1105890545"
#define QQAPPSecret @"107z3efNOxdaAQ8M"
#define TengXunIMAPPIDDebug 14316
#define TengXunIMAPPIDRelease 14315
#define JoinPageURL @"umefitjoin"
#define HomePageURL @"umefithome"
#define EnterConfURL @"umefit"
#define WXuniversalLink @"https://www.vytalk.com/" //暂用vytalk的

#elif TypeXviewPrivate
#define APP_storeID @"1500546957"
#define APPWechatTitle @"wechat_vymeet"
#define APPNameTitle @"vymeet"
#define ThreePlantID @"4"
#define WeichatAPPID @"wx9dff42f2428099c1"
#define WeichatAPPSecret @"91e973c3f7ea6067598207d07013ad3a"
#define QQAPPID @"101852354"
#define QQAPPSecret @"8c9822ae37edac204a815bfc599b4223"
#define TengXunIMAPPIDDebug 14316
#define TengXunIMAPPIDRelease 14315
#define JoinPageURL @"vymeethome"
#define HomePageURL @"vymeetjoin"
#define EnterConfURL @"znvymeet"
#define WXuniversalLink @"https://www.vytalk.com/" 


#elif TypeMeeLike   //所有数据暂时用的onzoom的
#define APP_storeID @"1500546957"
#define APPWechatTitle @"wechat_vymeet"
#define APPNameTitle @"vymeet"
#define ThreePlantID @"4"
#define WeichatAPPID @"wx9dff42f2428099c1"
#define WeichatAPPSecret @"91e973c3f7ea6067598207d07013ad3a"
#define QQAPPID @"101852354"
#define QQAPPSecret @"8c9822ae37edac204a815bfc599b4223"
#define TengXunIMAPPIDDebug 14316
#define TengXunIMAPPIDRelease 14315
#define JoinPageURL @"umefitjoin"
#define HomePageURL @"umefithome"
#define EnterConfURL @"umefit"
#define WXuniversalLink @"https://www.vytalk.com/"


#endif

/*
 *接口code值 请求成功的值
 */
#define successCodeOK  1
/*
 *服务器地址和端口的设置
 */
//47.92.168.111

#define kApiBaseUrl [NSString stringWithFormat:@"%@://%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"NEWHttpNetString"], [[NSUserDefaults standardUserDefaults] objectForKey:@"NEWHostNetString"], [[NSUserDefaults standardUserDefaults] objectForKey:@"NEWPortNetString"]]

#define DefaultApiBaseHttp @"https"
#define DefaultApiBasePort @""

#if TypeKaihuibao
#define DefaultApiBaseHost @"www.kaihuibao.net"
#define HKApiBaseHost @"hk.vytalk.com"
#elif TypeVideoBao
#define DefaultApiBaseHost @"Vytalk.com"
#define HKApiBaseHost @"hk.vytalk.com"
#elif TypeClassBao
#define DefaultApiBaseHost @"www.shangkebao.net"
#define HKApiBaseHost @"hk.shangkebao.net"
#elif TypeJianshenBao
#define DefaultApiBaseHost @"www.umefit.com"
#define HKApiBaseHost @"hk.vytalk.com"
#elif TypeXviewPrivate
#define DefaultApiBaseHost @"www.vymeet.com"
#define HKApiBaseHost @"hk.vytalk.com"

#elif TypeMeeLike
#define DefaultApiBaseHost @"www.vymeet.com"
#define HKApiBaseHost @"hk.vytalk.com"


#endif

#define ApplicationDelegate  ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define EnableLog YES
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define RGB(r, g, b)                        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define rgba(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HEXCOLOR(c)                         [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]
// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/**
 *颜色值 十六进制转换成uicolor
 */
#define ZJYColorHex(hexValue) [UIColor colorWithHexString:hexValue]
#define ZJYColorHexWithAlpha(hexValue,alphaValue) [UIColor colorWithHexString:hexValue withAlpha:alphaValue]
// 3.是否为4inch
#define fourInch ([UIScreen mainScreen].bounds.size.height == 568)

#define kMaxLength 30
#define kMinLength 20

// 4.屏幕大小尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

// 比例适配
#define kWidthScale(value) [UIScreen mainScreen].bounds.size.width/375*value
#define kHeightScale(value) [UIScreen mainScreen].bounds.size.width/667*value
// iphoneX
#define kHeightScaleX ((kScreenHeight == IPHONE_X_HEIGHT) ? 1 : (kScreenHeight / 667.0))

// 比例适配 ipad
#define IS_IPAD     [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#define kWS(value) (([UIScreen mainScreen].bounds.size.width-200)/375*value)
#define kWidthS(value) (IS_IPAD ? (value) :([UIScreen mainScreen].bounds.size.width/375*value))

// iPhoneX高度
#define  IPHONE_X_HEIGHT 812
// 获取Nav高度
#define NavH 44
// 判断刘海屏幕已确定是不是iphoneX以及之后的机型
#define isIPhoneXAll ([[UIApplication sharedApplication] statusBarFrame].size.height == 44)
// 适配iphoneX导航加状态栏高度
#define StatusNavH (isIPhoneXAll ? 88 : 64)
// 获取状态栏高度
#define StatusBarH (isIPhoneXAll ? 44 : 20)
// 获取底部安全区域的高度
#define BottomSaveH (isIPhoneXAll ? 34 : 0)
// 获取头部安全区域的高度
#define TopSaveH (isIPhoneXAll ? 24 : 0)
//tabbar高度
#define TabbarH     (isIPhoneXAll ? 83 : 49)

// 聊天更多 view
#define HEIGHT_CHATBOXVIEW  215

#define getApp_Version [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define getApp_ownVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define windowRootViewController [UIApplication sharedApplication].delegate.window.rootViewController

#define kLanguage @"appLanguage"

// 本地化的方法
#define SIMLocalizedString(key, comment) [[SIMInternationalController bundle] localizedStringForKey:key value:comment table:@"Localizable"]

//重新设定view的Y值
#define setFrameY(view, newY) view.frame = CGRectMake(view.frame.origin.x, newY, view.frame.size.width, view.frame.size.height)
#define setFrameX(view, newX) view.frame = CGRectMake(newX, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
#define setFrameH(view, newH) view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, newH)
#define setFrameW(view, newW) view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, newW, view.frame.size.height)

//取view的坐标及长宽
#define W(view)    view.frame.size.width
#define H(view)    view.frame.size.height
#define X(view)    view.frame.origin.x
#define Y(view)    view.frame.origin.y
//字符串
#define FtoS(floatNum) [NSString stringWithFormat:@"%f",floatNum]
#define FontAttribute(color,fontSize) [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName,[mainFont fontWithSize:fontSize], NSFontAttributeName,nil]

#define StringFontAttribute(fontSize) [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,[[UIFont preferredFontForTextStyle:UIFontTextStyleBody] fontWithSize:fontSize], NSFontAttributeName,nil]
/**
 *  项目相关
 */
//#define BlueButtonColor  ZJYColorHex(@"#32b5f2") // 新的蓝主色348ffb 原来的2d8cff  改为348ffb

//#define BlueColor RGB(52,143,251)
#define RedButtonColor  ZJYColorHex(@"#fe5255")// 红色按钮
#define DarkBlackNavBarColor ZJYColorHex(@"#424556") // 导航色
#define HightLightRedButtonColor ZJYColorHex(@"#b22222")// 点击红色按钮变得色
#define HightLightButtonTitleColor ZJYColorHex(@"#d9d9d9")// 点击按钮文字变得色
#define OrangeButtonColor  ZJYColorHex(@"#eebd46")// 支付界面用的橙色
#define LowOrangeButtonColor  ZJYColorHex(@"#fff2d2")// 支付界面用的浅橙色
#define TextOrangeColor  ZJYColorHex(@"#f1c964")// 支付界面用的文字橙色
#define DarkBlackNavBarFontColor RGB(52,52,52)
#define TableViewBackgroundColor ZJYColorHex(@"#FAFAFA")//开会宝表格背景颜色
#define BabyBlueButtonColor  ZJYColorHex(@"#b6d4ff")//浅蓝色
#define BabyBlue1ButtonColor  ZJYColorHex(@"#1c77fc")//浅蓝色

#if TypeKaihuibao || TypeVideoBao
#define BlueButtonColor  ZJYColorHex(@"#227bff")//主色 #2d8cff原来是这个
#define EnableButtonColor ZJYColorHex(@"#a3c1ef") // 加入会议的禁用蓝色
#define HightLightButtonColor ZJYColorHex(@"#2c7ad6")// 点击蓝色按钮变得色
#define TabbarBtnNormalColor ZJYColorHex(@"#666666")// tabbar未选中
#define TabbarBtnSelectColor ZJYColorHex(@"#227bff")// tabbar选中

#elif TypeClassBao
#define BlueButtonColor  ZJYColorHex(@"#3ac17e")//主色
#define EnableButtonColor ZJYColorHex(@"#9adebc") // 加入会议的禁用蓝色
#define HightLightButtonColor ZJYColorHex(@"#0d923e")// 点击蓝色按钮变得色
#define TabbarBtnNormalColor ZJYColorHex(@"#666666")// tabbar未选中
#define TabbarBtnSelectColor ZJYColorHex(@"#3ac17e")// tabbar选中

#elif TypeJianshenBao
#define BlueButtonColor  ZJYColorHex(@"#A653C0")//主色
#define EnableButtonColor ZJYColorHex(@"#DBC6F7") // 加入会议的禁用紫色
#define HightLightButtonColor ZJYColorHex(@"#7F58B9")// 点击蓝色按钮变得色
#define TabbarBtnNormalColor ZJYColorHex(@"#DBC6F7")// tabbar未选中
#define TabbarBtnSelectColor ZJYColorHex(@"#7F58B9")// tabbar选中

#elif TypeXviewPrivate
#define BlueButtonColor  ZJYColorHex(@"#217cfe")//主色


#define EnableButtonColor ZJYColorHex(@"#a3c1ef") // 加入会议的禁用紫色
#define HightLightButtonColor ZJYColorHex(@"#2c7ad6")// 点击蓝色按钮变得色
#define TabbarBtnNormalColor ZJYColorHex(@"#666666")// tabbar未选中
#define TabbarBtnSelectColor ZJYColorHex(@"#1833ff")// tabbar选中

#elif TypeMeeLike
#define BlueButtonColor  ZJYColorHex(@"#A653C0")//主色
#define EnableButtonColor ZJYColorHex(@"#DBC6F7") // 加入会议的禁用紫色
#define HightLightButtonColor ZJYColorHex(@"#7F58B9")// 点击蓝色按钮变得色
#define TabbarBtnNormalColor ZJYColorHex(@"#DBC6F7")// tabbar未选中
#define TabbarBtnSelectColor ZJYColorHex(@"#7F58B9")// tabbar选中


#endif

#define GrayPromptTextColor ZJYColorHex(@"#999999")// cell上detail颜色文字
#define TableViewHeaderColor ZJYColorHex(@"#666666")// 页眉颜色文字
#define BlackTextColor ZJYColorHex(@"#333333")// cell主文字颜色
#define SearchBackColor ZJYColorHex(@"#EEEEEE")// 搜索框背景颜色
#define NewBlackTextColor ZJYColorHex(@"#000000")// 新版的黑色文字颜色

#define FontRegularName(fontSize) [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize]
#define FontMediumName(fontSize) [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize]


#pragma mark - Path
#define     PATH_DOCUMENT                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]


#ifndef weakify
#if __has_feature(objc_arc)

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#else

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
_Pragma("clang diagnostic pop")

#endif
#endif

#ifndef strongify
#if __has_feature(objc_arc)

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")

#else

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __block_##x##__; \
_Pragma("clang diagnostic pop")

#endif
#endif



#endif

//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG

#define NSLog(format, ...) do {                                             \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)
#define NSLogRect(rect) NSLog(@"%s x:%.4f, y:%.4f, w:%.4f, h:%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define NSLogSize(size) NSLog(@"%s w:%.4f, h:%.4f", #size, size.width, size.height)
#define NSLogPoint(point) NSLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)
#else
#define NSLog(FORMAT, ...) nil
#define NSLogRect(rect) nil
#define NSLogSize(size) nil
#define NSLogPoint(point) nil
#endif

