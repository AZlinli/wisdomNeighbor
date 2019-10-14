//
//  XKMapViewTool.h
//  XKSquare
//
//  Created by hupan on 2019/5/15.
//  Copyright © 2019年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NearbySearchBlcok)(NSArray *nearbySearchArr);

@interface XKMapViewTool : NSObject

@property (nonatomic, copy  ) NearbySearchBlcok  nearbySearchBlcok;


- (UIView *)createMapViewWithFrame:(CGRect)frame;

- (void)setCenterCoordinateWithLatitude:(double)Latitude longitude:(double)Longitude;


- (void)setMapLeavel:(CGFloat)leavel;

@end

