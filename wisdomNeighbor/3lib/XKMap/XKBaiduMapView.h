//
//  XKBaiduMapView.h
//  XKSquare
//
//  Created by hupan on 2019/5/14.
//  Copyright © 2019年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKMapViewProtocol.h"
#import "YYImage.h"

@interface XKBaiduMapView : UIView<XKMapViewProtocol>

@property (nonatomic, strong) BMKMapView          *bmkMapView;
@property (nonatomic, strong) YYAnimatedImageView *loactionView;


@end

