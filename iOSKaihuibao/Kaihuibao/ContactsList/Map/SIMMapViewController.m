//
//  SIMMapViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/7/6.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "SIMAnnotationView.h"
#import "SIMUserLocationAnnotationView.h"
@interface SIMMapViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate,CLConferenceDelegate>
{
    MAMapView *_mapView;
}
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
@property (nonatomic, strong) NSString *nowloacationStr;
@property (nonatomic, strong) NSString *nowbuildStr;
@property (nonatomic, strong) AMapSearchAPI *search;
@end

@implementation SIMMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = SIMLocalizedString(@"CCMapTitle", nil);
    self.view.backgroundColor = [UIColor whiteColor];
//    if ([self.type isEqualToString:@"sendMessageMap"]) {
//        UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(barBtnClick)];
//        self.navigationItem.rightBarButtonItem = barBtn;
//    }
    
    [self setMapInit];
}
//- (void)barBtnClick {
//    NSLog(@"当前的位置呀location:{lat:%f; lon:%f;%@}", _mapView.centerCoordinate.latitude, _mapView.centerCoordinate.longitude,_nowloacationStr);
//    if (_mapView.centerCoordinate.latitude > 0) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(buttonNowLoactionWithLat:andLon:locationStr:)]) {
//            [self.delegate buttonNowLoactionWithLat:_mapView.centerCoordinate.latitude andLon:_mapView.centerCoordinate.longitude locationStr:_nowloacationStr];
//        }
//    }
//    [self.navigationController popViewControllerAnimated:YES];
////    __block UIImage *screenshotImage = nil;
////    __block NSInteger resState = 0;
////    __weak typeof(self) weakSelf = self;
////    [_mapView takeSnapshotInRect:CGRectMake(0, 0, screen_width, 200) withCompletionBlock:^(UIImage *resultImage, NSInteger state) {
////        screenshotImage = resultImage;
////        resState = state; // state表示地图此时是否完整，0-不完整，1-完整
////
////        NSLog(@"screenshotImageone %@",screenshotImage);
////        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(buttonSnapshootImage:)]) {
////            [weakSelf.delegate buttonSnapshootImage:screenshotImage];
////        }
////        [weakSelf.navigationController popViewControllerAnimated:YES];
////    }];
//
//
//}
- (void)setMapInit {
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [_mapView setZoomLevel:13 animated:YES];
    
    ///把地图添加至view
    [self.view addSubview:_mapView];
    
    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
    r.showsAccuracyRing  = NO;
    [_mapView updateUserLocationRepresentation:r];
    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    
    self.locationManager = [[AMapLocationManager alloc] init];

    [self.locationManager setDelegate:self];

    [self.locationManager setPausesLocationUpdatesAutomatically:NO];

//    [self.locationManager setAllowsBackgroundLocationUpdates:YES];

//    [self.locationManager startUpdatingLocation];
    
//    self.search = [[AMapSearchAPI alloc] init];
//    self.search.delegate = self;
}

/*!
 @brief 根据anntation生成对应的View
 @param mapView 地图View
 @param annotation 指定的标注
 @return 生成的标注View
 */
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        SIMUserLocationAnnotationView *annotationView = (SIMUserLocationAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[SIMUserLocationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            annotationView.image = [UIImage imageNamed:@"定位圆点"];
        }
        annotationView.canShowCallout = YES;
        // 锚点上气泡视图 自定义
        SIMAnnotationView *calloutView = [[SIMAnnotationView alloc] initWithFrame:CGRectMake(0, 0, kWidthScale(200), kWidthScale(140))];
        // 调整气泡框位置
        calloutView.center = CGPointMake(CGRectGetWidth(annotationView.bounds) / 2.f + annotationView.calloutOffset.x,-CGRectGetHeight(calloutView.bounds) / 2.f + annotationView.calloutOffset.y);

        // 点击进入会议按钮
        __weak typeof(self) weakSelf = self;
        calloutView.inviteClick = ^{

//            NSString *string = [SIMNewEnterConfTool passWordFromUserDefaults];
            // 调用会议接口
//            if (![SIMEnterConfTool  avauthorizationStatusWithViewController:self]) return;
//            [SIMEnterConfTool transferVideoMethodWithUid:weakSelf.currentUser.uid name:weakSelf.currentUser.nickname token:[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"] confID:weakSelf.currentUser.self_conf psw:string signID:@"1" viewController:weakSelf];
            [SIMNewEnterConfTool enterTheMineConfWithCid:weakSelf.currentUser.self_conf psw:@""  confType:EnterConfTypeConf isJoined:NO viewController:weakSelf];
        };
        // 弹出气泡视图
        annotationView.customCalloutView = (MACustomCalloutView *)calloutView;
        
        self.userLocationAnnotationView = annotationView;
//        dispatch_async(dispatch_get_main_queue(), ^{
            [_mapView selectAnnotation:annotation animated:NO];
//        });
        return annotationView;
    }
    return nil;
}
#pragma mark -- 定位当前位置 回调
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    //定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    _mapView.centerCoordinate = location.coordinate;
//    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
//    regeo.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
//    regeo.requireExtension = YES;
//    [self.search AMapReGoecodeSearch:regeo];

}
///* 逆地理编码回调. */
//- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
//{
//    if (response.regeocode != nil)
//    {
//        _nowloacationStr = response.regeocode.formattedAddress;
//        _nowbuildStr = response.regeocode.addressComponent.township;
//        //解析response获取地址描述，具体解析见 Demo
//        NSLog(@"searchresultloaction %@  建筑物是%@  %@",_nowloacationStr,_nowbuildStr,response.regeocode.addressComponent.district);
//    }
//}

@end
