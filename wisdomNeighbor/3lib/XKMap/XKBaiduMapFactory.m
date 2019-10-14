//
//  XKBaiduMapFactory.m
//  XKSquare
//
//  Created by hupan on 2019/5/5.
//  Copyright © 2019年 xk. All rights reserved.
//

#import "XKBaiduMapFactory.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BMKLocationkit/BMKLocationAuth.h>
#import "XKBaiduLocation.h"
#import "XKBaiduMapView.h"

@interface XKBaiduMapFactory () {
    BMKMapManager * _mapManager;
}
@end


@implementation XKBaiduMapFactory

- (instancetype)initWithAppkey:(NSString *)appkey {
    
    self = [super init];
    if (self) {
        [self baiduMapConfigWithAppkey:appkey];
    }
    return self;
}

- (void)baiduMapConfigWithAppkey:(NSString *)appkey {
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:appkey authDelegate:nil];
    _mapManager = [[BMKMapManager alloc] init];
    //如果要关注网络及授权验证事件，请设定generaDelegate参数
    BOOL ret = [_mapManager start:appkey generalDelegate:nil];
    if (!ret) {
        NSLog(@"MapManager start failed!");
    }
}

+ (id<XKLocationProtocol>)getMapLocation {
    return [XKBaiduLocation locationManager];
}

+ (id<XKMapViewProtocol>)getMapViewWithFrame:(CGRect)frame {
    return [[XKBaiduMapView alloc] creatBMKMapWithFrame:frame];
}

@end
