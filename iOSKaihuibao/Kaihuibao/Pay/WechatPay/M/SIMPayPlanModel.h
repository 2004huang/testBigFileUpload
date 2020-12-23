//
//  SIMPayPlanModel.h
//  Kaihuibao
//
//  Created by mac126 on 2018/10/11.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMPayPlanModel : NSObject
@property (nonatomic, strong) NSString *CreateTime;
@property (nonatomic, strong) NSString *EffectTime;
@property (nonatomic, strong) NSString *PlanName;
@property (nonatomic, strong) NSString *PlanIntroduce; // 短描述
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *ShareDescribe;
@property (nonatomic, strong) NSString *PlanDescribe;// 长描述
@property (nonatomic, strong) NSString *PlanCoverImg;
@property (nonatomic, strong) NSArray *PlanDetailImg;
@property (nonatomic, strong) NSString *serial;
@property (nonatomic, strong) NSNumber *sign;
@property (nonatomic, strong) NSString *Show;
@property (nonatomic, strong) NSArray *PricePlan;
@property (nonatomic, strong) NSNumber *isnow;
@property (nonatomic, strong) NSString *isNewFree;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface SIMPayPlanModel_PricePlan : NSObject
@property (nonatomic, strong) NSNumber *MinuteBilling;
@property (nonatomic, strong) NSNumber *MonthBilling;
@property (nonatomic, strong) NSNumber *YearBilling;
@property (nonatomic, strong) NSNumber *discounts;
@property (nonatomic, strong) NSNumber *flow;
@property (nonatomic, strong) NSString *indate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *isDiscountTime;
@property (nonatomic, strong) NSString *isYearBilling;
@property (nonatomic, strong) NSNumber *participant;
@property (nonatomic, strong) NSNumber *seat;
@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, strong) NSNumber *deposit;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end


NS_ASSUME_NONNULL_END
