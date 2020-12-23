//
//  SIMSendMapViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/8/9.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMSendMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "SIMAnnotationView.h"
#import "SIMUserLocationAnnotationView.h"
#import "SIMSearchMapResultViewController.h"
@interface SIMSendMapViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate,CLConferenceDelegate,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate,SIMSearchMapResultViewDelegate,UIGestureRecognizerDelegate>
{
    BOOL _isDrag; // 标记是手动托还是点击的cell
    BOOL _isfooterMore; // 标记是刷新还是加载更多
    NSInteger _pageNumber; // 上拉加载第几页 从1开始
    BOOL _isFirstIn; // 标记是不是第一次进入页面如果是 不要大头针动画
}
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
//@property (nonatomic, strong) NSString *loacionStr;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, strong) AMapSearchAPI *search;
@property(nonatomic,strong) SIMSearchMapResultViewController *mySRTVC;// 展示搜索结果的VC
@property(nonatomic,strong) UISearchController *searchController;// 搜索条
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *searchResult;
@property (strong,nonatomic) NSMutableArray *datasArr;
@property (nonatomic, assign) NSInteger current;
@property (nonatomic, strong) UIImageView *imageViewAnt;

@end

@implementation SIMSendMapViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor whiteColor]]];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:ZJYColorHex(@"#f4f3f3")]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNumber = 1;
    _searchResult = [NSMutableArray array];
    _datasArr = [NSMutableArray array];
    
    self.navigationItem.title = @"位置";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(barBtnClick)];
    self.navigationItem.rightBarButtonItem = barBtn;
    
    [self setMapInit];
    [self addSearchBarUI];
    [self addTableView];
}
- (void)barBtnClick {
    AMapPOI *poi = _datasArr[_current];
    NSString *loacionStr = [NSString stringWithFormat:@"%@,%@",poi.name,poi.address];
    NSLog(@"要发送的当前的位置location:{lat:%f; lon:%f; str:%@}",poi.location.latitude, poi.location.longitude,loacionStr);
    if (poi.location.latitude > 0 && loacionStr.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(buttonNowLoactionWithLat:andLon:locationStr:)]) {
            [self.delegate buttonNowLoactionWithLat:poi.location.latitude andLon:poi.location.longitude locationStr:loacionStr];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- MapUIInit
- (void)setMapInit {
    ///初始化地图
    _mapView = [[MAMapView alloc] init];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [_mapView setZoomLevel:15 animated:YES];
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    ///把地图添加至view
    [self.view addSubview:_mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(55);
        make.height.mas_equalTo((screen_height - StatusNavH - 55)/2);
    }];
    _imageViewAnt = [[UIImageView alloc] init];
    _imageViewAnt.image = [UIImage imageNamed:@"poi_marker"];
    [self.view addSubview:_imageViewAnt];
    [_imageViewAnt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_mapView.mas_centerX);
        make.centerY.mas_equalTo(_mapView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 30));
    }];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
