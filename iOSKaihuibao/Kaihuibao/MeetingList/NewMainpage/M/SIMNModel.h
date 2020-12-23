//
//  SIMNModel.h
//  Kaihuibao
//
//  Created by mac126 on 2018/9/3.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIMNModel : NSObject
@property (nonatomic, strong) NSString *mainTitle;
@property (nonatomic, strong) NSString *isMore;
@property (nonatomic, strong) NSString *serial;
@property (nonatomic, strong) NSArray *btn_list;// 各个按钮

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
@interface SIMNModel_btnList : NSObject
/** 名字*/
@property (nonatomic, copy) NSString *bannerPic;
@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, copy) NSString *serial;
@property (nonatomic, copy) NSString *midURL;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *descriptionStr;
@property (nonatomic, assign) BOOL webData;
@property (nonatomic, assign) BOOL isOne;
@property (nonatomic, assign) CGFloat heigt;
@property (nonatomic, copy) NSString *space_type;
@property (nonatomic, assign) BOOL isbuy;
@property (nonatomic, copy) NSArray *buttons_info;
@property (nonatomic, copy) NSString *conf_type;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
