//
//  SIMWalletMainViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/7/5.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMWalletMainViewController.h"

#import "SIMWalletHistoryListViewController.h"
#import "SIMWalletMainHeader.h"
#import "SIMSelectToponTableViewCell.h"
#import "WXApi.h"
#import "SIMWechatModel.h"
#import "SIMNewWalletTableViewCell.h"

//#import "SIMAppPurchaseTool.h"

@interface SIMWalletMainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) SIMBaseTableView* tableView;
@property (strong,nonatomic) NSMutableArray *arrDatas;
@property (nonatomic, strong) UIButton *gotoBuy;
@property (assign,nonatomic) NSInteger btnIndex;
@property (nonatomic, strong) SIMWechatModel *wechatPay;
@property (nonatomic, strong) NSString *walletID;
@property (nonatomic, strong) SIMWalletMainHeader *headerView;

@end
static NSString *reuseWallet = @"SIMSelectToponTableViewCell";
static NSString *reusePic = @"SIMNewWalletTableViewCell";

@implementation SIMWalletMainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = SIMLocalizedString(@"TopUpwallet_centerTitle", nil);
//    self.btnIndex = 0;
    _arrDatas = [NSMutableArray array];
    [self requestAmountList];
//    [self requestHeaderAmountCount];
//    _arrDatas = @[@[@"500",@"1000",@"2000",@"5000",@"10000",@"20000"]];
    [self addsubViews];
    // 如果是会议内部界面的话 那么是返回是dismiss
    if (self.isConfVC) {
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"returnicon"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
        self.navigationItem.leftBarButtonItem = backBtn;
    }
}
- (void)backClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)addsubViews {
    UIView *backImg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kWidthScale(257))];
    backImg.backgroundColor = ZJYColorHex(@"#0d0d0d");
//    backImg.image = [UIImage imageNamed:@"wallet_backImg"];
    [self.view addSubview:backImg];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.frame = CGRectMake(15, 0, screen_width-30, screen_height - StatusNavH - 80);
    self.tableView.backgroundColor = ZJYColorHex(@"#0d0d0d");
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[SIMSelectToponTableViewCell class] forCellReuseIdentifier:reuseWallet];
    [self.tableView registerClass:[SIMNewWalletTableViewCell class] forCellReuseIdentifier:reusePic];
    
    _headerView = [[SIMWalletMainHeader alloc] initWithFrame:CGRectMake(0, 0, screen_width, kWidthScale(100))];
    self.tableView.tableHeaderView = _headerView;
    
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, screen_height - StatusNavH - BottomSaveH - 80, screen_width, 80)];
    [self.view addSubview:footerView];
    
    _gotoBuy = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, screen_width - 30, 45)];
    [_gotoBuy setBackgroundColor:BlueButtonColor];
    [_gotoBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_gotoBuy setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_gotoBuy setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    _gotoBuy.titleLabel.font = FontRegularName(18);
    _gotoBuy.layer.masksToBounds = YES;
    _gotoBuy.layer.cornerRadius = 8;
    [_gotoBuy addTarget:self action:@selector(gotoBuythegood) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:_gotoBuy];
}
#pragma mark - TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kWidthScale(40))];
//    backV.backgroundColor = [UIColor whiteColor];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kWidthScale(15), 0, screen_width - kWidthScale(30), kWidthScale(40))];
//    label.text = SIMLocalizedString(@"TopUphasMoney_TOPon", nil);
//    label.font = FontRegularName(15);
//    label.textColor = BlackTextColor;
//    [backV addSubview:label];
//    return backV;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        SIMSelectToponTableViewCell *confListCell = [tableView dequeueReusableCellWithIdentifier:reuseWallet];
        
        confListCell.selectionStyle = UITableViewCellSelectionStyleNone;
        confListCell.arr = _arrDatas;
        __weak typeof(self) weakSelf = self;
        [confListCell setDidClickAtIndex:^(NSInteger buttonIndex) {
            NSLog(@"buttonIndexbuttonIndex %ld",buttonIndex);
            weakSelf.btnIndex = buttonIndex;
            NSDictionary *dic = _arrDatas[self.btnIndex];
            [weakSelf.gotoBuy setTitle:[NSString stringWithFormat:SIMLocalizedString(@"TopUphasMoney_TOPon", nil),dic[@"amount"]] forState:UIControlStateNormal];
            CGFloat amountCount = [dic[@"amount"] floatValue];
            CGFloat giveCount = [dic[@"give_amount"] floatValue];
            CGFloat sum = amountCount + giveCount;
            _headerView.balanceCount = [NSString stringWithFormat:@"%.2f",sum];
            //一个cell刷新
            [UIView performWithoutAnimation:^{
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }];
        return confListCell;
    }else {
        SIMNewWalletTableViewCell *picCell = [tableView dequeueReusableCellWithIdentifier:reusePic];
        if (_arrDatas.count > 0) {
            NSDictionary *dic = _arrDatas[self.btnIndex];
            picCell.selectionStyle = UITableViewCellSelectionStyleNone;
            picCell.imageHeight = dic[@"height"];
            picCell.picStr = dic[@"image"];
        }
        
        return picCell;
    }
    
}

