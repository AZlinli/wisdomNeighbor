//
//  XKBaiduLocation.m
//  MasonryTest
//
//  Created by hupan on 2018/8/16.
//  Copyright © 2018年 Tears. All rights reserved.
//

#import "XKBaiduLocation.h"
#import "CYLTabBarController.h"
//#import "XKLaunchAdvertisementViewController.h"
#import "XKAlertView.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import "BaiduMapAPI_Utils/BMKUtilsComponent.h"
#import <BMKLocationKit/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>


@interface XKBaiduLocation ()<BMKGeoCodeSearchDelegate, BMKPoiSearchDelegate, BMKSuggestionSearchDelegate, BMKLocationManagerDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) BMKLocationManager  *locationManager;
@property (nonatomic, strong) BMKGeoCodeSearch    *searcher;

@property (nonatomic, assign) double              laititude;
@property (nonatomic, assign) double              longtitude;
@property (nonatomic, copy  ) NSString            *country;     //国家
@property (nonatomic, copy  ) NSString            *state;       //省会
@property (nonatomic, copy  ) NSString            *city;        //城市
@property (nonatomic, copy  ) NSString            *subLocality; //区
@property (nonatomic, copy  ) NSString            *name;        //名字


@end

static XKBaiduLocation *_shareManager;

@implementation XKBaiduLocation

+ (instancetype)locationManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_shareManager) {
            _shareManager = [[XKBaiduLocation alloc] init];
            _shareManager.laititude = 0.0;
            _shareManager.longtitude = 0.0;
        }
    });
    return _shareManager;
}


- (void)setLocationDelegate:(id)delegate {
    self.delegate = delegate;
}


- (CLLocationCoordinate2D)getUserLocationLaititudeAndLongtitude {
    return CLLocationCoordinate2DMake(self.laititude, self.longtitude);
}

- (void)setUserLocationLaititude:(double)lat longtitude:(CGFloat)lng {
    self.laititude = lat;
    self.longtitude = lng;
}


- (NSString *)getUserLocationCountry {
    return self.country;
}

- (NSString *)getUserLocationState {
    return self.state;
}

- (NSString *)getUserLocationCity {
    return self.city;
}

- (NSString *)getUserLocationSubLocality {
    return self.subLocality;
}

- (NSString *)getUserLocationName {
    return self.name;
}

- (BOOL)locationAuthorized {
    
    BOOL isAuthorized = NO;
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        isAuthorized = NO;
        if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[CYLTabBarController class]]) {
            CYLTabBarController *vc = (CYLTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//            if (![vc.presentedViewController isKindOfClass:[XKLaunchAdvertisementViewController class]]) {
                [self showLocationAuthorizedMessage];
//            }
        } else {
            [self showLocationAuthorizedMessage];
        }
    } else { //开启的
        isAuthorized = YES;
    }
    return isAuthorized;
}


- (void)showLocationAuthorizedMessage {
    
    [XKAlertView showCommonAlertViewWithTitle:@"定位服务未开启\n请在系统设置中开启定位服务" leftText:@"暂不" rightText:@"去设置" leftBlock:^{
        
    } rightBlock:^{
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }];
}


- (void)startBaiduSingleLocationService {
    
    if ([self locationAuthorized]) {
        XKWeakSelf(weakSelf);
        [self.locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
            
            if (error) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(failToLocateUserWithError:)]) {
                    [weakSelf.delegate failToLocateUserWithError:error];
                }
            } else {
                weakSelf.laititude = location.location.coordinate.latitude;
                weakSelf.longtitude = location.location.coordinate.longitude;
                
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(userLocationLaititude:longtitude:)]) {
                    [weakSelf.delegate userLocationLaititude:weakSelf.laititude longtitude:weakSelf.longtitude];
                }
                
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(userLocationCountry:state:city:subLocality:name:)]) {
                    [weakSelf getAddressByLatitude:weakSelf.laititude longitude:weakSelf.longtitude];
                }
            }
        }];
    }
}



/**
 根据关键字返回检索结果
 */
