//
//  NSString+XKString.m
//  XKSquare
//
//  Created by william on 2018/8/2.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "NSString+XKString.h"


@implementation NSString (XKString)
-(NSString *)removeSpaceAndLineBreak{
    NSString *dataSting = self;
    dataSting = [dataSting stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    dataSting = [dataSting stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    dataSting = [dataSting stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    dataSting = [dataSting stringByReplacingOccurrencesOfString:@" " withString:@""];
    return dataSting;
}


#pragma mark - 去除首尾空格和换行字符串
- (NSString *)removeBeforeEndEnterAndSpacesChar {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (id)xk_jsonToDic {
 
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}



@end
