//
//  ArrangeConfModel.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/23.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "ArrangeConfModel.h"
#import "SIMConfDocModel.h"

@implementation ArrangeConfModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //    NSLog(@"%@",key);
}

- (void)setConfMode:(NSString *)confMode {
    _confMode = confMode;
//    会议模式（freeCamera：自由视角，mainBroadcast：与主持人广播视频一致，mainCamera：与主持人视角一致,intercom:对讲模式）
    if ([confMode isEqualToString:@"freeCamera"]) {
        self.confModeStr = SIMLocalizedString(@"ConfModelFreeCamaraTitle", nil);
    }else if ([confMode isEqualToString:@"mainBroadcast"]) {
        self.confModeStr = SIMLocalizedString(@"ConfModelMainBroadcastTitle", nil);
    }else if ([confMode isEqualToString:@"mainCamera"]) {
        self.confModeStr = SIMLocalizedString(@"ConfModelMainCameraTitle", nil);
    }else if ([confMode isEqualToString:@"intercom"]) {
        self.confModeStr = SIMLocalizedString(@"ConfModelIntercomTitle", nil);
    }else if ([confMode isEqualToString:@"EHSfieldOperation"]) {
        self.confModeStr = SIMLocalizedString(@"ConfModelEHSfieldOperationTitle", nil);
    }else if ([confMode isEqualToString:@"voiceSeminar"]) {
        self.confModeStr = SIMLocalizedString(@"ConfModelVoiceSeminarTitle", nil);
    }else if ([confMode isEqualToString:@"trainingConference"]) {
        self.confModeStr = SIMLocalizedString(@"ConfModelTrainingConferenceTitle", nil);
    }
}
- (void)setConfdocList:(NSArray *)confdocList {
    _confdocList = confdocList;
    NSMutableArray *groups = @[].mutableCopy;
    for (id dic in _confdocList) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            SIMConfDocModel *gp = [[SIMConfDocModel alloc] initWithDictionary:dic];
            [groups addObject:gp];
        }
    }
    _confdocList = groups.copy;
}

@end
@implementation ConfModelModel : NSObject
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //    NSLog(@"%@",key);
}

@end
