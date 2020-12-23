//
//  SIMFreeNextViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/11/1.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMFreeNextViewController.h"
#import "SIMOrderOneCell.h"
#import "SIMOrderThreeCell.h"
//#import "OKActionSheetView.h"
#import "SIMFPNextHeader.h"
#import "SIMPayPlanModel.h"
#import "SIMFreeNextCell.h"
#import "SIMFreeNewVipTableViewCell.h"
#import "SIMOrderPayNextViewController.h"
#import "WXApi.h"
#import "SIMWechatModel.h"

@interface SIMFreeNextViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView* tableView;
@property (strong,nonatomic) UIButton* gotoBuy;
@property (strong,nonatomic) NSArray* arrdata;
@property (strong,nonatomic) NSArray* picarrdata;
@property (assign,nonatomic) NSInteger btnIndex;
@property (nonatomic, strong) SIMWechatModel *wechatPay;

@end
static NSString *oneCell = @"SIMFreeNextCell";
static NSString *threeCell = @"SIMOrderThreeCell";
static NSString *bottomCell = @"SIMFreeNewVipTableViewCell";
@implementation SIMFreeNextViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = SIMLocalizedString(@"NPayAllNext_Title", nil);
    NSLog(@"freearr%@",self.arr);
    _btnIndex = 1;
    [self initSubTableView];
    SIMPayPlanModel*model = self.arr[1];
    if ([model.sign intValue] == 1) {
        //视频会议
        _arrdata = @[@{@"namestr":@"允许8人参会",@"picstr":@"conf_huiyi"},@{@"namestr":@"语音识别",@"picstr":@"conf_shibie"},@{@"namestr":@"智能翻译助手",@"picstr":@"conf_translate"},@{@"namestr":@"会议速记",@"picstr":@"conf_suji"},@{@"namestr":@"无限制视频通话",@"picstr":@"conf_tonghua"},@{@"namestr":@"直播连麦",@"picstr":@"conf_lianmai"},@{@"namestr":@"支持1v1会议",@"picstr":@"conf_duifuwu"},@{@"namestr":@"实时直播",@"picstr":@"conf_shipin"}];
    }else if ([model.sign intValue] == 2) {
        //视频直播
        _arrdata = @[@{@"namestr":@"数据快速共享",@"picstr":@"conf_datashare"},@{@"namestr":@"语音识别",@"picstr":@"conf_shibie"},@{@"namestr":@"智能翻译助手",@"picstr":@"conf_translate"},@{@"namestr":@"会议速记",@"picstr":@"conf_suji"},@{@"namestr":@"无限制视频通话",@"picstr":@"conf_tonghua"},@{@"namestr":@"直播连麦",@"picstr":@"conf_lianmai"},@{@"namestr":@"多终端无缝对接",@"picstr":@"conf_duoduan"},@{@"namestr":@"实时直播",@"picstr":@"conf_shipin"}];
    }else if ([model.sign intValue] == 3) {
        //视频客服
        _arrdata = @[@{@"namestr":@"实时语音\n识别",@"picstr":@"sale_yuyinshibie"},@{@"namestr":@"全天24小\n时在线服务",@"picstr":@"sale_销售服务"},@{@"namestr":@"在线销售\n成功率提升3倍",@"picstr":@"sale_销售提升"},@{@"namestr":@"客户满意\n度上升90%",@"picstr":@"sale_满意度"},@{@"namestr":@"实时音视\n频沟通交流",@"picstr":@"sale_shipin"},@{@"namestr":@"不限观众\n访问数量",@"picstr":@"sale_fangwen"},@{@"namestr":@"实时互动客户\n转换率提升六倍",@"picstr":@"sale_实时互动"},@{@"namestr":@"随时邀请\n专家连线",@"picstr":@"sale_zhuanjia"}];
    }else if ([model.sign intValue] == 4) {
        //视频营销
        _arrdata = @[@{@"namestr":@"实时互动客户\n转换率提升六倍",@"picstr":@"sale_实时互动"},@{@"namestr":@"客户满意\n度上升90%",@"picstr":@"sale_满意度"},@{@"namestr":@"在线销售\n成功率提升3倍",@"picstr":@"sale_销售提升"},@{@"namestr":@"全天24小\n时为你服务",@"picstr":@"sale_销售服务"},@{@"namestr":@"实时音视\n频沟通交流",@"picstr":@"sale_shipin"},@{@"namestr":@"不限观众\n访问数量",@"picstr":@"sale_fangwen"},@{@"namestr":@"实时语音\n识别",@"picstr":@"sale_yuyinshibie"},@{@"namestr":@"随时邀请\n专家连线",@"picstr":@"sale_zhuanjia"}];
    }
    
    
}

