//
//  NotificationName.m
//  Kaihuibao
//
//  Created by wangxiaoqi on 2017/9/25.
//  Copyright © 2017年 Ferris. All rights reserved.
//

// 编辑我的会议 （编辑我的个人会议室里之后回到教师子页面”我的会议室“刷新）
NSNotificationName const EditMyConfSuccess = @"EditMyConfSuccess";

// 编辑我的直播 （编辑我的个人会议室里之后回到教师子页面”我的会议室“刷新） 
NSNotificationName const EditMyLiveSuccess = @"EditMyLiveSuccess";

// 安排会议--首页 （如果删除或者编辑或者安排都发送通知 刷新界面）
NSNotificationName const EditConfSuccess = @"EditConfSuccess";
// 安排会议--教师详情页面 我的会议室  （如果删除或者编辑或者安排都发送通知 刷新界面）
NSNotificationName const MyConfRoomRefresh = @"MyConfRoomRefresh";

// 安排营销市场客服列表 （如果删除或者编辑或者安排都发送通知 刷新界面）
NSNotificationName const VMVideoListSuccess = @"VMVideoListSuccess";

// 安排直播--首页 （如果删除或者编辑或者安排都发送通知 刷新界面）
NSNotificationName const EditLiveSuccess = @"EditLiveSuccess";
// 安排直播--教师详情页面 我的直播  （如果删除或者编辑或者安排都发送通知 刷新界面）
NSNotificationName const MyEditLiveRefresh = @"MyEditLiveRefresh";

// 安排客服--首页 （如果删除或者编辑或者安排都发送通知 刷新界面）
NSNotificationName const EditVideoServerSuccess = @"EditVideoServerSuccess";

// 安排客服营销--首页 （如果删除或者编辑或者安排都发送通知 刷新界面）
NSNotificationName const EditVideoMarketSuccess = @"EditVideoMarketSuccess";


// 会议服务器连接失败的通知
NSNotificationName const connectSeverce = @"connectSeverce";

// 通知刷新通讯录
NSNotificationName const RefreshContactData = @"RefreshContactData";
// 通知刷新企业成员
NSNotificationName const RefreshCompanyContactData = @"RefreshCompanyContactData";
// 通知刷新设备
NSNotificationName const RefreshDeviceData = @"RefreshDeviceData";
// 通知刷新群组
NSNotificationName const RefreshGroupData = @"RefreshGroupData";


// 直播 新建直播 （如果删除或者编辑或者安排都发送通知 刷新界面）
NSNotificationName const NewLiveSuccess = @"NewLiveSuccess";

// 查询服务器断开连接 重新连接
NSNotificationName const NetWorkReConnect = @"NetWorkReConnect";

// 登录界面 判断网络 重新连接网络的监听
NSNotificationName const NetWorkLoginReConnect = @"NetWorkLoginReConnect";

// 分享的连接 进入会议 调起app
NSNotificationName const EnterConfBYShare = @"EnterConfBYShare";

// 点对点呼叫的接受邀请的通知
NSNotificationName const CallResponResult = @"CallResponResult";

// 如果接听 则回来通知进会
NSNotificationName const CallResultConf = @"CallResultConf";
// 如果接听 则回来通知进会
NSNotificationName const CallAccpectInConf = @"CallAccpectInConf";

// 主叫取消进会
NSNotificationName const CanclCallInConf = @"CanclCallInConf";

// 被叫弹出页面
NSNotificationName const PushTheCalledPage = @"PushTheCalledPage";

// 企业广场搜索的刷新方法 搜索关键词
NSNotificationName const SearchTheSquarePage = @"SearchTheSquarePage";

// 支付成功失败之后刷新列表 -- 计划
NSNotificationName const PayRefreshTheMainPage = @"PayRefreshTheMainPage";

// 支付成功失败之后刷新列表 -- 钱包
NSNotificationName const WalletRefreshTheMainPage = @"WalletRefreshTheMainPage";


// 刷新整个首页面
NSNotificationName const RefreshMainPageData = @"RefreshMainPageData";

// 第三方登录成功之后 获取后台接口后 获得登录信息
NSNotificationName const ThirdLoginGetData = @"ThirdLoginGetData";
