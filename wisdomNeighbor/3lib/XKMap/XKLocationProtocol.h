//
//  XKLocationProtocol.h
//  XKSquare
//
//  Created by hupan on 2019/5/5.
//  Copyright © 2019年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@protocol XKLocationProtocol<NSObject>

@optional

+ (instancetype)locationManager /*DEPRECATED_MSG_ATTRIBUTE("具体工厂(如：XKBaiduMapFactory、XKGaodeMapFactory等)可以直接调用, 其他地方都使用[[XKMapManager getCurrentMapFactory] getMapLocation]代替")*/;

- (void)setLocationDelegate:(id)delegate;

/**
 判断定位权限
 
 @return 判断定位权限
 */
- (BOOL)locationAuthorized;

/**
 获取用户的经纬度
 
 @return 用户的经纬度
 */
- (CLLocationCoordinate2D)getUserLocationLaititudeAndLongtitude;


/**
 设置用户的经纬度
 
 */
- (void)setUserLocationLaititude:(double)lat longtitude:(CGFloat)lng;


/**
 获取用户所在地的国家
 
 @return 获取用户所在地的国家
 */
- (NSString *)getUserLocationCountry;

/**
 获取用户所在地的省会
 
 @return 获取用户所在地的省会
 */
- (NSString *)getUserLocationState;


/**
 获取用户所在地的城市
 
 @return 获取用户所在地的城市
 */
- (NSString *)getUserLocationCity;


/**
 获取用户所在城市的区
 
 @return 获取用户所在城市的区
 */
- (NSString *)getUserLocationSubLocality;

/**
 获取用户所在城市的具体位置
 
 @return 获取用户所在城市的具体位置
 */
- (NSString *)getUserLocationName;


/**
 开始单次定位
 */
- (void)startBaiduSingleLocationService;


/**
 获取附近建筑
*/
/** 暂不提供该方法
- (void)getNearbySearch;
*/



/**
 搜索 指定位置附近的地址
 
 @param location location(搜索中心的经纬度)
 @param searchRadius searchRadius(搜索半径)
 */
- (void)getPoiNearbySearchWithLocation:(CLLocationCoordinate2D)location searchRadius:(NSInteger)searchRadius;


/**
 根据关键字返回检索结果 [用下面这个方法]
 
 @param cityName cityName(搜索的城市区域)
 @param keyword keyword(关键字)
 @param cityLimit cityLimit(是否只返回对应城市结果)
 */
- (void)getSuggestionSearchWithCityName:(nonnull NSString *)cityName keyword:(nonnull NSString *)keyword cityLimit:(BOOL)cityLimit;


/**
 根据关键字返回检索结果
 */
- (void)getPOICitySearchWithCityName:(nonnull NSString *)cityName keyword:(nonnull NSString *)keyword pageIndex:(NSInteger)pageIndex;

/**
 获取某个经纬度距离当前位置的距离
 
 @param latitude 目标维度
 @param longitude 目标精度
 @return 距离 以米为单位
 */
- (CGFloat)getDistanceFromCurrentLocationWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;




@end

