//
//  SIMFootImageModel.h
//  Kaihuibao
//
//  Created by mac126 on 2020/6/12.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMFootImageModel : NSObject
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSNumber *height;
@property (nonatomic, copy) NSString *jump_type;
@property (nonatomic, copy) NSString *jump_val;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descripStr;



- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
