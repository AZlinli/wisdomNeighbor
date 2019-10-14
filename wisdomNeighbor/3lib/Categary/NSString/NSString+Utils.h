//
//  NSString+Utils.h
//  Erp4iOS
//
//  Created by fakepinge on 2017/11/27.
//  Copyright © 2017年 成都好房通科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Utils)

/**
 判断字符串是否存在 去掉空格后判断的
 */
- (BOOL)isExist;

/**
 去除空格字符
 */
- (NSString *)removeSpaceChar;

/**
 去除首尾空格和换行字符串
 */
- (NSString *)removeEnterAndSpacesChar;

/**
 去除Float型字符串小数点后多余的0
 */
- (NSString *)removeFloatStrAllZero;

/**
 取小数点后几位，如果后面是0会去掉
 @param offset 小数点后几位
 */
- (NSString *)getDecimalAfterPlaces:(NSInteger)offset;

/**
 移除多余的0，最多保留小数点后两位，且末位不为0
 如： 1.00 / 1.0 -> 1 ,  1.10 -> 1.1  1.100 -> 1.1  1.111 -> 1.1
 
 @param orignalFloat 原始数据
 @return 格式化后的字符串
 */
+ (NSString *)stringWithFormatRemoveRedundantZero:(CGFloat)orignalFloat;

/**
 是否包含目标字符串
 */
- (BOOL)isContainString:(NSString *)string;

/**
 是否包含中文
 */
- (BOOL)isContainChinese;

/**
 是否全是数字
 */
- (BOOL)isOnlyNumber;

/**
 是否全是字母
 */
- (BOOL)isOnlyLetter;

/**
 是否全是数字或者全是字母
 */
- (BOOL)isContainNumberOrLatter;

/**
 是否为浮点形
 */
- (BOOL)isPureFloatNum;

/**
 是否是整数（包括负数）
 */
- (BOOL)isPureIntNum;

/**
 是否是整数数或浮点数
 */
- (BOOL)isPureIntOrFloat;

/**
 整数或者字母和数字(字母和数字可混合)
 */
- (BOOL)isContainIntNumOrNumAndLatter;

/**
 根据字体大小和限定的高度，得到字符串宽度
 
 @param fontSize 字体大小
 @param height 高度
 @return 字符串宽度
 */
- (CGFloat)getWidthStrWithFontSize:(CGFloat)fontSize height:(CGFloat)height;

/**
 根据字体大小和限定的宽度，得到字符串高度
 
 @param fontSize 字体大小
 @param width 宽度
 @return 字符串高度
 */
- (CGFloat)getHeightStrWIthFontSize:(CGFloat)fontSize width:(CGFloat)width;

/**
 根据时间字符串和时间格式转换成date

 @param formatStr 时间格式字符串
 @return date
 */
- (NSDate *)getDateWithFormatStr:(NSString *)formatStr;

/**
 根据时间字符串和时间格式转换成今天、昨天等等

 @param formatString 时间格式字符串
 @return 今天、昨天等等字符串
 */
- (NSString *)getTimeLineStrSinceNowWithFormatString:(NSString *)formatString;

/**
 百分号编码
 
 @return 编码字符串
 */
- (NSString *)percentEncryptString;

/**
 百分号解码字符串
 
 @return 解码字符串
 */
- (NSString *)percentDecodeString;

/**
 传入参数字典和Url生成最终拼接好的Url
 @{key1:value1,key2:value2} www.baodu.com => www.baodu.com?key1=value1&key2=valeu2
 @param paramsDict 参数字典
 @param urlString url
 @return 终极url
 */
+ (NSString *)getParamsStringWithParamsDict:(NSDictionary *)paramsDict andUrlString:(NSString *)urlString;

/**
 传入参数字典 @{key1:value1,key2:value2} => key1=valeu1&key2=valeu2

 @param paramsDict 生成字符串
 @return 生成字符串
 */
+ (NSString *)getParamsStringWithParamsDict:(NSDictionary *)paramsDict;


/**
 json字符串转字典

 @return 字典数据
 */
- (NSDictionary *)getJsonDictData;

/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)getURLParameters;

- (NSString *)replacingString:(NSString *)needReplacingString;

/**
 文字判断是都含有表情

 @return 带表情的文字
 */
- (NSAttributedString *)emojiStr;
@end
