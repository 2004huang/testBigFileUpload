//
//  SIMNowServiceModel.h
//  Kaihuibao
//
//  Created by mac126 on 2019/9/19.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMNowServiceModel : NSObject
@property (nonatomic, strong) NSNumber *pid; // 订单id
@property (nonatomic, strong) NSString *service_id; // 服务id
@property (nonatomic, strong) NSString *service_name;// 服务名称
@property (nonatomic, strong) NSString *main;// 主持人数量
@property (nonatomic, strong) NSString *participant;// 参与人数量
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *service_type; // 服务类型
@property (nonatomic, strong) NSString *pay_type; // 支付方式
@property (nonatomic, strong) NSString *count_down; // 还有多少天到期
@property (nonatomic, strong) NSString *button_text; // 按钮文字
@property (nonatomic, strong) NSNumber *orderType;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
