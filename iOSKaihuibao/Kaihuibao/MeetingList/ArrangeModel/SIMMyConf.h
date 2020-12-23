//
//  SIMMyConf.h
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/24.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIMMyConf : NSObject
// 个人会议编辑
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *live_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *normalPassword;
@property (nonatomic, strong) NSString *mainPassword;
//@property (nonatomic, assign) BOOL host_video;
//@property (nonatomic, assign) BOOL member_video;
//@property (nonatomic, assign) BOOL before_host;
//@property (nonatomic, assign) BOOL user_only;
//@property (nonatomic, assign) BOOL public_conf;
//@property (nonatomic, assign) BOOL live_conf;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
