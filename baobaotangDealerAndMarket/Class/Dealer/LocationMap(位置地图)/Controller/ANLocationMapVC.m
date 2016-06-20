//
//  ANLocationMapVC.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/5/21.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANLocationMapVC.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import "MJRefresh.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface ANLocationMapVC ()<AMapSearchDelegate, MAMapViewDelegate, UITableViewDelegate, UITableViewDataSource, AMapLocationManagerDelegate>
{
    AMapSearchAPI *_search;
    MAMapView *_mapView;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) CLLocationCoordinate2D location;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) MAPointAnnotation *pointAnnotation;

@end

@implementation ANLocationMapVC

- (MAPointAnnotation *)pointAnnotation
{
    if (_pointAnnotation == nil) {
        _pointAnnotation = [[MAPointAnnotation alloc] init];
        _pointAnnotation.coordinate = self.location;
        _pointAnnotation.title = self.subStoreModel.title;
        _pointAnnotation.subtitle = self.subStoreModel.address;
        [_mapView addAnnotation:_pointAnnotation];
    }
    return _pointAnnotation;
}

- (UIView *)headView
{
    if (_headView == nil) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, WIDTH, 40)];
        label.text = self.subStoreModel.address;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:0.2784 green:0.1922 blue:0.3686 alpha:1.0];
        [_headView addSubview:label];
    }
    return _headView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HIGH / 2 - 64 + 100, WIDTH, HIGH / 2 - 100) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.tableHeaderView = self.headView;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    }
    return _tableView;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //配置用户Key
    [MAMapServices sharedServices].apiKey = LBS_MAP_KEY;
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    _mapView.zoomLevel = 12;
    _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    [self.view addSubview:_mapView];
    
    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = LBS_MAP_KEY;
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    if ([self.subStoreModel.latitude isEqualToString:@"0.00000000"]) {
        self.page = 1;
    }else {
        //构造AMapReGeocodeSearchRequest对象
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location = [AMapGeoPoint locationWithLatitude:[self.subStoreModel.latitude floatValue] longitude:[self.subStoreModel.longitude floatValue]];
        regeo.requireExtension = YES;
        regeo.radius = 100000;
        
        //发起逆地理编码
        [_search AMapReGoecodeSearch: regeo];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNav];
}
- (void)setNav {
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    // 设置标题
    self.navigationItem.title = @"地址";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  实现逆地理编码的回调函数   当有经纬度时走这个代理方法插入标注
 */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil) {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        NSLog(@"ReGeo: %@", result);
        [self insertAnnotationWithLatitude:request.location.latitude andLongitude:request.location.longitude];
        [self moveMapWithLatitude:request.location.latitude andLongitude:request.location.longitude];
    }
}
#pragma mark POI检索模块
//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    if (self.page > 1) {
        [self.tableView.mj_footer endRefreshing];
        [self.dataArr addObjectsFromArray:response.pois];
        [self.tableView reloadData];
    }else {
        self.dataArr = [NSMutableArray arrayWithArray:response.pois];
        [self.view addSubview:self.tableView];
    }
    // 检索结果又多页时
    if (self.dataArr.count < response.count) {
        self.page ++ ;
        [self tableViewLoadData];
    }else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    //通过 AMapPOISearchResponse 对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld",(long)response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
}
/**
 *  插入标注的回调方法
 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}
/**
 *  定位后的回调
 */
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        pre.image = [UIImage imageNamed:@"location.png"];
        pre.lineWidth = 3;
        pre.lineDashPattern = @[@6, @3];
        
        [_mapView updateUserLocationRepresentation:pre];
        
        MAUserLocation *userLocation = (MAUserLocation *)view.annotation;
        self.location = userLocation.coordinate;
        
        if ([self.subStoreModel.latitude isEqualToString:@"0.00000000"]) {
            [self searchPoi];
        }
        view.calloutOffset = CGPointMake(0, 0);
    } 
}
#pragma mark map自定义方法
/**
 *  向地图中插入标注
 *
 *  @param latitude  要插入的位置
 *  @param longitude 要插入的位置
 */
- (void)insertAnnotationWithLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude
{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    pointAnnotation.title = self.subStoreModel.title;
    pointAnnotation.subtitle = self.subStoreModel.address;
    [_mapView addAnnotation:pointAnnotation];
}
/**
 *  当获取不到经纬的时候会发起POI检索
 *
 *  @param latitude  当前位置
 *  @param longitude 当前位置
 */
- (void)searchPoi
{
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:self.location.latitude longitude:self.location.longitude];
    request.keywords = self.subStoreModel.address;
    request.sortrule = 0;
    request.radius = 50000;
    request.page = self.page;
    request.requireExtension = YES;
    //发起周边搜索
    [_search AMapPOIAroundSearch: request];
}
/**
 *  改变地图的中心位置
 */
- (void)moveMapWithLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    [_mapView setCenterCoordinate:coordinate animated:YES];
}
/**
 *  单次定位
 */
- (void)signleLocation
{
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        [AMapLocationServices sharedServices].apiKey = LBS_MAP_KEY;
    
        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate = self;
    
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        //   定位超时时间，可修改，最小2s
        self.locationManager.locationTimeout = 3;
        //   逆地理请求超时时间，可修改，最小2s
        self.locationManager.reGeocodeTimeout = 3;
    
        // 带逆地理（返回坐标和地址信息）
        [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
    
            if (error)
            {
                NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    
    //            if (error.code == AMapLocatingErrorLocateFailed)
    //            {
    //                return;
    //            }
            }
    
            NSLog(@"location:%@", location);
    
            if (regeocode)
            {
                NSLog(@"reGeocode:%@", regeocode);
            }
        }];
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"location"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"location"];
    }
    AMapPOI *p = self.dataArr[indexPath.row];
    cell.textLabel.text = p.address;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorWithRed:0.2784 green:0.1922 blue:0.3686 alpha:1.0];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapPOI *p = self.dataArr[indexPath.row];
    self.pointAnnotation.coordinate = CLLocationCoordinate2DMake(p.location.latitude, p.location.longitude);
    self.pointAnnotation.subtitle = p.address;
    [_mapView selectAnnotation:self.pointAnnotation animated:YES];
    [self moveMapWithLatitude:p.location.latitude andLongitude:p.location.longitude];
}

#pragma mark TableView 加载
- (void)tableViewLoadData
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(searchPoi)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
