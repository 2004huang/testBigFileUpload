//
//  SIMWechatModel.h
//  Kaihuibao
//
//  Created by mac126 on 2018/10/10.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMWechatModel : NSObject
@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *noncestr;
@property (nonatomic, strong) NSString *package;
@property (nonatomic, strong) NSString *partnerid;
@property (nonatomic, strong) NSString *prepayid;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *timestamp;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
