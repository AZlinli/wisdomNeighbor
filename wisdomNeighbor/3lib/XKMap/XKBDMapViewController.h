//
//  XKBDMapViewController.h
//  XKBDMap
//
//  Created by hupan on 2018/7/26.
//  Copyright © 2018年 Tears. All rights reserved.
//

#import "BaseViewController.h"

@interface XKBDMapViewController : BaseViewController

//当前经纬度 （非必传 没传时当使用三方地图时会自动定位）
@property (nonatomic, assign) CGFloat  myLatitude;
@property (nonatomic, assign) CGFloat  myLongitude;

//目的地及其经纬度
@property (nonatomic, copy  ) NSString *destinationName;//目的地名字  必传 （非地址）
@property (nonatomic, copy  ) NSString *destinationDec; //目的地描述 非必传（地址）
@property (nonatomic, assign) CGFloat  destinationLatitude; //必传
@property (nonatomic, assign) CGFloat  destinationLongitude;//必传


//附近商店信息
@property (nonatomic, copy  ) NSArray  *locationMerchantArray;


@end
