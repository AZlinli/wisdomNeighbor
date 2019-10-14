//
//  UIFont+XKFont.m
//  XKSquare
//
//  Created by william on 2018/7/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "UIFont+XKFont.h"
#import "XKCommonDefine.h"

static int xkfontIphone5Fix = 2;

@implementation UIFont (XKFont)

+ (void)setIphone5FIx:(int)fix {
    xkfontIphone5Fix = fix;
}

+(UIFont *)setFontWithFontName:(NSString *)fontName andSize:(CGFloat)size{
    if (iPhone5) {
        size = size - xkfontIphone5Fix;
    }
    
    UIFont *font = [UIFont fontWithName:fontName size:size];
    return font;
}

@end
