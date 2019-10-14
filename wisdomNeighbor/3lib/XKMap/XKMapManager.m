//
//  XKMapManager.m
//  XKSquare
//
//  Created by hupan on 2019/5/5.
//  Copyright © 2019年 xk. All rights reserved.
//

#import "XKMapManager.h"


static Class<XKMapFactoryProtocol> _factory;

@implementation XKMapManager

+ (void)recodeFactory:(Class<XKMapFactoryProtocol>)factory {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_factory) {
            _factory = factory;
        }
    });
}

+ (Class<XKMapFactoryProtocol>)getCurrentMapFactory {
    
    return _factory;
}

@end
