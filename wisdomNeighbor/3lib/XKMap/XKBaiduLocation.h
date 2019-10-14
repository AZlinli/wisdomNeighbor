//
//  XKBaiduLocation.h
//  MasonryTest
//
//  Created by hupan on 2018/8/16.
//  Copyright © 2018年 Tears. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKLocationProtocol.h"
#import "XKMapLocationDelegate.h"


@interface XKBaiduLocation : NSObject<XKLocationProtocol>

@property (nonatomic, weak  ) id<XKMapLocationDelegate> delegate;

@end
