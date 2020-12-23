//
//  SIMChatMapViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/8/9.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMChatMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import<CoreLocation/CoreLocation.h>
#import<MapKit/MapKit.h>
@interface SIMChatMapViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) NSString *loacionStr;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, strong) UIView *bottomV;

@end

@implementation SIMChatMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_data.loacionStr containsString:@","]) {
        NSArray *array = [_data.loacionStr componentsSeparatedByString:@","];
        self.navigationItem.title = array[0];
    }else {
        self.navigationItem.title = _data.loacionStr;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setMapInit];
    [self bottomViewUI];
}
- (void)setMapInit {
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [_mapView setZoomLevel:15 animated:YES];
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    ///把地图添加至view
    [self.view addSubview:_mapView];
    // 自定义的呼吸圈
    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
    r.showsAccuracyRing  = NO;
    [_mapView updateUserLocationRepresentation:r];
    // 定位当前位置
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.locatingWithReGeocode = YES;
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    self.locationManager.locationTimeout = 2;
    self.locationManager.reGeocodeTimeout = 2;
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    __weak typeof(self) weakSelf = self;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            if (error.code == AMapLocationErrorLocateFailed)
            {
                [self addAdressAlertViewController];// 定位失败提示用户检查网络或者开启定位权限
                return;
            }
        }
        NSLog(@"location:%@", location);
        weakSelf.latitude = location.coordinate.latitude;
        weakSelf.longitude = location.coordinate.longitude;
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
            weakSelf.loacionStr = [NSString stringWithFormat:@"%@,%@",regeocode.AOIName,regeocode.formattedAddress];
        }
    }];
    NSLog(@"展示地图接受到的位置信息:{lat:%f; lon:%f; str:%@} ",_data.latitude,_data.longitude,_data.loacionStr);
    // 为收到的地理位置添加锚点
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(_data.latitude, _data.longitude);
    [_mapView addAnnotation:pointAnnotation];
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(_data.latitude, _data.longitude)];
}
- (void)bottomViewUI {
    _bottomV = [[UIView alloc] init];
    _bottomV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomV];
    [_bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(BottomSaveH + 100);
    }];
    UIButton *button = [[UIButton alloc] init];
//    button.backgroundColor = BlueButtonColor;
    [button setImage:[UIImage imageNamed:@"聊天里坐标指示"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goToMap) forControlEvents:UIControlEventTouchUpInside];
    [_bottomV addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.height.width.mas_equalTo(50);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textColor = BlackTextColor;
    titleLab.font = FontRegularName(16);
    [_bottomV addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(button.mas_top);
        make.right.mas_equalTo(button.mas_left).offset(-15);
    }];
    UILabel *subLab = [[UILabel alloc] init];
    subLab.textColor = GrayPromptTextColor;
    subLab.font = FontRegularName(13);
    [_bottomV addSubview:subLab];
    [subLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(titleLab);
        make.top.mas_equalTo(titleLab.mas_bottom).offset(5);
    }];
    if ([_data.loacionStr containsString:@","]) {
        NSArray *array = [_data.loacionStr componentsSeparatedByString:@","];
        titleLab.text = array[0];
        subLab.text = array[1];
    }else {
        titleLab.text = _data.loacionStr;
        subLab.text = @"";
    }
}
- (void)goToMap {
    [self addActionSheet];
}
#pragma mark -- UIAlertViewDelegate
- (void)addActionSheet{
    NSString *toLocationStr;
    if ([_data.loacionStr containsString:@","]) {
        NSArray *array = [_data.loacionStr componentsSeparatedByString:@","];
        toLocationStr = array[0];
    }else {
        toLocationStr = _data.loacionStr;
    }
    NSLog(@"toLocationStr %@",toLocationStr);
    
    NSMutableArray *mapsA = [NSMutableArray array];
    //苹果原生地图方法和其他不一样
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [mapsA addObject:iosMapDic];
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&slat=&slon=&sname=&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&t=2",@"开会宝云会议",_data.latitude,_data.longitude,toLocationStr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        gaodeMapDic[@"url"] = urlString;
        [mapsA addObject:gaodeMapDic];
    }
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=gcj02",_data.latitude,_data.longitude,toLocationStr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        baiduMapDic[@"url"] = urlString;
        [mapsA addObject:baiduMapDic];
    }
    //手机地图个数判断
    if (mapsA.count > 0) {
        //选择
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        NSInteger index = mapsA.count;
        
        for (int i = 0; i < index; i++) {
            
            NSString *title = mapsA[i][@"title"];
            NSString *urlString = mapsA[i][@"url"];
            if (i == 0) { // 固定苹果系统地图
                UIAlertAction *iosAntion = [UIAlertAction actionWithTitle:title style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    CLLocationCoordinate2D gps = CLLocationCoordinate2DMake(_data.latitude, _data.longitude);
                    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
                    MKPlacemark *palce = [[MKPlacemark alloc] initWithCoordinate:gps addressDictionary:nil];
                    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:palce];
                    toLocation.name = toLocationStr;
                    NSArray *items = @[currentLoc,toLocation];
                    NSDictionary *dic = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsMapTypeKey: @(MKMapTypeStandard),MKLaunchOptionsShowsTrafficKey: @(YES)};
                    [MKMapItem openMapsWithItems:items launchOptions:dic];
                }];
                [alertVC addAction:iosAntion];
                continue;
            }
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                
            }];
            
            [alertVC addAction:action];
        }
        
        UIAlertAction *cancleAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertVC addAction:cancleAct];
        alertVC.popoverPresentationController.sourceView = self.view;
        alertVC.popoverPresentationController.sourceRect = self.bottomV.frame;
        alertVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        [self presentViewController:alertVC animated:YES completion:^{
            
        }];
    }else{
        [MBProgressHUD cc_showText:@"未检测到地图应用"];
    }
}
// 通讯录未开启权限弹框
- (void)addAdressAlertViewController {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"定位失败" message:@"请检查网络或者开启定位权限，［设置] -- [开会宝]中打开[定位]开关，允许使用应用期间定位" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCSet", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳入当前App设置界面,
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if( [[UIApplication sharedApplication]canOpenURL:url] ) {
            [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL        success) {
            }];
        }
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVc presentViewController:alertView animated:YES completion:nil];
}

@end
