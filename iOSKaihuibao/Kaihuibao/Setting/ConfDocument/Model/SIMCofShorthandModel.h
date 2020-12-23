//
//  SIMCofShorthandModel.h
//  Kaihuibao
//
//  Created by mac126 on 2019/12/3.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMCofShorthandModel : NSObject
@property (nonatomic, strong) NSString *conf_name;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *conf_id;
@property (nonatomic, strong) NSString *src_text;
@property (nonatomic, strong) NSString *src_lan_code;
@property (nonatomic, strong) NSString *tar_text;
@property (nonatomic, strong) NSString *tar_lan_code;
@property (nonatomic, strong) NSString *record_user_name;
@property (nonatomic, strong) NSString *record_user_id;
@property (nonatomic, assign) BOOL isSelect;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
