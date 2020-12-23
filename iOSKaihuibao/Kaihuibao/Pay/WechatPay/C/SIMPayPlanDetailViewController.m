//
//  SIMPayPlanDetailViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/11.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMPayPlanDetailViewController.h"
#import "SIMChoosePayPlanCell.h"
#import "SIMPlanDetailCell.h"
#import "SIMWechatModel.h"
#import "SIMHistoryPayOrderController.h"
//#import "SIMMainPlanDetailViewController.h"
#import "SIMPlanDetailHeader.h"
#import "SIMOrderPayNextViewController.h"
#import "SIMFreeNextViewController.h"
#import "WXApi.h"
#import "SIMOrderNextOtherController.h"

@interface SIMPayPlanDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView* tableView;
@property (strong,nonatomic) NSArray* planArr;
@property (strong,nonatomic) NSMutableArray* dataArr;
@property (nonatomic, strong) SIMWechatModel *wechatPay;
@property (nonatomic, strong) UIButton *gotoBuy;
@property (nonatomic, strong) SIMPlanDetailHeader *header;

@end
static NSString *OrderCellind = @"SIMPlanDetailCell";
@implementation SIMPayPlanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"nextPicDetailModel%@",self.model);
    [self initSubTableView];
}
- (void)initSubTableView {
    // 创建表格
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH - 40 - 55) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    //    [self.tableView setSeparatorColor:ZJYColorHex(@"#eeeeee")];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    self.tableView.estimatedRowHeight = 60;
//    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 10)];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[SIMPlanDetailCell class] forCellReuseIdentifier:OrderCellind];
    _header = [[SIMPlanDetailHeader alloc] initWithFrame:CGRectMake(0, 0, screen_width, kWidthScale(170))];
    _header.urlStr = self.model.PlanCoverImg;
    self.tableView.tableHeaderView = _header;
    
    _gotoBuy = [[UIButton alloc] init];
    [_gotoBuy setTitle:SIMLocalizedString(@"NPayMain_NextBnt", nil) forState:UIControlStateNormal];
    [_gotoBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_gotoBuy setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_gotoBuy setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    
    _gotoBuy.layer.masksToBounds = YES;
    _gotoBuy.layer.cornerRadius = 45/2;
    _gotoBuy.backgroundColor = BlueButtonColor;
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 10)];
    view.backgroundColor = [UIColor whiteColor];

    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
        return 0.01;
    
}

//设置分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//分区中行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.PlanDetailImg.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.model.PlanDetailImg[indexPath.row];
    CGFloat hei = [[dic objectForKey:@"height"] floatValue]/2;
    return kWidthScale(hei);
}

//设置单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMPlanDetailCell *conCell = [tableView dequeueReusableCellWithIdentifier:OrderCellind];
    conCell.urlStr = [self.model.PlanDetailImg[indexPath.row] objectForKey:@"name"];
    return conCell;
}
- (void)dealloc {
    NSLog(@"fdfadf哈哈哈afd就解决88888afdfsfdsfd");
}

- (void)pushTheNextPage {
    
    if (self.model != nil) {
        if (self.pageIndex == 0) {
            if (self.indexStr == 0) {
//                [MBProgressHUD cc_showText:@"您目前为该计划，请选择升级计划"];
                SIMFreeNextViewController *payVC = [[SIMFreeNextViewController alloc] init];
                NSMutableArray *aaam = [[NSMutableArray alloc] init];
                [aaam addObject:_model];
                [aaam addObject:_modelLast];
                payVC.arr = aaam;
                [self.navigationController pushViewController:payVC animated:YES];
            }else {
                SIMOrderPayNextViewController *payVC = [[SIMOrderPayNextViewController alloc] init];
//                payVC.model = self.model;
                [self.navigationController pushViewController:payVC animated:YES];
            }
        }else {
            // 直接支付
//            [self gotoBuythegood:self.model];
            // 调到新的支付页面
            SIMOrderNextOtherController *payNewVC = [[SIMOrderNextOtherController alloc] init];
            payNewVC.model = self.model;
            [self.navigationController pushViewController:payNewVC animated:YES];
        }
    }else {
        [MBProgressHUD cc_showText:@"暂无计划"];
    }
    
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
    
    // 固定sign是3
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
