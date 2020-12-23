//
//  SIMOrderNextOtherController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/12/26.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMOrderNextOtherController.h"
#import "SIMOrderNextOtherCell.h"
#import "SIMOrderTwoCell.h"
#import "SIMOrderNextThreeCell.h"
#import "SIMOrderNextFourCell.h"
#import "WXApi.h"
#import "SIMWechatModel.h"

@interface SIMOrderNextOtherController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView* tableView;
@property (strong,nonatomic) UIButton* gotoBuy;
@property (nonatomic, strong) SIMWechatModel *wechatPay;
@end
static NSString *oneCell = @"SIMOrderNextOtherCell";
static NSString *twoCell = @"SIMOrderTwoCell";
static NSString *threeCell = @"SIMOrderNextThreeCell";
static NSString *fourCell = @"SIMOrderNextFourCell";

@implementation SIMOrderNextOtherController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = SIMLocalizedString(@"NPayAllNext_Title", nil);
    NSLog(@"paymodelname%@",self.model.PlanName);
    
    [self initSubTableView];
    
}

- (void)initSubTableView {
    // 创建表格
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH - 60) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedRowHeight = 60;
    //    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 10)];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[SIMOrderNextOtherCell class] forCellReuseIdentifier:oneCell];
    [self.tableView registerClass:[SIMOrderTwoCell class] forCellReuseIdentifier:twoCell];
    [self.tableView registerClass:[SIMOrderNextThreeCell class] forCellReuseIdentifier:threeCell];
    [self.tableView registerClass:[SIMOrderNextFourCell class] forCellReuseIdentifier:fourCell];
    
    
    _gotoBuy = [[UIButton alloc] initWithFrame:CGRectMake(15, kWidthScale(7.5), screen_width - 30, 45)];
    [_gotoBuy setTitle:SIMLocalizedString(@"NPayMain_PayLast", nil) forState:UIControlStateNormal];
    [_gotoBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_gotoBuy setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_gotoBuy setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    _gotoBuy.backgroundColor = BlueButtonColor;
    _gotoBuy.titleLabel.font = FontRegularName(18);
    _gotoBuy.layer.masksToBounds = YES;
    _gotoBuy.layer.cornerRadius = 45/2;
    [_gotoBuy addTarget:self action:@selector(gotoBuythegood) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_gotoBuy];
    [_gotoBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-(BottomSaveH + 10));
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(45);
        make.right.mas_equalTo(-15);
    }];
    
}
- (void)gotoBuythegood {
    if (![WXApi isWXAppInstalled]) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ThirdLoginNoWechatTitle", nil)];
        
    }else if (![WXApi isWXAppSupportApi]){
        [MBProgressHUD cc_showText:SIMLocalizedString(@"TopUpwithdraw_noWechat", nil)];
    }else {
        NSString *ss = @"3"; // 其他都判断是年还是月  这里不用判断了 视频客服营销和直播 全部在当前页支付 所以 直接传 2 年的价格
        [self weChatGet:ss order:self.model.serial];
    }
    
}

#pragma mark -- UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 10)];
    view.backgroundColor = ZJYColorHex(@"#f4f3f3");
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

//设置分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//分区中行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.model.sign intValue] == 2) {
        // 直播 是3个没介绍  客服和营销都有介绍
        return 3;
    }else {
        return 4;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 115;
    }else {
        return UITableViewAutomaticDimension;
    }
}

//设置单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        SIMOrderTwoCell *conCell = [tableView dequeueReusableCellWithIdentifier:twoCell];
        conCell.model = self.model;
        return conCell;
    }else if (indexPath.row == 1) {
        SIMOrderNextOtherCell *commonCell = [tableView dequeueReusableCellWithIdentifier:oneCell];
        commonCell.model = self.model;
        return commonCell;
    }
    else if (indexPath.row == 2){
        SIMOrderNextThreeCell *theCell = [tableView dequeueReusableCellWithIdentifier:threeCell];
        theCell.model = self.model;
        return theCell;
    }else {
        if ([self.model.sign intValue] == 2) {
            // 直播 是3个没介绍  客服和营销都有介绍
             return nil;
        }else {
            SIMOrderNextFourCell *fouCell = [tableView dequeueReusableCellWithIdentifier:fourCell];
            if ([self.model.sign intValue] == 3) {
                fouCell.urlStr = @"多渠道触达用户 / 一键进入视频营销界面\n无需下载APP / 减少繁琐操作/客户低流失\n一对多在线客服 / 革新传统在线客服形式\n多项AI功能无缝接入 / 视频营销更多惊喜\n文字/音视频/文件展示 / 产品解说更详细\n自动识别关键字 / 专业话术模板及时回复";
            }else if ([self.model.sign intValue] == 4) {
                fouCell.urlStr = @"智能机器人多形式服务 / 每天轻松应对客户\n多种形式智能营销 / 7*24小时无间断推广\n多角度接入直播 / 产品展示更流畅\n多样化直播界面 / 均支持立即付款\n平台化模板规划 / 更多增值服务延伸";
            }
            return fouCell;
        }
        
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