//    UIPanGestureRecognizer *mapPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mapPanGesture:)];
//    mapPanGesture.delegate = self;
//    mapPanGesture.cancelsTouchesInView = NO;
//    mapPanGesture.delaysTouchesEnded = NO;
//    [_mapView addGestureRecognizer:mapPanGesture];
    
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
    // 检索的主要api
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    // 当前定位位置的坐标以及信息
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
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
        }
        // 获取当前定位位置的附近兴趣点
        [self nowLocationOtherLoacteWithLat:location.coordinate.latitude andLong:location.coordinate.longitude isfooterMore:NO];
    }];
}
//- (void)mapPanGesture:(UIGestureRecognizer *)gesture
//{
//    if ([gesture state] == UIGestureRecognizerStateBegan) {
//        NSLog(@"拖动地图了");
//        CLLocationCoordinate2D centerCoordinate = _mapView.region.center;
//        // 获取当前定位位置的附近兴趣点
//        [self nowLocationOtherLoacteWithLat:centerCoordinate.latitude andLong:centerCoordinate.longitude isfooterMore:NO];
//        NSLog(@"拖拽地图时候的位置是:{lat:%f; lon:%f;}",centerCoordinate.latitude,centerCoordinate.longitude);
//
//        CGRect endFrame = _imageViewAnt.frame;
//        CGRect startFrame = endFrame;
//        startFrame.origin.y = _imageViewAnt.frame.origin.y - startFrame.size.height;
//        _imageViewAnt.frame = startFrame;
//        [UIView beginAnimations:@"drop" context:NULL];
//        [UIView setAnimationDuration:0.4];
//        _imageViewAnt.frame = endFrame;
//        [UIView commitAnimations];
//    }
//}
// 请求需要获取附近的兴趣点
- (void)nowLocationOtherLoacteWithLat:(double)latitude andLong:(double)longitude isfooterMore:(BOOL)isfooterMore {
    _current = 0;
    _isfooterMore = isfooterMore;
    _latitude = latitude;
    _longitude = longitude;
    NSInteger temp = 1;
    if (isfooterMore) {
        temp = _pageNumber + 1;
    }
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
//    request.keywords  = @"地名地址信息|美食|小区|商场|商务住宅|餐饮服务|生活服务";
    request.sortrule = 0;
    request.requireExtension = YES;
    request.page = temp;
    [self.search AMapPOIAroundSearch:request];
}
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (_isfooterMore) {
        _pageNumber += 1;// 如果是网络请求成功了 才加一
        if (response.pois.count < 20) {
            [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
    }else {
        _pageNumber = 1; // 当请求成功之后才去更改变量的值 防止中途有问题 导致变量提前变化 用户又去下拉加载的不准确
        [_datasArr removeAllObjects];
    }
    if (response.pois.count == 0)
    {
        [MBProgressHUD cc_showText:@"没有获取到该位置附近的兴趣点"];
        return;
    }else {
        //解析response获取POI信息
        [_datasArr addObjectsFromArray:response.pois];
//        for (AMapPOI *poi in response.pois) {
//            NSLog(@"response.pois %f %f %@ %@",poi.location.latitude,poi.location.longitude,poi.name,poi.address);
//        }
        [self.tableView reloadData];
        if (!_isfooterMore) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
}

#pragma mark -- SearchBar
- (void)addSearchBarUI {
    self.mySRTVC = [[SIMSearchMapResultViewController alloc] init];
    self.mySRTVC.mainSearchController = self;
    self.mySRTVC.delegate = self;
    self.searchController=[[UISearchController alloc]initWithSearchResultsController:self.mySRTVC];
    [self.searchController.searchBar sizeToFit];   //大小调整
    _searchController.searchBar.placeholder = @"搜索地点";
    _searchController.searchBar.barTintColor = [UIColor whiteColor];
    _searchController.searchBar.backgroundColor = [UIColor whiteColor];
    UITextField *searchField = [self.searchController.searchBar valueForKey:@"searchField"];
    searchField.textColor = BlackTextColor;
    searchField.font = FontRegularName(16);
    searchField.backgroundColor=ZJYColorHex(@"#ededee");
    // 更改背景颜色并去掉黑线
    UIImageView *barimag = [[[_searchController.searchBar.subviews firstObject] subviews] firstObject];
    barimag.layer.borderColor = [UIColor whiteColor].CGColor;
    barimag.layer.borderWidth = 1;
    //设置搜索控制器的结果更新代理对象
    self.searchController.searchResultsUpdater=self;
    self.searchController.searchBar.delegate=self;
    self.definesPresentationContext=YES;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 55)];
    [view addSubview:self.searchController.searchBar];
    [self.view addSubview:view];
}
#pragma mark - UISearchResultsUpdating
/**实现更新代理*/
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //获取到用户输入的数据
    NSString *searchText = searchController.searchBar.text;
    if (searchText.length > 0) {
        [self searchUserRequestData:searchText];
    }
    // 修改按钮文字为中文
