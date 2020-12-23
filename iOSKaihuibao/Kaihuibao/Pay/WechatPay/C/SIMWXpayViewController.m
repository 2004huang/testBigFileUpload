//
//  SIMWXpayViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/10.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMWXpayViewController.h"
#import "SIMChoosePayPlanCell.h"
#import "SIMPayPlanModel.h"
#import "SIMMineOrderCell.h"
#import "SIMWechatModel.h"
#import "SIMHistoryPayOrderController.h"
#import "SIMMainPlanDetailViewController.h"
#import "SIMPayResultAlertView.h"
#import "SIMOrderPayNextViewController.h"
#import "SIMEmptyMineChosCell.h"
#import "SIMChoosePayLiuliangController.h"
#import "SIMPayHistoryModel.h"
#import "SIMFreeNextViewController.h"
#import "SIMOrderNextOtherController.h"
#import "WXApi.h"

@interface SIMWXpayViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    dispatch_queue_t _queueEnter;
    dispatch_group_t _groupEnter;
}

@property (strong,nonatomic) UITableView* tableView;
@property (strong,nonatomic) NSArray* planArr;
@property (strong,nonatomic) NSMutableArray* dataArr;// 不包括隐藏的 -- 原有数组
@property (strong,nonatomic) NSMutableArray* dataAllArr;// 包括隐藏的
@property (nonatomic, strong) SIMWechatModel *wechatPay;
@property (nonatomic, strong) UIButton *gotoBuy;
@property (nonatomic, strong) SIMPayResultAlertView *little;
@property (nonatomic, strong) UIView *backView;// 蒙层
@property (strong,nonatomic) NSMutableArray* minePlan;
@property (assign,nonatomic) NSInteger btnIndex;

@end

static NSString *payindent = @"SIMChoosePayPlanCell";
static NSString *OrderCellind = @"SIMMineOrderCell";
static NSString *emptycell = @"SIMEmptyMineChosCell";

@implementation SIMWXpayViewController
//-(instancetype)init
//{
//    if (self = [super init]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTheDatas) name:PayRefreshTheMainPage object:nil];
//    }
//    return self;
//}
//
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    NSLog(@"wechatpaymaindealloc");
//}
- (void)refreshTheDatas {
    // 数据不同
    if (_pageIndex == 0) {
        // 会议
//        [self requestAllData:@"1"];
        self.navigationItem.title = SIMLocalizedString(@"NPayMainSeverce_titleOne", nil);
        
    }else if (_pageIndex == 1) {
        // 直播
//        [self requestAllData:@"2"];
        self.navigationItem.title = SIMLocalizedString(@"NPayMainSeverce_titleTwo", nil);
        
    }else if (_pageIndex == 2) {
        // 视频客服
//        [self requestAllData:@"3"];
        self.navigationItem.title = SIMLocalizedString(@"NPayMainSeverce_titleThree", nil);
        
    }else if (_pageIndex == 3) {
        // 视频营销
//        [self requestAllData:@"4"];
        self.navigationItem.title = SIMLocalizedString(@"NPayMainSeverce_titleFour", nil);
        
    }
    [self requestAllData:[NSString stringWithFormat:@"%ld",_pageIndex +1]];
    NSLog(@"requestAllData %@",[NSString stringWithFormat:@"%ld",_pageIndex +1]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnIndex = 1;
    // 创建全局队列
    _queueEnter = dispatch_get_global_queue(0, 0);
    _groupEnter = dispatch_group_create();
    
    [self initSubTableView];
    
    _dataArr = [[NSMutableArray alloc] init];
    _dataAllArr = [[NSMutableArray alloc] init];
    _minePlan = [NSMutableArray array];
    [self initDatas];
    
}
- (void)initDatas {
    
//    [self requsetHistoryOrders];
    // 数据不同
    if (_pageIndex == 0) {
        // 会议
//        [self requestAllData:@"1"];
        self.navigationItem.title = SIMLocalizedString(@"NPayMainSeverce_titleOne", nil);
        
    }else if (_pageIndex == 1) {
        // 直播
//        [self requestAllData:@"2"];
        self.navigationItem.title = SIMLocalizedString(@"NPayMainSeverce_titleTwo", nil);
    }else if (_pageIndex == 2) {
        // 企业广场
//        [self requestAllData:@"3"];
        self.navigationItem.title = SIMLocalizedString(@"NPayMainSeverce_titleThree", nil);
    }else if (_pageIndex == 3) {
        // 视频营销
//        [self requestAllData:@"4"];
        self.navigationItem.title = SIMLocalizedString(@"NPayMainSeverce_titleFour", nil);
    }
    [self requestAllData:[NSString stringWithFormat:@"%ld",_pageIndex +1]];
    NSLog(@"requestAllData %@",[NSString stringWithFormat:@"%ld",_pageIndex +1]);
//    else if (_pageIndex == 3) {
//        _planArr = @[
//                     @{@"PlanName":@"Basic4计划",@"PricePlan":@{@"MonthBilling":@0},@"detail":@"个人店铺"},
//                     @{@"planName":@"Pro4计划",@"PricePlan":@{@"MonthBilling":@0},@"PlanDescribe":@"包含所有basic功能小型团队首选"},
//                     @{@"PlanName":@"商业4计划",@"PricePlan":@{@"MonthBilling":@29.0},@"PlanDescribe":@"包含所有Pro功能+中小型企业"},
//                     @{@"PlanName":@"企业4计划",@"PricePlan":@{@"MonthBilling":@894.0},@"PlanDescribe":@"包含所有商业功能+大型企业-预备"}
//                     ];
//    }
//    for (NSDictionary *dic in _planArr) {
//        SIMPayPlanModel *model = [[SIMPayPlanModel alloc] initWithDictionary:dic];
//        [_dataArr addObject:model];
//    }
    
//    [self.tableView reloadData];
}
- (void)initSubTableView {
    // 创建表格
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH - 44) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = TableViewBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    self.tableView.estimatedRowHeight = 60;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[SIMChoosePayPlanCell class] forCellReuseIdentifier:payindent];
    [self.tableView registerClass:[SIMMineOrderCell class] forCellReuseIdentifier:OrderCellind];
    [self.tableView registerClass:[SIMEmptyMineChosCell class] forCellReuseIdentifier:emptycell];
    
    _gotoBuy = [[UIButton alloc] init];
    [_gotoBuy setTitle:SIMLocalizedString(@"NPayMain_NextBnt", nil) forState:UIControlStateNormal];
    [_gotoBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_gotoBuy setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_gotoBuy setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    _gotoBuy.backgroundColor = BlueButtonColor;
    _gotoBuy.titleLabel.font = FontRegularName(18);
    _gotoBuy.layer.masksToBounds = YES;
    _gotoBuy.layer.cornerRadius = 45/2;
    [_gotoBuy addTarget:self action:@selector(pushTheNextPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_gotoBuy];
    [_gotoBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-(BottomSaveH+10));
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(45);
        make.right.mas_equalTo(-15);
    }];
    
}
#pragma mark -- UITableViewDelegate
//设置页眉高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return kWidthScale(60);
    }else {
        return 0.01;
    }
}

