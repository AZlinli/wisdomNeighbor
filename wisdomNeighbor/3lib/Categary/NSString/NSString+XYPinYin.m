//
//  NSString+XYPinYin.m
//  XYPinYinOC
//
//  Created by 薛焱 on 16/3/3.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "NSString+XYPinYin.h"

@implementation NSString (XYPinYin)

- (void)setPinYin:(NSString *)pinYin{
    
}

- (NSString *)pinYin{
    CFMutableStringRef str = (__bridge CFMutableStringRef)[NSMutableString stringWithString:[self diacriticPinYin]];
    if (CFStringTransform(str, nil, kCFStringTransformStripDiacritics, NO)) {
        return (__bridge NSString *)(str);
    }
    return self;
}
- (NSString *)diacriticPinYin{
    CFMutableStringRef str = (__bridge CFMutableStringRef)[NSMutableString stringWithString:self];
    if (CFStringTransform(str, nil, kCFStringTransformMandarinLatin, NO)) {
        return (__bridge NSString *)(str);
    }
    return self;
}

@end