- (void)getSuggestionSearchWithCityName:(nonnull NSString *)cityName keyword:(nonnull NSString *)keyword cityLimit:(BOOL)cityLimit {
    if (!cityName || !keyword) {
        return;
    }
    BMKSuggestionSearch *suggestionSearch = [[BMKSuggestionSearch alloc] init];
    suggestionSearch.delegate = self;
    BMKSuggestionSearchOption* suggestionOption = [[BMKSuggestionSearchOption alloc] init];
    suggestionOption.keyword = keyword;
    suggestionOption.cityname = cityName;
    suggestionOption.cityLimit = cityLimit;
    /**
     关键词检索，异步方法，返回结果在BMKSuggestionSearchDelegate 的onGetSuggestionResult里 suggestionOption sug检索信息类
     成功返回YES，否则返回NO
     */
    BOOL flag = [suggestionSearch suggestionSearch:suggestionOption];
    if(flag) {
        NSLog(@"关键词检索成功");
    } else {
        NSLog(@"关键词检索失败");
    }
}


#pragma mark - BMKSuggestionSearchDelegate
/**
 关键字检索结果回调
 @param searcher 检索对象
 @param result 关键字检索结果
 @param error 错误码，@see BMKCloudErrorCode
 */
- (void)onGetSuggestionResult:(BMKSuggestionSearch *)searcher result:(BMKSuggestionSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        //实现对检索结果的处理
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyWordSearchAddressList:)]) {
            [self.delegate keyWordSearchAddressList:result.suggestionList];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyWordSearchAddressList:)]) {
            [self.delegate keyWordSearchAddressList:@[]];
        }
    }
}



/**
 根据关键字拿poi检索信息
 */
- (void)getPOICitySearchWithCityName:(nonnull NSString *)cityName keyword:(nonnull NSString *)keyword pageIndex:(NSInteger)pageIndex {
    if (!cityName || !keyword) {
        return;
    }
    BMKPoiSearch *poiSearch = [[BMKPoiSearch alloc] init];
    poiSearch.delegate = self;
    
    //初始化请求参数类BMKCitySearchOption的实例
    BMKPOICitySearchOption *cityOption = [[BMKPOICitySearchOption alloc] init];
    cityOption.keyword = keyword;
    cityOption.city = cityName;
    cityOption.isCityLimit = YES;
    cityOption.pageIndex = pageIndex;
    /// 单次召回POI数量，默认为10条记录，最大返回20条。
    cityOption.pageSize = 20;

    
    BOOL flag = [poiSearch poiSearchInCity:cityOption];
    if(flag) {
        NSLog(@"POI城市内检索成功");
    } else {
        NSLog(@"POI城市内检索失败");
    }
}

    

/**
 搜索 指定位置附近的地址
 */

- (void)getPoiNearbySearchWithLocation:(CLLocationCoordinate2D)location searchRadius:(NSInteger)searchRadius {

    BMKPoiSearch *poiSearch = [[BMKPoiSearch alloc] init];
    poiSearch.delegate = self;
    //初始化请求参数类BMKNearbySearchOption的实例
    BMKPOINearbySearchOption *nearbyOption = [[BMKPOINearbySearchOption alloc] init];
    /**
     检索关键字，必选。
     在周边检索中关键字为数组类型，可以支持多个关键字并集检索，如银行和酒店。每个关键字对应数组一个元素。
     最多支持10个关键字。
     */
    nearbyOption.keywords = @[@"街道", @"写字楼", @"店铺", @"住宅", @"商业广场", @"影院", @"公园", @"学校", @"医院", @"车站"];
    //检索中心点的经纬度，必选
    nearbyOption.location = location;
    //检索半径，单位是米。 当半径过大，超过中心点所在城市边界时，会变为城市范围检索，检索范围为中心点所在城市
    nearbyOption.radius = searchRadius;
    
    nearbyOption.pageIndex = 0;
    //单次召回POI数量，默认为10条记录，最大返回20条。
    nearbyOption.pageSize = 100;
    /**
     根据中心点、半径和检索词发起周边检索：异步方法，返回结果在BMKPoiSearchDelegate 的onGetPoiResult里 nearbyOption 周边搜索的搜索参数类
     成功返回YES，否则返回NO
     */
    BOOL flag = [poiSearch poiSearchNearBy:nearbyOption];
    if(flag) {
        NSLog(@"POI周边检索成功");
    } else {
        NSLog(@"POI周边检索失败");
    }
}


