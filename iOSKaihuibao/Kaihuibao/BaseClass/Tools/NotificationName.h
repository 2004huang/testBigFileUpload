//
//  NotificationName.h
//  Kaihuibao
//
//  Created by wangxiaoqi on 2017/9/25.
//  Copyright © 2017年 Ferris. All rights reserved.
//


#import <UIKit/UIKit.h>

/** ************************* EditMyConfViewController.m **************************/
// 查询服务器断开连接 重新连接
UIKIT_EXTERN NSNotificationName const NetWorkReConnect;


// 登录界面 判断网络 重新连接网络的监听
UIKIT_EXTERN NSNotificationName const NetWorkLoginReConnect;

// 分享的连接 进入会议 调起app
UIKIT_EXTERN NSNotificationName const EnterConfBYShare;


/** ************************* EditMyConfViewController.m **************************/
UIKIT_EXTERN NSNotificationName const EditMyConfSuccess;

// 编辑我的直播 （编辑我的个人会议室里之后回到教师子页面”我的会议室“刷新）
UIKIT_EXTERN NSNotificationName const EditMyLiveSuccess;

/** ************************* SIMArrangeDetailViewController.m **************************/
// 通知名字 -- 会议列表
UIKIT_EXTERN NSNotificationName const EditConfSuccess;
// 直播
UIKIT_EXTERN NSNotificationName const EditLiveSuccess;
UIKIT_EXTERN NSNotificationName const EditVideoServerSuccess;

// 安排客服营销--首页 （如果删除或者编辑或者安排都发送通知 刷新界面）
UIKIT_EXTERN NSNotificationName const EditVideoMarketSuccess;


// 安排营销市场客服列表 （如果删除或者编辑或者安排都发送通知 刷新界面）
UIKIT_EXTERN NSNotificationName const VMVideoListSuccess;


/** ************************* SIMClassListViewController.m **************************/
UIKIT_EXTERN NSNotificationName const MyConfRoomRefresh;
UIKIT_EXTERN NSNotificationName const MyEditLiveRefresh;


/** ************************* SIMBaseViewController.m **************************/
// 会议服务器连接失败的通知
UIKIT_EXTERN NSNotificationName const connectSeverce;





/** ************************* SIMKeepFitViewController.m **************************/
// 直播 新建直播 （如果删除或者编辑或者安排都发送通知 刷新界面）
UIKIT_EXTERN NSNotificationName const NewLiveSuccess;



/** ************************* SIMCallingViewController.m **************************/
// 点对点呼叫 邀请者收到对方是否接通的通知
UIKIT_EXTERN NSNotificationName const CallResponResult;

/** ************************* SIMNewConverViewController.m **************************/
// 点对点呼叫 邀请者收到对方是否接通的通知
UIKIT_EXTERN NSNotificationName const CallResultConf;

/** ************************* tabbar **************************/
// 点对点呼叫 邀请者收到对方是否接通的通知
UIKIT_EXTERN NSNotificationName const CallAccpectInConf;

/** ************************* tabbar **************************/
// 点对点呼叫 邀请者收到对方是否接通的通知
UIKIT_EXTERN NSNotificationName const CanclCallInConf;

// 被叫弹出界面
UIKIT_EXTERN NSNotificationName const PushTheCalledPage;


// 通知刷新通讯录
UIKIT_EXTERN NSNotificationName const RefreshContactData;
// 通知刷新企业成员
UIKIT_EXTERN NSNotificationName const RefreshCompanyContactData;
// 通知刷新设备
UIKIT_EXTERN NSNotificationName const RefreshDeviceData;
// 通知刷新群组
UIKIT_EXTERN NSNotificationName const RefreshGroupData;



// 企业广场搜索的刷新方法 搜索关键词
UIKIT_EXTERN NSNotificationName const SearchTheSquarePage;

// 支付成功失败之后刷新列表 -- 计划
UIKIT_EXTERN NSNotificationName const PayRefreshTheMainPage;

// 支付成功失败之后刷新列表 -- 钱包
UIKIT_EXTERN NSNotificationName const WalletRefreshTheMainPage;

// 刷新整个首页面
UIKIT_EXTERN NSNotificationName const RefreshMainPageData;

// 第三方登录成功之后 获取后台接口后 获得登录信息
UIKIT_EXTERN NSNotificationName const ThirdLoginGetData;