- (void)initSubTableView {
    // 创建表格
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH - 60) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = TableViewBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.estimatedSectionHeaderHeight = 10;
    self.tableView.estimatedSectionFooterHeight = 10;
    SIMFPNextHeader *headerV = [[SIMFPNextHeader alloc] initWithFrame:CGRectMake(0, 0, screen_width, kWidthScale(150))];
    SIMPayPlanModel*model = self.arr[1];
    headerV.urlStr = model.PlanCoverImg;
    _tableView.tableHeaderView = headerV;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[SIMFreeNextCell class] forCellReuseIdentifier:oneCell];
    [self.tableView registerClass:[SIMOrderThreeCell class] forCellReuseIdentifier:threeCell];
    [self.tableView registerClass:[SIMFreeNewVipTableViewCell class] forCellReuseIdentifier:bottomCell];
    
    
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
    if (self.btnIndex ==0) {
        [self requestTheFreeDatas];
    }else {
        if (![WXApi isWXAppInstalled]) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"ThirdLoginNoWechatTitle", nil)];
            
        }else if (![WXApi isWXAppSupportApi]){
            [MBProgressHUD cc_showText:SIMLocalizedString(@"TopUpwithdraw_noWechat", nil)];
            
        }else {
            // vip固定是按照2 年 计费的 没有月
            SIMPayPlanModel*model = self.arr[1];
            NSLog(@"modelllllll%@",model.serial);
            [self weChatGet:@"2" order:model.serial];
        }
    }
    
}
#pragma mark -- UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.0;
    
}

//设置分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
//分区中行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

//设置单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SIMFreeNextCell *commonCell = [tableView dequeueReusableCellWithIdentifier:oneCell];
        commonCell.selectIndex = self.btnIndex;
        commonCell.arr = self.arr;

        __weak typeof(self) weakSelf = self;
        [commonCell setDidClickAtIndex:^(NSInteger buttonIndex) {
            weakSelf.btnIndex = buttonIndex;
            if (weakSelf.btnIndex == 0) {
                [weakSelf.gotoBuy setTitle:SIMLocalizedString(@"NPayMain_NextBnt", nil) forState:UIControlStateNormal];
            }else {
                [weakSelf.gotoBuy setTitle:SIMLocalizedString(@"NPayMain_PayLast", nil) forState:UIControlStateNormal];
            }
//            //一个cell刷新
//            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//            [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    
            [self.tableView reloadData];
            
        }];
//        commonCell.model = self.model;
        return commonCell;
    }else if (indexPath.section == 1) {
        SIMOrderThreeCell *theCell = [tableView dequeueReusableCellWithIdentifier:threeCell];
        SIMPayPlanModel *mm = _arr[self.btnIndex];
        mm.isNewFree = @"1";//是vip界面
//        theCell.types = [NSString stringWithFormat:@"%ld",self.btnIndex];
        theCell.model = mm;
        NSLog(@"theCell.model %@",mm.PlanName);
        return theCell;
    }else if (indexPath.section == 2) {
        SIMFreeNewVipTableViewCell *theCell = [tableView dequeueReusableCellWithIdentifier:bottomCell];
        
        theCell.arr =  _arrdata;
        
        return theCell;
    }else{
        return nil;
    }
}

- (void)requestTheFreeDatas {
    SIMPayPlanModel*model = _arr[0];
    NSDictionary *dict = @{@"serial":model.serial,
                           };
    NSLog(@"freepaydictdict%@",dict);
    [MainNetworkRequest buyTheFreeorderWechatResult:dict success:^(id success) {
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];

        NSLog(@"wechatfreeOrderDic   %@",success);
        // 成功
        if ([success[@"status"] isEqualToString:@"ok"]) {
            NSLog(@"请求成功");
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else {
            NSLog(@"请求失败");
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:@"请求失败"];
    }];
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
                           @"sign":@"3", // 固定就写3
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