#pragma mark - BMKPoiSearchDelegate

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPOISearchResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(userNearbySearchAddressList:)]) {
            [self.delegate userNearbySearchAddressList:poiResult.poiInfoList];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyWordSearchAddressList:)]) {
            [self.delegate keyWordSearchAddressList:poiResult.poiInfoList];
        }
        
    } else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
        if (self.delegate && [self.delegate respondsToSelector:@selector(userNearbySearchAddressList:)]) {
            [self.delegate userNearbySearchAddressList:@[]];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyWordSearchAddressList:)]) {
            [self.delegate keyWordSearchAddressList:@[]];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(userNearbySearchAddressList:)]) {
            [self.delegate userNearbySearchAddressList:@[]];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyWordSearchAddressList:)]) {
            [self.delegate keyWordSearchAddressList:@[]];
        }
        NSLog(@"抱歉，未找到结果");
    }
}



/*
- (void)getNearbySearch {
    
    //发起检索
    BMKReverseGeoCodeSearchOption *option = [[BMKReverseGeoCodeSearchOption alloc] init];
    option.location = CLLocationCoordinate2DMake(self.laititude, self.longtitude);
    BOOL flag = [self.searcher reverseGeoCode:option];
    if(flag) {
        NSLog(@"逆geo检索发送成功");
    } else {
        NSLog(@"逆geo检索发送失败");
    }
}

#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {

    if (error == BMK_OPEN_NO_ERROR) {
        for (BMKPoiInfo *info in result.poiList) {
            NSLog(@"%@-%@", info.name, info.address);
        }
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}*/


#pragma mark - BMKLocationManagerDelegate

- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(failToLocateUserWithError:)]) {
        [self.delegate failToLocateUserWithError:error];
    }
}


#pragma mark -根据坐标取得地名-
- (void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    
    //反地理编码
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLGeocoder * geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks firstObject];
        NSDictionary *addressDic = placemark.addressDictionary;
        /*
         City = "成都市";
         Country = "中国";
         CountryCode = CN;
         FormattedAddressLines =     (
         "中国四川省成都市武侯区"
         );
         Name = "桂溪街道";
         State = "四川省";
         SubLocality = "武侯区";
         */
        
        NSString *country = [addressDic objectForKey:@"Country"];
        NSString *state = [addressDic objectForKey:@"State"];
        NSString *city = [addressDic objectForKey:@"City"];
        NSString *subLocality = [addressDic objectForKey:@"SubLocality"];
        NSString *name = [addressDic objectForKey:@"Name"];
        
        self.country = country;
        self.state = state;
        self.city = city;
        self.subLocality = subLocality;
        self.name = name;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(userLocationCountry:state:city:subLocality:name:)]) {
            [self.delegate userLocationCountry:country state:state city:city subLocality:subLocality name:name];
        }
    }];
}


/**
 获取某个经纬度距离当前位置的距离
 
 @param latitude 目标维度
 @param longitude 目标精度
 @return 距离 以米为单位
 */
- (CGFloat)getDistanceFromCurrentLocationWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude {
    if (self.laititude == 0.0 && self.longtitude == 0.0) {
        return -1.0;
    }
    BMKMapPoint fromPoint = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(self.laititude, self.longtitude));
    BMKMapPoint toPoint = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(latitude, longitude));
    return BMKMetersBetweenMapPoints(fromPoint, toPoint);
}

#pragma mark - Lazy load


- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
        //初始化实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置delegate
        _locationManager.delegate = self;
        //设置返回位置的坐标系类型
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
        //_locationManager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        _locationManager.locationTimeout = 10;
        //设置获取地址信息超时时间
        _locationManager.reGeocodeTimeout = 10;
    }
    return _locationManager;
}


- (BMKGeoCodeSearch *)searcher {
    if (!_searcher) {
        _searcher = [[BMKGeoCodeSearch alloc] init];
        _searcher.delegate = self;
    }
    return _searcher;
}


- (void)dealloc {
    _searcher.delegate = nil;
    _locationManager.delegate = nil;
}


@end
