//
//  XKQRCodeScanBackView.m
//  XKSquare
//
//  Created by hupan on 2018/8/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKQRCodeScanBackView.h"

@implementation XKQRCodeScanBackView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //设置 背景为clear
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [[UIColor colorWithWhite:0 alpha:0.2] setFill];
    //半透明区域
    UIRectFill(rect);
    
    //透明的区域
  //  CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGRect holeRection = CGRectMake(86*ScreenScale, 158*ScreenScale, SCREEN_WIDTH - 86 * ScreenScale * 2, 200*ScreenScale);
    /** union: 并集
     CGRect CGRectUnion(CGRect r1, CGRect r2)
     返回并集部分rect
     */
    
    /** Intersection: 交集
     CGRect CGRectIntersection(CGRect r1, CGRect r2)
     返回交集部分rect
     */
    CGRect holeiInterSection = CGRectIntersection(holeRection, rect);
    [[UIColor clearColor] setFill];
    UIRectFill(holeiInterSection);
    
}
@end
