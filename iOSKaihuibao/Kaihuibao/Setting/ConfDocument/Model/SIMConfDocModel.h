//
//  SIMConfDocModel.h
//  Kaihuibao
//
//  Created by mac126 on 2019/9/5.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SIMConfDocModel : NSObject
@property (nonatomic, strong) NSString *file_type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *wide;
@property (nonatomic, strong) NSString *high;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSNumber *docId;
@property (nonatomic, assign) BOOL isSelect;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
