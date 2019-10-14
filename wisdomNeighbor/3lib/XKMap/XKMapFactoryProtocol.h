//
//  XKMapFactoryProtocol.h
//  XKSquare
//
//  Created by hupan on 2019/5/5.
//  Copyright © 2019年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKLocationProtocol.h"
#import "XKMapViewProtocol.h"

@protocol XKMapFactoryProtocol<NSObject>

@optional

- (instancetype)initWithAppkey:(NSString*)appkey;

//获取对应的 mapLocation
+ (id<XKLocationProtocol>)getMapLocation;


//获取对应的 mapview
+ (id<XKMapViewProtocol>)getMapViewWithFrame:(CGRect)frame;

//tip:
//完整来说 还应该把mapView 模块抽出到这里动态根据选择的factory 创建对应的mapView
//mapView 的代理也应该抽出来 通用方法直接动态回调对应地图的回调

@end
