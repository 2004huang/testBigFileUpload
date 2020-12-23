//
//  SIMConfConfig.h
//  Kaihuibao
//
//  Created by mac126 on 2019/5/21.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import <CinLanMedia/CinLanMedia.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMConfConfig : CLConfConfiguration
@property (nonatomic, strong) NSString *confMode;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
