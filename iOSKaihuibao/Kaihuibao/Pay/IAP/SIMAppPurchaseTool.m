//
//  SIMAppPurchaseTool.m
//  TestApplePay
//
//  Created by gs on 2017/10/11.
//  Copyright © 2017年 wangxiaoqi. All rights reserved.
//
#define Dispatch_iapqueue(block)  dispatch_async(iap_queue(), block)

#define GCD_MAIN(block) dispatch_async(dispatch_get_main_queue(), block);
#define delegeteMethod(methodName) if (self.delegate && [self.delegate respondsToSelector:@selector(methodName)]) { \
   [self.delegate methodName]; \
    }\

#define delegeteMethodWithObject(methodName,object) if (self.delegate && [self.delegate respondsToSelector:@selector(methodName:)]) { \
GCD_MAIN(^(){\
    [self.delegate methodName:object];\
})\
}\

#import "SIMAppPurchaseTool.h"
#import "BaseNetworking.h"
#import "NSDate+SIMConvenient.h"

static SIMAppPurchaseTool *_instance = nil;

static NSString *kReceiptKey = @"receiptKey";
static NSString *kUid        = @"uid";
static NSString *kPurchase_date = @"purchase_date";
static NSString *kExpires_date  = @"expires_date";
static NSString *kTimeInterval = @"timeInterval";
static NSString *kEnvironment = @"environment";

dispatch_queue_t iap_queue() {
    static dispatch_queue_t as_iap_queue;
    static dispatch_once_t onceToken_iap_queue;
    dispatch_once(&onceToken_iap_queue, ^{
        as_iap_queue = dispatch_queue_create("com.iap.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return as_iap_queue;
}



@implementation SIMAPPFileTool

+ (NSString *)libPrefPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preferences"];
}

+ (NSString *)tempIapReceiptPath{
    NSString *path = [[self libPrefPath] stringByAppendingFormat:@"/EACEF35FE363A75A"];
    [self hasLive:path];
    return path;
}

+ (NSString *)iapReceiptPath{
    NSString *path = [[self libPrefPath] stringByAppendingFormat:@"/APPIAPRECEIPT"];
    [self hasLive:path];
    return path;
}

+ (BOOL)hasLive:(NSString *)path
{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    return YES;
}
@end


@interface SIMAppPurchaseTool()<SKProductsRequestDelegate,SKPaymentTransactionObserver,SKRequestDelegate>
@property (nonatomic, strong) NSData *receipt;// 凭证
@property (nonatomic, assign) BOOL isObserver;
@property (nonatomic, copy) NSString *temoIapReceiptPath;
@property (nonatomic, copy) NSString *iapReceiptPath;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@property (nonatomic, strong) NSString *productId;
@end

@implementation SIMAppPurchaseTool

+ (instancetype)shareInstace{
    if (_instance) {
        return _instance;
    }
    return [[SIMAppPurchaseTool alloc] init];
}

//- (instancetype)init{
//    self = [super init];
//    if (self) {
//        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//    }
//    return self;
//}
- (void)startManager { //开启监听
    /*
     阶段一正在进中,app退出。
     在程序启动时，设置监听，监听是否有未完成订单，有的话恢复订单。
     */
    NSLog(@"开始监听内购");
    // 专有线程
    dispatch_async(iap_queue(), ^{
        if (!self.isObserver) {
            self.isObserver = YES;
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        }
        /*
         阶段二正在进行中,app退出。
         在程序启动时，检测本地是否有receipt文件，有的话，去二次验证。
         */
//        [self checkIAPFiles];
    });
    
    
}

- (void)stopManager{ //移除监听
    if (self.isObserver) {
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
        self.isObserver = NO;
    }
    NSLog(@"结束监听内购");
}

// 外部调用此方法 内购买
- (void)startPurchase:(NSString *)productId {
    // 判断是否可以购买
    if([SKPaymentQueue canMakePayments]){
        // member_type_01 为itunes connect 商品ID 暂时只有一个
        self.productId = productId;
        [self requestProductData:productId];
    }else{
        NSLog(@"不允许程序内付费");
        // 提示用户
        // 提示用户
        delegeteMethodWithObject(AppPurchaseShowErrorWithErrorDescription, @"您的手机没有打开程序内付费购买")
        
    }
}

//请求商品
- (void)requestProductData:(NSString *)type{
    
    NSLog(@"请求商品");
    delegeteMethod(AppPurchasedidBeginRequestProduct)
    NSArray *product = [[NSArray alloc] initWithObjects:type, nil];
    
    NSSet *nsset = [NSSet setWithArray:product];
    
    // 请求动作
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    
}
#pragma mark - <SKProductsRequestDelegate>
//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSLog(@"收到了请求反馈");
    NSArray *product = response.products;
    if([product count] == 0){
        
        NSLog(@"没有这个商品");
        delegeteMethodWithObject(AppPurchaseShowErrorWithErrorDescription, @"没有这个商品")
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    
    NSLog(@"产品付费数量:%ld",[product count]);
    
    
    SKProduct *p = nil;
    
    // 所有的商品, 遍历招到我们的商品
    
    for (SKProduct *pro in product) {
        
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        
        p = pro;
    }
    if (p) {
        SKPayment * payment = [SKPayment paymentWithProduct:p];
        NSLog(@"发送购买请求");
        delegeteMethod(AppPurchaseBeingRequestPayment)
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    
}
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"商品信息请求错误:%@", error);
    
    delegeteMethodWithObject(AppPurchaseShowErrorWithErrorDescription, @"商品信息请求错误")
}

- (void)requestDidFinish:(SKRequest *)request {
    NSLog(@"请求结束");
}

- (BOOL)paymentQueue:(SKPaymentQueue *)queue shouldAddStorePayment:(SKPayment *)payment forProduct:(SKProduct *)product{
    return YES;
}
//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction {
    for(SKPaymentTransaction *tran in transaction){
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                 NSLog(@"交易完成");
                delegeteMethod(AppPurchaseDidEndPurchase)
                [self completeTransaction:tran];
               
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                delegeteMethod(AppPurchaseHasRestored)
                [self restoreTransaction: tran];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"交易失败");
//                delegeteMethodWithObject(AppPurchaseShowErrorWithErrorDescription, @"交易失败")
                [self failedTransaction: tran];
                
                break;
            default:
                break;
        }
    }
}

