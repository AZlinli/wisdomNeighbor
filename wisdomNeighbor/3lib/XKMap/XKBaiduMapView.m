//
//  XKBaiduMapView.m
//  XKSquare
//
//  Created by hupan on 2019/5/14.
//  Copyright © 2019年 xk. All rights reserved.
//

#import "XKBaiduMapView.h"
#import "YYImage.h"

@implementation XKBaiduMapView


- (instancetype)creatBMKMapWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _bmkMapView = [[BMKMapView alloc] initWithFrame:frame];
        _bmkMapView.mapType = BMKMapTypeStandard;
        _bmkMapView.zoomLevel = 18;
        _bmkMapView.showsUserLocation = YES;
    }
    return self;
}


- (YYAnimatedImageView *)loactionView {
    if (!_loactionView) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AnimationLocation" ofType:@"webp"];
        UIImage *image = [YYImage imageWithContentsOfFile:path];
        _loactionView = [[YYAnimatedImageView alloc] init];
        _loactionView.frame = CGRectMake(0, 0, 48, 108);
        _loactionView.center = CGPointMake(self.bmkMapView.width / 2, self.bmkMapView.height / 2);
        _loactionView.image = image;
        [_loactionView startAnimating];
        
//        BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc] init];
//        displayParam.locationViewImgName = @"xk_icon_tradingArea_storeAdr";
//        displayParam.isRotateAngleValid = YES;//跟随态旋转角度是否生效
//        displayParam.isAccuracyCircleShow = YES;//精度圈是否显示
//        displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
//        displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
//        displayParam.accuracyCircleFillColor = HEX_RGBA(0x4A90FA, 0.3);
//        [self.bmkMapView updateLocationViewWithParam:displayParam];
    }
    return _loactionView;
}



@end