//设置分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataArr.count == 0) {
        return 1;
    }else {
        return 2;
    }
    
}
//分区中行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 124;
    }else if (indexPath.section == 1) {
        if (_dataArr.count == 0) {
            return 0.0f;
        }else {
            return UITableViewAutomaticDimension;
        }
        
    }else {
        return 0.0f;
    }
}

//设置单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_minePlan.count == 0) {
            SIMEmptyMineChosCell *conCell = [tableView dequeueReusableCellWithIdentifier:emptycell];
            return conCell;
        }else {
            
            SIMMineOrderCell *conCell = [tableView dequeueReusableCellWithIdentifier:OrderCellind];
              
//            conCell.hismodel = _minePlan[0];
//            __weak typeof(self) weakSelf = self;
//            conCell.btnClick = ^{
//                //点击了历史账单
//                SIMHistoryPayOrderController *hVC = [[SIMHistoryPayOrderController alloc] init];
//                hVC.hisarr = weakSelf.minePlan;
//                [weakSelf.navigationController pushViewController:hVC animated:YES];
//
//            };
//            conCell.liuliangClick = ^{
//                // 点击了充值流量
//                SIMChoosePayLiuliangController *liuliangVC = [[SIMChoosePayLiuliangController alloc] init];
//                [weakSelf.navigationController pushViewController:liuliangVC animated:YES];
//            };
            return conCell;
        }
        
    }else {
        if (_dataArr.count == 0) {
            return nil;
        }else {
            SIMChoosePayPlanCell *commonCell = [tableView dequeueReusableCellWithIdentifier:payindent];
            
            commonCell.arr = _dataArr;
            __weak typeof(self) weakSelf = self;
//            commonCell.btnClick = ^{
//                if (weakSelf.dataArr.count > 0) {
//                    //点击了计划查看
//                    SIMMainPlanDetailViewController *planVC = [[SIMMainPlanDetailViewController alloc] init];
//                    planVC.navigationItem.title = [NSString stringWithFormat:@"%@%@",weakSelf.navigationItem.title,SIMLocalizedString(@"NPayMain_PlanText", nil)];
////                    planVC.pageIndex = weakSelf.pageIndex;
////                    planVC.indexStr = weakSelf.btnIndex;
////                    planVC.dataarr = weakSelf.dataArr;
////                    planVC.dataAllarr = weakSelf.dataAllArr;
//                    [weakSelf.navigationController pushViewController:planVC animated:YES];
//                }else {
//                    [MBProgressHUD cc_showText:@"暂无计划"];
//                }
//            };
            [commonCell setDidClickAtIndex:^(NSInteger buttonIndex) {
                weakSelf.btnIndex = buttonIndex;
            }];
            return commonCell;
        }
        
    }

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (void)pushTheNextPage {
    
    if (_dataArr.count > 0) {
        // 如果是会议计划 以及选择0免费 那么调到vip界面
        if (self.pageIndex == 0) {
            // pageIndex == 0 说明是视频会议 只有视频会议特殊处理
            if (self.btnIndex == 0) {
                // 如果是btnIndex == 0 说明是免费 那么调到特殊vip页面 只有这一个跳到这个页面
                SIMFreeNextViewController *payVC = [[SIMFreeNextViewController alloc] init];
    
                NSMutableArray *aaam = [[NSMutableArray alloc] init];
                [aaam addObject:_dataAllArr[0]];
                [aaam addObject:_dataAllArr[_dataAllArr.count-1]];
                payVC.arr = aaam;
                [self.navigationController pushViewController:payVC animated:YES];
                
            }else {
                // 其他的 不是免费的 那么都跳到订单详情页面
                SIMOrderPayNextViewController *payVC = [[SIMOrderPayNextViewController alloc] init];
                payVC.model = _dataArr[self.btnIndex];
                [self.navigationController pushViewController:payVC animated:YES];
            }
        }else {
            // 说明是视频客服 营销和直播  这三个都是没有免费 直接购买 没有订单页面
//             直接支付
//            SIMPayPlanModel *model = _dataArr[self.btnIndex];
//            [self gotoBuythegood:model];
            // 调到新的支付页面
            SIMOrderNextOtherController *payNewVC = [[SIMOrderNextOtherController alloc] init];
            payNewVC.model = _dataArr[self.btnIndex];
            [self.navigationController pushViewController:payNewVC animated:YES];
        }
//        if (self.btnIndex == 0 && self.pageIndex == 0) {
////
////            [self requestTheFreeDatas];
//
//
//            SIMFreeNextViewController *payVC = [[SIMFreeNextViewController alloc] init];
//
//            NSMutableArray *aaam = [[NSMutableArray alloc] init];
//            [aaam addObject:_dataAllArr[0]];
//            [aaam addObject:_dataAllArr[_dataAllArr.count-1]];
//            payVC.arr = aaam;
//            [self.navigationController pushViewController:payVC animated:YES];
////            [MBProgressHUD cc_showText:@"请至少选择一个计划"];
//        }else {
//            // else全部去支付 其他计划都没有免费的  会议计划也没有免费的
//            SIMOrderPayNextViewController *payVC = [[SIMOrderPayNextViewController alloc] init];
//            payVC.model = _dataArr[self.btnIndex];
//            [self.navigationController pushViewController:payVC animated:YES];
//
//        }
    }else {
        [MBProgressHUD cc_showText:@"暂无计划"];
    }
    
}


