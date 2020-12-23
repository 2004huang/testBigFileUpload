//
//  MLLivesModel_main.h
//  MeeLike
//
//  Created by mac126 on 2020/9/16.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLLivesModel_Items : NSObject

@property (nonatomic ,strong)NSString * dayString; // 2、3、4、5 日期
@property (nonatomic ,strong)NSString * weekString; // 二、三、四、五 日期
@property (nonatomic ,strong)NSString * timeKeyString; // xxxx-xx-xx 日期
@property (nonatomic, strong)NSMutableArray * classItems; // 当日训练数据

-(instancetype)initWithArray:(NSArray *)modelArray;

@end

@interface MLLivesModel_main : NSObject

@property (nonatomic, strong)NSString * serial;
@property (nonatomic, strong)NSString * name;
@property (nonatomic, strong)NSString * startTime;
@property (nonatomic, strong)NSString * endTime;
@property (nonatomic, strong)NSString * detail;
@property (nonatomic, strong)NSString * cover;
@property (nonatomic, strong)NSString * sketch;
@property (nonatomic, strong)NSString * duation;
@property (nonatomic, strong)NSString * time;
  
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
