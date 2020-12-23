//
//  SIMMessNotiModel.h
//  Kaihuibao
//
//  Created by mac126 on 2019/10/29.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SIMMessNotiDetailModel;
NS_ASSUME_NONNULL_BEGIN

@interface SIMMessNotiModel : NSObject
@property (nonatomic, strong) NSNumber *classification_id;
@property (nonatomic, strong) NSString *classification_name;
@property (nonatomic, strong) NSString *descriptionStr;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSNumber *isfeedback;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end


@interface SIMMessNotiDetailModel : NSObject
@property (nonatomic, strong) NSNumber *message_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *descriptionStr;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSNumber *isfeedback;
@property (nonatomic, strong) NSString *url;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