// 购买的
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    Dispatch_iapqueue(^(){
        // 拿到服务器验证
        [self recordTransaction: transaction];
    });
}

// 恢复的
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
// 失败交易
- (void)failedTransaction: (SKPaymentTransaction *)transaction
{
    if(transaction.error.code != SKErrorPaymentCancelled)
    {
        //在这类显示除用户取消之外的错误信息
        NSLog(@"在这类显示除用户取消之外的错误信息 %ld",transaction.error.code);
        delegeteMethodWithObject(AppPurchaseShowErrorWithErrorDescription, transaction.error.localizedDescription)
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

//交易结束
- (void)recordTransaction:(SKPaymentTransaction *)transaction {
    // 请求服务器验证
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    // 发送网络POST请求，对购买凭据进行验证
    //测试验证地址:https://sandbox.itunes.apple.com/verifyReceipt
    //正式验证地址:https://buy.itunes.apple.com/verifyReceipt

    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    self.receipt = receiptData;
    [self saveReceipt:self.receipt];
    
//    NSString *ipAdressStr = [NSString stringWithFormat:@"http://192.168.4.241:8001/app/api/pay/apple/validate/"];
    if (!encodeStr) {
        NSLog(@"encodeStr %@",encodeStr);
//        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
        return;
    }
// 如果存在originalTransaction,则说明用户续订,日后可对此进行判断处理

    if (transaction.originalTransaction) {
        
    }else {
        
    }
    [self sendAppStoreRequest:encodeStr Transaction:transaction];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)sendAppStoreRequest:(NSString *)encodeStr Transaction:(SKPaymentTransaction *)transaction {

//    NSLog(@"current thread = %@",[NSThread currentThread]);
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    
    // 拼接请求数据
//    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
//    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
//
//    // 创建请求到苹果官方进行购买验证
//    NSURL *url = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
//    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
//    requestM.HTTPBody = bodyData;
//    requestM.HTTPMethod = @"POST";
//
//    // 创建连接并发送同步请求
//    NSError *error = nil;
//    [NSURLConnection sendAsynchronousRequest:requestM queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        if (error) {
//            NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
//            return;
//        }
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"iciciccdd %@",dic);
//    }];
    
    
//     // 成功
//    if ([successDic[@"status"] isEqualToString:@"ok"]) {
//        NSLog(@"支付成功");
//        // 移除本地临时存储的 recipet
//#warning 是否成功移除
//        [self removeReceipt];
//        // 存储过期时间,当前时间以及收据
//#warning 是否成功添加
//        [self saveRecipetData:successDic[@"product_info"] recipet:encodeStr];
//    }else if ([successDic[@"status"] isEqualToString:@"ERROR_HAS_NOT_LOGIN"]) {
//        NSLog(@"未登录状态");
//    }else if ([successDic[@"status"] isEqualToString:@"ERROR_INVALID_FORM"]) {
//        NSLog(@"表单错误");
//    }else {
//        NSLog(@"其他错误");
//    }
//    if (transaction) {
//        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//    }
//    dispatch_semaphore_signal(self.semaphore);
//
    NSLog(@"appleinappPayOrderID %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appleinappPayOrderID"]);
//    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest inappPayRequestParams:@{@"receipt_data":encodeStr,@"orderNum":[[NSUserDefaults standardUserDefaults] objectForKey:@"appleinappPayOrderID"]} success:^(id success) {
        // 成功
        NSLog(@"inapppayRequestSuccess  %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {

//            NSDictionary *dicdata = success[@"data"];
            NSLog(@"支付成功");
            
            [MBProgressHUD cc_showText:@"支付成功"];
            delegeteMethod(AppPurchaseSuccess)
            // 移除本地临时存储的 recipet
#warning 是否成功移除
//            [self removeReceipt];
            // 存储过期时间,当前时间以及收据
#warning 是否成功添加
//            [self saveRecipetData:successDic[@"product_info"] recipet:encodeStr];
        }else {
            [MBProgressHUD cc_showText:@"支付失败"];
        }
        if (transaction) {
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failure:^(id failure) {
        NSLog(@"失败了");
        [MBProgressHUD cc_showText:@"支付失败"];
        dispatch_semaphore_signal(self.semaphore);
    }];
//    [[BaseNetworking shareInstance] startWithHeaderPostURL:ipAdressStr params:@{@"the_str":encodeStr,@"order_id":@"1"} success:^(id success) {
//        NSDictionary *successDic = [NSJSONSerialization JSONObjectWithData:success options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"successDicPay%@",successDic);
//        if (successDic[@"Cancellation Date"]) {
//            NSLog(@"用户取消了自动订阅");
//        }
//        // 成功
//        if ([successDic[@"status"] isEqualToString:@"ok"]) {
//            NSLog(@"支付成功");
//            // 移除本地临时存储的 recipet
//#warning 是否成功移除
//            [self removeReceipt];
//            // 存储过期时间,当前时间以及收据
//#warning 是否成功添加
//            [self saveRecipetData:successDic[@"product_info"] recipet:encodeStr];
//        }else if ([successDic[@"status"] isEqualToString:@"ERROR_HAS_NOT_LOGIN"]) {
//            NSLog(@"未登录状态");
//        }else if ([successDic[@"status"] isEqualToString:@"ERROR_INVALID_FORM"]) {
//            NSLog(@"表单错误");
//        }else {
//            NSLog(@"其他错误");
//        }
//        if (transaction) {
//            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//        }
//        dispatch_semaphore_signal(self.semaphore);
//    } failure:^(id failure) {
//        NSLog(@"失败了");
//        dispatch_semaphore_signal(self.semaphore);
//    }];
}


