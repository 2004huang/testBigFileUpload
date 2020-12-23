//
//  SIMPicture.h
//  Kaihuibao
//
//  Created by mac126 on 2018/1/3.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIMPicture : NSObject
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *detail;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
