//
//  SIMAddMember.h
//  Kaihuibao
//
//  Created by mac126 on 2019/7/8.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMAddMember : NSObject
@property (strong,nonatomic) NSString *pid;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *title;
@property (assign,nonatomic) BOOL isSelect;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
