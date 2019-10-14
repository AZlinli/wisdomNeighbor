//
//  NSString+XKString.h
//  XKSquare
//
//  Created by william on 2018/8/2.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XKString)


/**
 去除换行符和空格

 @return 处理后字符串
 */
-(NSString *)removeSpaceAndLineBreak;
/**
 去除首尾换行符和空格
 
 @return 处理后字符串
 */
- (NSString *)removeBeforeEndEnterAndSpacesChar;



/**JSON转字典*/
- (id)xk_jsonToDic;
@end
