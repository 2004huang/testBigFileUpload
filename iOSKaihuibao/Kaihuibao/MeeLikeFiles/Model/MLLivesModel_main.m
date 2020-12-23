//
//  MLLivesModel_main.m
//  MeeLike
//
//  Created by mac126 on 2020/9/16.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "MLLivesModel_main.h"

@implementation MLLivesModel_Items

-(instancetype)initWithArray:(NSArray *)modelArray{
    if (!modelArray||![modelArray isKindOfClass:[NSArray class]]) {
        return nil;
    }
    [self.classItems removeAllObjects];
    self = [super init];
    if (self) {
        for (NSDictionary * dic in modelArray) {
            MLLivesModel_main * mode = [[MLLivesModel_main alloc]initWithDictionary:dic];
            [self.classItems addObject:mode];
        }
    }
    return self;
}

-(void)setTimeKeyString:(NSString *)timeKeyString{
    _timeKeyString = timeKeyString;
    if (![[NSString formatToString:timeKeyString] isEqualToString:@""]) {;
        NSLog(@"timeKeyString =%@",timeKeyString);
        self.weekString = [NSString weekdayStringFromDate:timeKeyString];
        self.dayString = [NSString dayStringFromDate:timeKeyString];
    }
}

-(NSMutableArray * )classItems{
    if (!_classItems) {
        _classItems = [NSMutableArray array];
    } return _classItems;
}

@end

@implementation MLLivesModel_main

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!dictionary||![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    [self initializeWithDic:dictionary];
    return self;
}

- (void)initializeWithDic:(NSDictionary *)dict {
    self.serial =  [NSString formatToString:dict key:@"serial"];
    self.name =  [NSString formatToString:dict key:@"name"];
    self.startTime = [NSString formatToString:dict key:@"startTime"];
    self.endTime = [NSString formatToString:dict key:@"endTime"];
    self.detail = [NSString formatToString:dict key:@"detail"];
    self.cover = [NSString formatToString:dict key:@"cover"];
    self.sketch = [NSString formatToString:dict key:@"sketch"];
    self.duation = [NSString formatToString:dict key:@"duation"];
    self.time = [NSString formatToString:dict key:@"time"];
}


@end
