//
//  MLLivesEngine_mian.m
//  MeeLike
//
//  Created by mac126 on 2020/9/16.
//  Copyright © 2020 Ferris. All rights reserved.
//
#import "MLLivesEngine_mian.h"
#import "MLLivesModel_main.h"
#import "NSString+Helper.h"

@implementation MLLivesEngine_mian

+(void)toGetLivesClassCallBack:(EngineCallbackWithInfo)callback{
    [[BaseNetworking shareInstance] startWithHeaderGetURL:conference_liveindex_api params:nil success:^(id success) {
        
        NSMutableArray * mArray = [NSMutableArray array];
        NSDictionary  * dics = success[@"data"];
        NSMutableArray * keys = [NSMutableArray arrayWithArray:[dics allKeys]];
        

        for (NSString * dateString in keys) {
            NSLog(@"dateStringkeykey==%@",dateString);
            NSArray *array = [dics objectForKey:dateString];
            MLLivesModel_Items * item  = [[MLLivesModel_Items alloc]initWithArray:array];
            item.timeKeyString = dateString;
            [mArray addObject:item];
        }
        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd"];
//        NSMutableArray *tempArray = [NSMutableArray array];
//        for (NSString *dateString in mArray) {
//            NSDate *date = [formatter dateFromString:dateString];
//            [tempArray addObject:date];
//        }
//        [tempArray sortUsingComparator:^NSComparisonResult(NSDate *date1, NSDate *date2) {
//            return [date2 compare:date1];
//        }];
        
        callback(YES,nil,mArray);
        
    } failure:^(id failure) {
        
        callback(NO,nil,nil);
    }];
    
}



//- (NSComparisonResult)compareNsdate:(NSArray *)dateArray{
//}





//+ (NSArray*)kj_sortDescriptorWithTemps:(NSArray*)temps Key:(NSString*)key Ascending:(BOOL)ascending{
//    // 利用 NSSortDescriptor 对对象数组，按照某一属性或某些属性的升序降序排列
//    NSSortDescriptor *des = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
//    NSMutableArray *array = [NSMutableArray arrayWithArray:temps];
//    [array sortUsingDescriptors:@[des]];
//    return array;
//}
//





@end
