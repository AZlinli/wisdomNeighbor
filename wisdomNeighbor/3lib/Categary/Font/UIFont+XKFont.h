//
//  UIFont+XKFont.h
//  XKSquare
//
//  Created by william on 2018/7/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (XKFont)

+ (void)setIphone5FIx:(int)fix;
/**
 分类设置字体和大小
 自适应文字大小

 @param fontName 字体名称，XK开头字体
 @param size 字体大小
 @return 字体
 */
+(UIFont *)setFontWithFontName:(NSString *)fontName andSize:(CGFloat)size;

@end
