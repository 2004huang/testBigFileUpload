//
//  SIMInterpreter.h
//  Kaihuibao
//
//  Created by mac126 on 2020/6/21.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMInterpreter : NSObject
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *isInterpreter;
@property (nonatomic, strong) NSString *translate_language_id;
@property (nonatomic, strong) NSString *translate_language;
@property (nonatomic, strong) NSString *source_language_id;
@property (nonatomic, strong) NSString *source_language;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end

NS_ASSUME_NONNULL_END
