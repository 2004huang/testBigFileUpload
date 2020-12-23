//
//  SIMAdress.h
//  Kaihuibao
//
//  Created by mac126 on 2017/12/26.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIMAdress : NSObject

@property (nonatomic, assign) BOOL is_friend;
@property (nonatomic, assign) BOOL is_user;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *nickname;

@property (nonatomic, assign) BOOL isUserContant;// 用来区分是不是用户进入的界面还是好友的
@property (nonatomic, assign) BOOL isSelectSend;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
