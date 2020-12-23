//
//  SIMAppPurchaseTool.h
//  TestApplePay
//
//  Created by gs on 2017/10/11.
//  Copyright © 2017年 wangxiaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
@protocol SIMAppPurchaseDelegate <NSObject>

- (void)AppPurchaseShowErrorWithErrorDescription:(NSString *)description;

- (void)AppPurchasedidBeginRequestProduct;
- (void)AppPurchaseBeingRequestPayment;
- (void)AppPurchaseDidEndPurchase;
- (void)AppPurchaseHasRestored;
- (void)AppPurchaseSuccess;

@end

@interface SIMAPPFileTool : NSObject
+ (NSString *)tempIapReceiptPath;
+ (NSString *)iapReceiptPath;
@end

@interface SIMAppPurchaseTool : NSObject
@property (weak, nonatomic) id<SIMAppPurchaseDelegate> delegate;

+ (instancetype)shareInstace;

- (void)startPurchase:(NSString *)productId ;
- (void)startManager;
- (void)stopManager;
//- (void)completeTransaction:(SKPaymentTransaction *)transaction;
//- (void)deallocTheTrans;

@end