// 请求历史订单
- (void)requsetHistoryOrders:(NSString *)signID {
    dispatch_group_enter(_groupEnter);
    [MainNetworkRequest requesetMyPlanChooseResult:nil signid:signID success:^(id success) {
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
        NSLog(@"wechatHistorypayOrderDic   %@",success);
        // 成功
        if ([success[@"status"] isEqualToString:@"ok"]) {
            NSLog(@"请求成功");
            [_minePlan removeAllObjects];
            for (NSDictionary *dic in success[@"list"]) {
                SIMPayHistoryModel *model = [[SIMPayHistoryModel alloc] initWithDictionary:dic];
                [_minePlan addObject:model];
                
            }
//            [self.tableView reloadData];
        }else {
            NSLog(@"请求失败");
        }
        dispatch_group_leave(_groupEnter);
    } failure:^(id failure) {
        dispatch_group_leave(_groupEnter);
        [MBProgressHUD cc_showText:@"请求失败"];
    }];
    
}

- (void)requsetPlanDatas:(NSString *)signID {
    dispatch_group_enter(_groupEnter);
    [MainNetworkRequest requesetPlanChooseResult:nil signid:signID  success: ^(id success) {
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
        NSLog(@"wechatResultpalnnewCheckDic   %@",success);
        // 成功
        if ([success[@"status"] isEqualToString:@"ok"]) {
            NSLog(@"请求成功");
            [_dataArr removeAllObjects];
            [_dataAllArr removeAllObjects];
            for (NSDictionary *dic in success[@"list"]) {
                SIMPayPlanModel *model = [[SIMPayPlanModel alloc] initWithDictionary:dic];
                [_dataAllArr addObject:model];
            }
            for (int i = 0; i<[_dataAllArr count]-1; i++) {
                SIMPayPlanModel *modeling = _dataAllArr[i];
                [_dataArr addObject:modeling];
            }
            
            NSLog(@"_dataAllArr%@_dataArr%@",_dataAllArr,_dataArr);
            
//            [self.tableView reloadData];
        }else {
            NSLog(@"请求失败");
        }
        dispatch_group_leave(_groupEnter);
    } failure:^(id failure) {
        dispatch_group_leave(_groupEnter);
        [MBProgressHUD cc_showText:@"请求失败"];
    }];
}