//    searchController.searchBar.showsCancelButton = YES;
    for(id sousuo in [searchController.searchBar subviews])
    {
        for (id zz in [sousuo subviews])
        {
            if([zz isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)zz;
                [btn setTitle:SIMLocalizedString(@"AlertCCancel", nil) forState:UIControlStateNormal];
                [btn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
            }
        }
    }
}
//-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    [_searchResult removeAllObjects];
//    self.mySRTVC.datas = _searchResult;
//    NSLog(@"self.mySRTVC.searchResults222 %@",self.mySRTVC.datas);
//    /**通知结果ViewController进行更新*/
//    [self.mySRTVC.tableView reloadData];
//}
/* 搜索框搜索方法. */
- (void)searchUserRequestData:(NSString *)searchText {
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = searchText;
    [self.search AMapInputTipsSearch:tips];
}
/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    if (response.count == 0)
    {
        return;
    }else {
        self.mySRTVC.datas = response.tips;
        NSLog(@"self.mySRTVC.searchResults %@",self.mySRTVC.datas);
        /**通知结果ViewController进行更新*/
        [self.mySRTVC.tableView reloadData];
        
        for (AMapTip *taps in response.tips) {
            NSLog(@"response.tapis %f %f %@ %@",taps.location.latitude,taps.location.longitude,taps.name,taps.address);
        }
    }
}
#pragma mark -- SIMSearchMapResultViewDelegate
- (void)searchLoactionWithLat:(double)latitude andLon:(double)longitude locationStr:(NSString *)locationStr {
    _isDrag = NO;
    NSLog(@"搜索结果点击cell选择的位置是:{lat:%f; lon:%f; str:%@}",latitude,longitude,locationStr);
    self.searchController.searchBar.text = nil;
    // 地图移动到中心位置
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(latitude, longitude) animated:YES];
    // 获取当前定位位置的附近兴趣点
    [self nowLocationOtherLoacteWithLat:latitude andLong:longitude isfooterMore:NO];
}

#pragma mark -- TableView
- (void)addTableView {
    self.tableView = [[SIMContactTableView alloc] initPlainInViewController:self style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo((screen_height - StatusNavH - 55)/2);
    }];
    // 刷新 上拉加载 重新定位时候刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf nowLocationOtherLoacteWithLat:weakSelf.latitude andLong:weakSelf.longitude isfooterMore:YES];
    }];
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"mapCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse];
    }
    AMapPOI *poi = _datasArr[indexPath.row];
    cell.textLabel.font = FontRegularName(17);
    cell.textLabel.textColor = BlackTextColor;
    cell.detailTextLabel.font = FontRegularName(12);
    cell.detailTextLabel.textColor = GrayPromptTextColor;
    
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = poi.address;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _isDrag = NO;
    AMapPOI *poi = _datasArr[indexPath.row];
    NSString *loacionStr = [NSString stringWithFormat:@"%@,%@",poi.name,poi.address];
    // 地图移动到以该坐标为中心点
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude) animated:YES];
    NSLog(@"点击的cell兴趣点的位置location:{lat:%f; lon:%f; str:%@}",poi.location.latitude, poi.location.longitude,loacionStr);
    _current = indexPath.row;
    [tableView reloadData];
}
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (_current==indexPath.row) {
        return UITableViewCellAccessoryCheckmark;
    }else {
        return UITableViewCellAccessoryNone;
    }
}
#pragma mark -- MAMapViewDelegate
// 当用户拖拽地图的时候
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"拖拽地图时候上来就走");
    if (_isDrag) {
        CLLocationCoordinate2D centerCoordinate = mapView.region.center;
        // 获取当前定位位置的附近兴趣点
        [self nowLocationOtherLoacteWithLat:centerCoordinate.latitude andLong:centerCoordinate.longitude isfooterMore:NO];
        NSLog(@"拖拽地图时候的位置是:{lat:%f; lon:%f;}",centerCoordinate.latitude,centerCoordinate.longitude);

        CGRect endFrame = _imageViewAnt.frame;
        CGRect startFrame = endFrame;
        startFrame.origin.y = _imageViewAnt.frame.origin.y - startFrame.size.height;
        _imageViewAnt.frame = startFrame;
        [UIView beginAnimations:@"drop" context:NULL];
        [UIView setAnimationDuration:0.4];
        _imageViewAnt.frame = endFrame;
        [UIView commitAnimations];

    }else {
        _isDrag = YES;
        NSLog(@"拖拽地图时候变为了yes");
    }
}
// 定位未开启权限弹框
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