//- (void)dealloc {
//    // 移除监听
//    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
//}


#pragma mark - 用户凭证

- (void)checkRecipetVailate{
// 每次启动应用程序后是否都能检测凭证有效期
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if ([filemanager fileExistsAtPath:self.iapReceiptPath]) {
// 从本地读取存储的有效期及凭证,发送到后台确认有效期
        NSDictionary *reciperDic = [[NSDictionary alloc] initWithContentsOfFile:self.iapReceiptPath];
        if (reciperDic) {
            NSString *expires_dateString = reciperDic[kExpires_date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-DD hh:mm:ss"];
            NSDate *expires_date = [formatter dateFromString:expires_dateString];
            NSString *current_dateString = [formatter stringFromDate:[NSDate dateNow]];
            NSDate *current_date = [formatter dateFromString:current_dateString];
            NSComparisonResult result = [expires_date compare:current_date];
            if (NSOrderedAscending == result || NSOrderedSame == result) {
// 如在客户端发现凭证过期,是否可以向自家服务器再次验证凭证有效期
                [self sendAppStoreRequest:reciperDic[kReceiptKey] Transaction:nil];
            }
        }
    }
    
}

#pragma mark  持久化存储用户购买凭证(这里最好还要存储当前日期，用户id等信息，用于区分不同的凭证)
-(void)saveReceipt:(NSData *)receipt{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                        receipt,                   kReceiptKey,
                        self.currentUser.uid,      kUid,
                        nil];
    [dic writeToFile:self.temoIapReceiptPath atomically:YES];
}

