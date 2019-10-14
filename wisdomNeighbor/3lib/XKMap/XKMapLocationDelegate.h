//
//  XKMapLocationDelegate.h
//  XKSquare
//
//  Created by hupan on 2019/5/6.
//  Copyright © 2019年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XKMapLocationDelegate<NSObject>


@optional
/**
 定位失败
 
 @param error error
 */

- (void)failToLocateUserWithError:(NSError *)error;


/**
 获取用户当前位置经纬度
 
 @param laititude laititude description
 @param longtitude longtitude description
 */
- (void)userLocationLaititude:(double)laititude longtitude:(double)longtitude;


/**
 获取用户所在地地名
 
 @param country 国家
 @param state 省会
 @param city 城市
 @param subLocality 区域
 @param name 地名
 */
- (void)userLocationCountry:(NSString *)country state:(NSString *)state city:(NSString *)city subLocality:(NSString *)subLocality name:(NSString *)name;


/**
 获取用户附近地址列表
 
 @param poiInfoList poiInfoList
 */
- (void)userNearbySearchAddressList:(NSArray *)poiInfoList;


/**
 关键字搜索地址列表
 
 @param suggestionList suggestionList
 */
- (void)keyWordSearchAddressList:(NSArray *)suggestionList;


@end
