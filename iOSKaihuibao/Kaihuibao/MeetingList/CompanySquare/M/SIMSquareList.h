//
//  SIMSquareList.h
//  Kaihuibao
//
//  Created by mac126 on 2018/8/16.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIMSquareList : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *shop_list;// 含广告

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
@interface SIMSquareList_goodlist : NSObject
@property (nonatomic, copy) NSString *bannercarouselURL; // 商品使用的图片
@property (nonatomic, copy) NSString *goodname; // 这个是商铺的详情
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *goods_num;
@property (nonatomic, copy) NSString *iconcarouselURL;// 暂时没用
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat high;
@property (nonatomic, copy) NSString *sale_count;
@property (nonatomic, copy) NSString *serial; // 商品的id 也是商铺的id
@property (nonatomic, copy) NSString *shop_serial;// 如果有商品时候 店铺的id （没有商品时候 没有这个参数 店铺id为serial）
@property (nonatomic, copy) NSString *visitors; // 访客数
@property (nonatomic, copy) NSString *share_describe;// 这个是商品的详情
@property (nonatomic, copy) NSString *middlecarouselURL;// 假数据跳转详情页面的长图
@property (nonatomic, copy) NSString *callback;//表单量
@property (nonatomic, copy) NSString *sale;//销售量
@property (nonatomic, copy) NSString *shop_img;// 店铺主图  店铺使用的图片
@property (nonatomic, copy) NSString *cid;// 直播id 店铺才有的 商品用的是myvideos
@property (nonatomic, copy) NSString *normal_password;// 直播密码
@property (nonatomic, copy) NSArray *myvideos; // 商品的客服 默认是数组 但是取第0个使用

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface SIMSquareList_goodlist_myvideos : NSObject
@property (nonatomic, copy) NSString *myvideo_create_time;
@property (nonatomic, copy) NSString *myvideo_name;
@property (nonatomic, copy) NSString *myvideo_serial;
@property (nonatomic, copy) NSString *main_password;
@property (nonatomic, copy) NSString *normal_password;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

//bannercarouselURL = "https://video.kaihuibao.net/carousel/img/IMG201808161126292556.jpeg";
//callback = 0;
//cid = 38299307486;
//"create_time" = "2018-08-16 14:39:40";
//gid = 404104553;
//goodname = "\U6d4b\U8bd5\U5546\U54c12";
//"goods_num" = 5;
//iconcarouselURL = "https://video.kaihuibao.net/carousel/img/IMG201808161126268397.jpeg";
//"is_putaway" = 1;
//name = 3;
//sale = 600;
//serial = 15815796385;
//"share_describe" = 3;
//"shop_img" = "";
//sign = 0;
//visitors = 0;
