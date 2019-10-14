//
//  XKMapManager.h
//  XKSquare
//
//  Created by hupan on 2019/5/5.
//  Copyright © 2019年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKMapFactoryProtocol.h"


//管理记录当前初始化时用的什么地图

@interface XKMapManager : NSObject

+ (void)recodeFactory:(Class<XKMapFactoryProtocol>)factory;

+ (Class<XKMapFactoryProtocol>)getCurrentMapFactory;


@end