- (void)requestAllData:(NSString *)signID {
    dispatch_group_async(_groupEnter, _queueEnter, ^{
        [self requsetHistoryOrders:signID];
    });
    dispatch_group_async(_groupEnter, _queueEnter, ^{
        [self requsetPlanDatas:signID];
    });
    
    dispatch_group_notify(_groupEnter, dispatch_get_main_queue(), ^{
        // 返回主线程 刷新UI
        //        dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
//        [self.tableView.mj_header endRefreshing];
        //        });
    });
}


- (void)gotoBuythegood:(SIMPayPlanModel *)model {
    if (![WXApi isWXAppInstalled]) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ThirdLoginNoWechatTitle", nil)];
    }else if (![WXApi isWXAppSupportApi]){
        [MBProgressHUD cc_showText:SIMLocalizedString(@"TopUpwithdraw_noWechat", nil)];
    }else {
        NSString *ss = @"3"; // 其他都判断是年还是月  这里不用判断了 视频客服营销和直播 全部在当前页支付 所以 直接传 2 年的价格
//        if ([[self.model.PricePlan[self.btnIndex] name] isEqualToString:@"月"]) {
//            ss = @"1";
//        }else {
//            ss = @"2";
//        }
        [self weChatGet:ss order:model.serial];
    }
    
}

// 微信支付
- (void)weChatGet:(NSString *)str order:(NSString *)orderstr {
    NSArray *arr = @[orderstr];
    NSString *stri = [arr componentsJoinedByString:@","];
    NSMutableString *string = [[NSMutableString alloc] initWithString:stri];
    [string insertString:@"[" atIndex:0];
    [string insertString:@"]" atIndex:string.length];
    NSLog(@"wechatarrcheckstring%@",string);
    
    
    NSDictionary *dict = @{@"goods_list":string,
                           @"sign":@"3",
                           };
    NSLog(@"wechatpostsuccess   %@",dict);
    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest getWechatPay:dict signid:str success: ^(id success) {
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
        NSLog(@"wechatsuccess   %@",success);
        // 成功
        if ([success[@"status"] isEqualToString:@"ok"]) {
            NSLog(@"----请求成功----");
            _wechatPay = [[SIMWechatModel alloc] initWithDictionary:success[@"detail"]];
            NSLog(@"wechatPayappid  %@",_wechatPay.appid);
            
            
            [[NSUserDefaults standardUserDefaults] setObject:success[@"out_trade_no"] forKey:@"wechatPayOrder"];
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"wechatPayOrderType"];
            // 支付种类  钱包和计划
            [[NSUserDefaults standardUserDefaults] setObject:@"ProjectAdd" forKey:@"ClassOrderType"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self wechatNowPay];
            
        }else {
            [MBProgressHUD cc_showText:@"请求失败"];
            NSLog(@"----请求失败----");
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:@"请求失败"];
    }];
    
}
#pragma mark 微信支付方法

- (void)wechatNowPay{
    //需要创建这个支付对象
    
    PayReq *req   = [[PayReq alloc] init];
    //由用户微信号和AppID组成的唯一标识，用于校验微信用户
    req.openID = _wechatPay.appid;
    
    // 商家id，在注册的时候给的
    req.partnerId = _wechatPay.partnerid;
    
    // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
    req.prepayId  = _wechatPay.prepayid;
    
    // 根据财付通文档填写的数据和签名
    //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
    req.package   = _wechatPay.package;
    
    // 随机编码，为了防止重复的，在后台生成
    req.nonceStr  = _wechatPay.noncestr;
    
    // 这个是时间戳，也是在后台生成的，为了验证支付的
    NSString * stamp = _wechatPay.timestamp;
    req.timeStamp = stamp.intValue;
    NSLog(@"stampone%@",stamp);
    NSLog(@"timeStamptwo%d",req.timeStamp);
    //    NSNumber *ts = [params valueForKey:@"timestamp"];
    //
    //    request.timeStamp = (UInt32) ts.longValue;
    
    // 这个签名也是后台做的
    req.sign = _wechatPay.sign;
    
    //发送请求到微信，等待微信返回onResp
//    [WXApi sendReq:req];
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
    
    //    [self.navigationController popViewControllerAnimated:YES];
}


@end