#pragma mark -- EVENT

// 购买
- (void)gotoBuythegood {
//    [[SIMAppPurchaseTool shareInstace] startPurchase:@"testPlan_001"];
    NSLog(@"钱包 点击的下标是 ： %ld 金额是 ： %@",self.btnIndex,_arrDatas[self.btnIndex][@"amount"]);
    if (![WXApi isWXAppInstalled]) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ThirdLoginNoWechatTitle", nil)];
    }else if (![WXApi isWXAppSupportApi]){
        [MBProgressHUD cc_showText:SIMLocalizedString(@"TopUpwithdraw_noWechat", nil)];
    }else {
        NSDictionary *dic = _arrDatas[self.btnIndex];
        [self weChatGetorder:dic[@"amount"]];
    }
}
- (void)weChatGetorder:(NSString *)orderstr {
    [MBProgressHUD cc_showLoading:nil];
    NSDictionary *dic = @{@"amount":orderstr,@"type":APPWechatTitle};
    NSLog(@"payappdic %@",dic);
    [MainNetworkRequest walletAddMineWechatResult:dic success:^(id success) {
        NSLog(@"payappsuccess %@ %@",success,dic);
        if ([success[@"code"] integerValue] == successCodeOK) {
            
            _wechatPay = [[SIMWechatModel alloc] initWithDictionary:success[@"data"]];
            NSLog(@"wechatPayappid  %@",_wechatPay.appid);
            // 保存凭单到本地
            [[NSUserDefaults standardUserDefaults] setObject:success[@"data"][@"order_num"] forKey:@"newPayOrderNum"];
            // 支付种类  钱包和计划
            [[NSUserDefaults standardUserDefaults] setObject:@"WalletAdd" forKey:@"newOrderType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
            [self wechatNowPay];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
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
    
}
- (void)requestAmountList {
    [MainNetworkRequest walletAmountListResult:nil success:^(id success) {
        NSLog(@"amountlistsuccess %@",success);
        [_arrDatas removeAllObjects];
        if ([success[@"code"] integerValue] == successCodeOK) {
//            [_arrDatas addObject:@"0.01"];
            NSArray *arr = success[@"data"][@"new_amount_list"];
//            for (NSDictionary *dic in arr) {
//                [_arrDatas addObject:dic];
//            }
            [_arrDatas addObjectsFromArray:arr];
//            _arrDatas = success[@"data"][@"amount_list"];
            NSLog(@"_arrDatas %@",_arrDatas);
            if (_arrDatas.count > 0) {
                NSDictionary *dic = _arrDatas[self.btnIndex];
                [self.tableView reloadData];
                [_gotoBuy setTitle:[NSString stringWithFormat:SIMLocalizedString(@"TopUphasMoney_TOPon", nil),dic[@"amount"]] forState:UIControlStateNormal];
                CGFloat amountCount = [dic[@"amount"] floatValue];
                CGFloat giveCount = [dic[@"give_amount"] floatValue];
                CGFloat sum = amountCount + giveCount;
                _headerView.balanceCount = [NSString stringWithFormat:@"%.2f",sum];
            }
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}
//- (void)requestHeaderAmountCount {
//    [MainNetworkRequest walletmyWalletResult:nil success:^(id success) {
//        NSLog(@"walletmycountsuccess %@",success);
//        if ([success[@"code"] integerValue] == successCodeOK) {
//            NSString *string = success[@"data"][@"balance"];
//            _walletID = success[@"data"][@"wallet_id"];
//
//            NSLog(@"balancestring %@ %@",string,_walletID);
//            if (string.length > 0) {
//                _headerView.balanceCount = string;
//            }
//        }else {
//            [MBProgressHUD cc_showText:success[@"msg"]];
//        }
//    } failure:^(id failure) {
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
//    }];
//}

@end