- (void)checkIAPFiles{
// IAP 后,未与自己服务器验证断网,重新启动应用程序后是否可以检测未验证凭证
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    // 搜索该目录下所有文件和目录
    NSArray *cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:[SIMAPPFileTool tempIapReceiptPath] error:&error];
    if (error == nil) {
        for (NSString *name in cacheFileNameArray) {
            if ([name hasSuffix:@".plist"]){ //如果有plist后缀的文件，说明就是存储的购买凭证
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", [SIMAPPFileTool tempIapReceiptPath], name];
                NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
                [self sendAppStoreRequest:[dic objectForKey:kReceiptKey] Transaction:nil];
            }
        }
    } else {
        NSLog(@"AppStoreInfoLocalFilePath error:%@", [error domain]);
    }
}

// 验证成功就从plist中移除凭证
- (void)removeReceipt{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.temoIapReceiptPath]) {
        [fileManager removeItemAtPath:self.temoIapReceiptPath error:nil];
    }
}

- (void)saveRecipetData:(NSDictionary *)dic recipet:(NSString *)recipetString{
    NSDictionary *recipetDic = [NSDictionary dictionaryWithObjectsAndKeys:
                         dic[kPurchase_date],kPurchase_date,
                         dic[kExpires_date],kExpires_date,
                         recipetString,kReceiptKey,nil];
    [recipetDic writeToFile:self.iapReceiptPath atomically:YES];
}


#pragma mark - Target Method
// 当应用程序进入前台,检查凭证有效期
- (void)appDidEnterForground:(NSNotification *)notification{
//    [self checkRecipetVailate];
}


#pragma mark - Override

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        self.isObserver = NO;
        self.semaphore = dispatch_semaphore_create(1);
// 监听应用程序进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForground:) name:UIApplicationDidBecomeActiveNotification object:nil];
    });
    return _instance;
}


#pragma mark - GET

- (NSString *)temoIapReceiptPath{
    if (!_temoIapReceiptPath) {
        _temoIapReceiptPath = [NSString stringWithFormat:@"%@/%@.plist", [SIMAPPFileTool tempIapReceiptPath], self.currentUser.uid];;
    }
    return _temoIapReceiptPath;
}

- (NSString *)iapReceiptPath{
    if (!_iapReceiptPath) {
        _iapReceiptPath = [NSString stringWithFormat:@"%@/%@%@.txt",[SIMAPPFileTool iapReceiptPath],self.currentUser.uid,@"purchasedata"];
    }
    return _iapReceiptPath;
}

@end
