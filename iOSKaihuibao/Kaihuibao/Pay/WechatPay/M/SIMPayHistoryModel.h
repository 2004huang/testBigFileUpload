//
//  SIMPayHistoryModel.h
//  Kaihuibao
//
//  Created by mac126 on 2018/10/16.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMPayHistoryModel : NSObject
@property (nonatomic, strong) NSString *CreateTime;
@property (nonatomic, strong) NSString *EndTime;
@property (nonatomic, strong) NSString *PlanCoverImg;
@property (nonatomic, strong) NSString *PlanName;
@property (nonatomic, strong) NSString *PlanSerial;
@property (nonatomic, strong) NSString *StartTime;
@property (nonatomic, strong) NSNumber *flow;
@property (nonatomic, strong) NSString *homepage;
@property (nonatomic, strong) NSNumber *payid;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSNumber *order_type;
@property (nonatomic, strong) NSNumber *participant;
@property (nonatomic, strong) NSString *plantype;
@property (nonatomic, strong) NSString *service;
@property (nonatomic, strong) NSNumber *sign;
@property (nonatomic, strong) NSNumber *uid;
@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, strong) NSNumber *seat;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
