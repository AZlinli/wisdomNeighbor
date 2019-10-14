//
//  XKMapViewTool.m
//  XKSquare
//
//  Created by hupan on 2019/5/15.
//  Copyright © 2019年 xk. All rights reserved.
//

#import "XKMapViewTool.h"
#import "XKMapLocationDelegate.h"
#import "XKBaiduMapView.h"
#import "XKMapManager.h"


@interface XKMapViewTool()<XKMapLocationDelegate,BMKMapViewDelegate>

@property (nonatomic, strong) XKBaiduMapView *baiduMap;
//@property (nonatomic, strong) XKGaodeMapView *gaodeMap;

@end




@implementation XKMapViewTool

- (UIView *)createMapViewWithFrame:(CGRect)frame {

    [[[XKMapManager getCurrentMapFactory] getMapLocation] setLocationDelegate:self];
    id<XKMapViewProtocol> mapView = [[XKMapManager getCurrentMapFactory] getMapViewWithFrame:frame];
    if ([mapView isKindOfClass:NSClassFromString(@"XKBaiduMapView")]) {
        self.baiduMap = (XKBaiduMapView *)mapView;
        self.baiduMap.bmkMapView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self.baiduMap addSubview:self.baiduMap.bmkMapView];
        [self.baiduMap.bmkMapView addSubview:self.baiduMap.loactionView];
        self.baiduMap.bmkMapView.delegate = self;
        
        return self.baiduMap;
    } /*else if ([mapView isKindOfClass:NSClassFromString(@"XKGaodeMapView")]) {
       
       } else {
       
       }*/
    return nil;
}

- (void)setCenterCoordinateWithLatitude:(double)Latitude longitude:(double)Longitude {
    
    CLLocationCoordinate2D coor;
    coor.latitude = Latitude;
    coor.longitude = Longitude;
    //百度地图逻辑  其他地图逻辑以后加
    if (self.baiduMap) {
        [self.baiduMap.bmkMapView setCenterCoordinate:coor animated:YES];
    }
}

- (void)setMapLeavel:(CGFloat)leavel {
    //百度地图逻辑  其他地图逻辑以后加
    if (self.baiduMap) {
        self.baiduMap.bmkMapView.zoomLevel  = leavel;
    }
}


#pragma mark - BMKMapViewDelegate

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"地图拖动");
    [UIView animateWithDuration:0.30 animations:^{
        self.baiduMap.loactionView.centerY -=8;
    } completion:^(BOOL finished) {
        self.baiduMap.loactionView.centerY +=8;
    }];
    
    CGPoint touchPoint = self.baiduMap.bmkMapView.center;
    
    CLLocationCoordinate2D touchMapCoordinate =
    [self.baiduMap.bmkMapView convertPoint:touchPoint toCoordinateFromView:self.baiduMap.bmkMapView];//这里touchMapCoordinate就是该点的经纬度了
    NSLog(@"touching %f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
    [[[XKMapManager getCurrentMapFactory] getMapLocation] getPoiNearbySearchWithLocation:touchMapCoordinate searchRadius:200];
}

#pragma mark - XKMapLocationDelegate

- (void)userNearbySearchAddressList:(NSArray *)poiInfoList {
    
    if (self.nearbySearchBlcok) {
        self.nearbySearchBlcok(poiInfoList);
    }
    
}

@end
