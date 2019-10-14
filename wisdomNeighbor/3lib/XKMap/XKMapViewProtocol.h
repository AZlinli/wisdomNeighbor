//
//  XKMapViewProtocol.h
//  XKSquare
//
//  Created by hupan on 2019/5/14.
//  Copyright © 2019年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>


@protocol XKMapViewProtocol<NSObject>

- (instancetype)creatBMKMapWithFrame:(CGRect)frame;

@end
