//
//  SIMNewPlanListModel.h
//  Kaihuibao
//
//  Created by mac126 on 2019/5/24.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SIMNewPlanDetailModel;
@class SIMNewPlanCurrentModel;
@class SIMNewPlanDetailInfo;
@class SIMOptionList;

@interface SIMNewPlanListModel : NSObject
@property (nonatomic, strong) NSString *type;// 类型计划是plan device是device
@property (nonatomic, strong) NSNumber *pid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *descriptionStr;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSNumber *isPresent;
@property (nonatomic, strong) NSNumber *orderType;
@property (nonatomic, strong) NSNumber *plan_type;
@property (nonatomic, strong) NSNumber *isClick;
@property (nonatomic, strong) NSString *buttonText;
@property (nonatomic, strong) NSString *unit;       //  计划用的
@property (nonatomic, strong) NSString *price_unit; //  服务用的
@property (nonatomic, strong) NSString *time_unit;  //  服务用的
@property (nonatomic, strong) NSNumber *jump_url;  //  服务用的
@property (nonatomic, strong) NSString *contact_url;  //  服务用的

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface SIMNewPlanDetailModel : NSObject
@property (nonatomic, strong) NSString *type;// 类型计划是plan device是device
@property (nonatomic, strong) NSNumber *pid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *main;
@property (nonatomic, strong) NSNumber *participant;
@property (nonatomic, strong) NSNumber *conferenceRoom;
@property (nonatomic, strong) NSString *discountsPrice;
@property (nonatomic, strong) NSNumber *orderType;
@property (nonatomic, strong) NSArray *info_array;
@property (nonatomic, strong) NSArray *info;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *price_unit;
@property (nonatomic, strong) NSString *time_unit;
@property (nonatomic, strong) NSString *num_unit;
@property (nonatomic, strong) NSNumber *serviceType;
@property (nonatomic, strong) NSNumber *valuationType;
@property (nonatomic, strong) NSString *optionKey;
@property (nonatomic, strong) NSArray *optionList;
@property (nonatomic, strong) NSString *countStr;
@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) NSString *selectBtn;
@property (nonatomic, strong) NSString *isNowSer;
@property (nonatomic, strong) NSString *quarterdiscountsPrice;
@property (nonatomic, strong) NSString *mode_image;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface SIMOptionList : NSObject

@property (nonatomic, strong) NSString *discountsPrice;
@property (nonatomic, strong) NSString *optionKey;
@property (nonatomic, strong) NSArray *info;
@property (nonatomic, strong) NSNumber *participant;
@property (nonatomic, strong) NSString *num_unit;
@property (nonatomic, strong) NSString *time_unit;
@property (nonatomic, strong) NSString *price_unit;
@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) NSString *countStr;
@property (nonatomic, strong) NSString *selectBtn;
@property (nonatomic, strong) NSString *totalMoney;
@property (nonatomic, strong) NSString *payMoney;
@property (nonatomic, strong) NSNumber *main;
@property (nonatomic, strong) NSString *quarterdiscountsPrice;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end


@interface SIMNewPlanDetailInfo : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *totalMoney;
@property (nonatomic, strong) NSString *payMoney;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *IOS_ID;
@property (nonatomic, strong) NSString *time_type;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface SIMNewPlanCurrentModel : NSObject
@property (nonatomic, strong) NSString *type; // 是首页查看的还是当前计划查看的
@property (nonatomic, strong) NSNumber *pid;
@property (nonatomic, strong) NSString *orderNum;
@property (nonatomic, strong) NSNumber *distinct;
@property (nonatomic, strong) NSString *planName;
@property (nonatomic, strong) NSNumber *main;
@property (nonatomic, strong) NSNumber *participant;
@property (nonatomic, strong) NSNumber *conferenceRoom;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSNumber *orderAmount;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *payStatus;
@property (nonatomic, strong) NSString *payType;
@property (nonatomic, strong) NSNumber *plan_type;
@property (nonatomic, strong) NSString *payImg;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
