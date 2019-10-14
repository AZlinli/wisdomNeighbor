//
//  NSString+Utils.m
//  Erp4iOS
//
//  Created by fakepinge on 2017/11/27.
//  Copyright © 2017年 成都好房通科技股份有限公司. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

#pragma mark -  判断字符串是否存在 去掉空格后判断的
- (BOOL)isExist {
	NSString *temp = self;
	BOOL result = NO;
	if ([self isKindOfClass:[NSNumber class]]) {
		temp = [NSString stringWithFormat:@"%@",self];
	}
	if ([temp isNull]) {
		
	} else if ([temp removeSpaceChar].length == 0) {
		
	} else if (temp == nil) {
		
	} else {
		result = YES;
	}
	return  result;
}

#pragma mark - 去除空格字符
- (NSString *)removeSpaceChar {
	return  [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - 去除收尾空格和换行字符串
- (NSString *)removeEnterAndSpacesChar {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - 去除Float型字符串小数点后多余的0
- (NSString *)removeFloatStrAllZero {
	NSString *outNumber = [NSString stringWithFormat:@"%@", @(self.doubleValue)];
	return outNumber;
}

#pragma mark - 取小数点后几位，如果后面是0会去掉
- (NSString *)getDecimalAfterPlaces:(NSInteger)offset {
    NSInteger space = labs(offset);
    // 保留两位并四舍五入
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:space raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *selfNum = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:@"1"];
    // 计算计算保留两位并四舍五入
    NSDecimalNumber *calculateNum = [selfNum decimalNumberByMultiplyingBy:num withBehavior:roundUp];
    return calculateNum.stringValue;
}

+ (NSString *)stringWithFormatRemoveRedundantZero:(CGFloat)orignalFloat {
    if (orignalFloat <= 0) {
        return @"0";
    }
    // 四舍五入，并保留两位小数
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"0.00"];
    NSString *temp = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:orignalFloat]];
    NSRange pointRange = [temp rangeOfString:@"."];
    
    if (pointRange.location != NSNotFound && temp.length > pointRange.location + 2) {
        if ([temp hasSuffix:@".00"]) {
            temp = [temp substringToIndex:temp.length - 3];
        } else if ([temp hasSuffix:@"0"]) {
            temp = [temp substringToIndex:temp.length - 1];
        }
    }
    return temp;
}

#pragma mark - 是否包含目标字符串
- (BOOL)isContainString:(NSString *)string {
	return [self rangeOfString:string].location != NSNotFound;
}

#pragma mark - 是否包含中文
- (BOOL)isContainChinese {
	for (int i = 0; i < self.length; i++) {
		int a = [self characterAtIndex:i];
		if( a > 0x4e00 && a < 0x9fff) {
			return YES;
			break;
		}
	}
	return NO;
}

#pragma mark - 是否全是数字
- (BOOL)isOnlyNumber {
	for (NSInteger i = 0; i < self.length; i++) {
		unichar ch = [self characterAtIndex:i];
		if (!((ch >= '0') && (ch <= '9'))){ // 0=48
			return NO;
			break;
		}
	}
	return YES;
}

#pragma mark - 是否全是字母
- (BOOL)isOnlyLetter {
	for (NSInteger i = 0; i < self.length; i++) {
		unichar ch = [self characterAtIndex:i];
		if (!(((ch >= 'a') && (ch <= 'z')) || ((ch >= 'A') && (ch <= 'Z')))){ //0=48
			return NO;
			break;
		}
	}
	return YES;
}

#pragma mark - 是否全是数字或者全是字母
- (BOOL)isContainNumberOrLatter {
	for (NSInteger i = 0; i < self.length; i++) {
		unichar ch = [self characterAtIndex:i];
		if (!(((ch >= 'a') && (ch <= 'z')) || ((ch >= 'A') && (ch <= 'Z')) || ((ch >= '0') && (ch <= '9')))) {
			return NO;
			break;
		}
	}
	return YES;
}

#pragma mark - 是否为浮点形
- (BOOL)isPureFloatNum {
	NSScanner *scan = [NSScanner scannerWithString:self];
	float val;
	return [scan scanFloat:&val] && [scan isAtEnd];
}

#pragma mark - 是否是整数
- (BOOL)isPureIntNum {
	NSScanner *scan = [NSScanner scannerWithString:self];
	int val;
	return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - 是否是整数数或浮点数
- (BOOL)isPureIntOrFloat {
	if([self isPureIntNum] || [self isPureFloatNum]) {
		return YES;
	}
	return NO;
}

#pragma mark - 整数或者字母和数字(字母和数字可混合)
- (BOOL)isContainIntNumOrNumAndLatter {
	if ([self isPureIntNum]) { // 整数 包括负数
		return YES;
	}
	if ([self isContainNumberOrLatter]) { // 全是数字或者全是字母
		return YES;
	}
	return NO;
}

#pragma mark - 根据字体大小和限定的高度，得到宽度
- (CGFloat)getWidthStrWithFontSize:(CGFloat)fontSize height:(CGFloat)height {
	UIFont *font = [UIFont systemFontOfSize:fontSize]; // 文字的size
	CGRect rect = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil];
	CGFloat textwidth = rect.size.width;
	return textwidth; // 文本的宽度
}

#pragma mark - 根据字体大小和限定的宽度，得到高度
- (CGFloat)getHeightStrWIthFontSize:(CGFloat)fontSize width:(CGFloat)width {
	UIFont *font = [UIFont systemFontOfSize:fontSize]; // 文字的size
	CGRect rect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil];
	CGFloat textheight = rect.size.height;
	return textheight; // 文本的高度
}

#pragma mark - 根据时间字符串和时间格式转换成date
- (NSDate *)getDateWithFormatStr:(NSString *)formatStr {
	if (![self isExist]) {
		return nil;
	}
	if (![formatStr isExist]) {
		return nil;
	}
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formatStr];
	NSDate *date = [formatter dateFromString:self];
	return date;
}

#pragma mark - 根据时间字符串和时间格式转换成今天、昨天等等
- (NSString *)getTimeLineStrSinceNowWithFormatString:(NSString *)formatString {
	if (![self isExist] || ![formatString isExist]) {
		return self;
	}
	NSRange dateRange = [formatString rangeOfString:@"^yyyy.*MM.*dd.*((HH)|(hh)).*mm.*ss$" options:NSRegularExpressionSearch];
	if (!NSEqualRanges(dateRange, NSMakeRange(0, formatString.length))) {
		return self;
	}
	NSRange timeRange = [formatString rangeOfString:@"((HH)|(hh)).*mm" options:NSRegularExpressionSearch];
	NSDate *date = [self getDateWithFormatStr:formatString];
	double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
	NSString *dateString = @"";
	switch ((int)(([[NSDate date] timeIntervalSince1970] + timezoneFix)/(24*3600)) -
			(int)(([date timeIntervalSince1970] + timezoneFix)/(24*3600))) {
		case 0:
			dateString = [NSString stringWithFormat:@"今天 %@", [self substringWithRange:timeRange]];
			break;
		case 1:
			dateString = [NSString stringWithFormat:@"昨天 %@", [self substringWithRange:timeRange]];
			break;
		default: {
			dateRange = [formatString rangeOfString:@"^yyyy.*MM.*dd.*((HH)|(hh)).*mm" options:NSRegularExpressionSearch];
			dateString = [self substringWithRange:dateRange];
		}
			break;
	}
	return dateString;
}

#pragma mark - 百分号编码
- (NSString *)percentEncryptString {
    if (![self isExist]) {
        return @"";
    }
    CFStringRef encodedCFString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef) self, nil, CFSTR("?!@#$^&%*+,:;='\"`<>()[]{}/\\| "), kCFStringEncodingUTF8);
    NSString *string = [[NSString alloc] initWithString:(__bridge_transfer NSString *)encodedCFString];
    return string;
}

#pragma mark - 百分号解码
- (NSString *)percentDecodeString {
    if (![self isExist]) {
        return @"";
    }
    NSString *string = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return string;
}

+ (NSString *)getParamsStringWithParamsDict:(NSDictionary *)paramsDict andUrlString:(NSString *)urlString {
    NSString *paramsStr = [NSString getParamsStringWithParamsDict:paramsDict];
    if ([paramsStr isExist]) {
        urlString = [NSString stringWithFormat:@"%@%@%@", urlString, ([urlString containsString:@"?"] ? @"&" : @"?"), paramsStr];
    }
    return urlString;
}

+ (NSString *)getParamsStringWithParamsDict:(NSDictionary *)paramsDict {
    if (!paramsDict || paramsDict.allKeys.count == 0) return nil;
    NSMutableArray *paramsStrArr = [NSMutableArray array];
    for (NSString *key in paramsDict.allKeys) {
        id value = [paramsDict valueForKey:key];
        NSString *valueStr;
        if ([value isKindOfClass:[NSNumber class]]) {
            valueStr = [NSString stringWithFormat:@"%d", [value intValue]];
        } else if ([value isKindOfClass:[NSString class]]) {
            valueStr = (NSString *)value;
        }
        if ([valueStr isExist]) {
            NSString *paramsStr = [NSString stringWithFormat:@"%@=%@", key, valueStr.percentEncryptString];
            [paramsStrArr addObject:paramsStr];
        }
    }
    if (paramsStrArr.count == 0) return nil;
    return [paramsStrArr componentsJoinedByString:@"&"];
}

#pragma mark - json字符串转字典
- (NSDictionary *)getJsonDictData {
    if (!self.isExist) return nil;
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) return nil;
    return dict;
}

#pragma mark ----------------------------- 私有方法 ------------------------------
// 是否为null
- (BOOL)isNull {
	return [self isKindOfClass:[NSNull class]];
}

/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)getURLParameters {
    
    // 查找参数
    NSRange range = [self rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [self substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [[pairComponents.firstObject stringByRemovingPercentEncoding]removeSpaceChar];
            NSString *value = [[pairComponents.lastObject stringByRemovingPercentEncoding]removeSpaceChar];
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [[pairComponents.firstObject stringByRemovingPercentEncoding]removeSpaceChar];
        NSString *value = [[pairComponents.lastObject stringByRemovingPercentEncoding]removeSpaceChar];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
}

- (NSString *)replacingString:(NSString *)needReplacingString {
   return  [self stringByReplacingOccurrencesOfString:needReplacingString withString:@""];
}

-(void)getMessageRange:(NSString*)message :(NSMutableArray*)array {
    
    NSRange rangeL = [message rangeOfString:@"["];
    NSRange rangeR = [message rangeOfString:@"]"];
    //判断当前字符串是否还有表情的标志。
    if (rangeL.length && rangeR.length) {
        if (rangeL.location > 0) {
            
            [array addObject:[message substringToIndex:rangeL.location]];
            [array addObject:[message substringWithRange:NSMakeRange(rangeL.location, rangeR.location + 1 - rangeL.location)]];
            
            NSString *str = [message substringFromIndex:rangeR.location + 1];
            [self getMessageRange:str :array];
        }
        else {
            NSString *nextstr = [message substringWithRange:NSMakeRange(rangeL.location, rangeR.location + 1 - rangeL.location)];
            //排除“”空字符串
            if (![nextstr isEqualToString:@""]) {
                
                [array addObject:nextstr];
                
                NSString *str = [message substringFromIndex:rangeR.location + 1];
                [self getMessageRange:str :array];
            }
            else {
                
                return;
            }
        }
    }
    else {
        [array addObject:message];
    }
}

- (NSAttributedString *)emojiStr {
    @try {
        
        NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:0];
        
        [self getMessageRange:self :imageArr];
        //NSLog(@"%@",imageArr);
        
        NSMutableAttributedString *mutableAttributedStr=[[NSMutableAttributedString alloc]initWithString:@""];
        [imageArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSString *contentPartStr = [NSString stringWithFormat:@"%@",obj];
            if (contentPartStr.length > 0) {
                NSString *firstC = [obj substringWithRange:NSMakeRange(0, 1)];
                NSString *endC = [obj substringWithRange:NSMakeRange(1, contentPartStr.length-1)];
                NSAttributedString *attributedStr;
                if ([firstC isEqualToString:@"[" ]&&[endC rangeOfString:@"]" ].location!=NSNotFound ) {
                    NSRange firstRange = [obj rangeOfString:@"["];
                    NSRange secondRange = [obj rangeOfString:@"]"];
                    NSUInteger length = secondRange.location - firstRange.location;
                    NSRange imageNameRange = NSMakeRange(1, length - 1);
                    NSString *imageName = [obj substringWithRange:imageNameRange];
                    NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
                    NSString *path = [NSBundle.mainBundle pathForResource:@"XKEmotionResource" ofType:@"bundle"];
                    attachment.image = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:imageName]];
                    if (attachment.image==nil) {
                        attributedStr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"[%@]",imageName]];
                        // NSLog(@"%@",imageName);
                    }else{
                        attachment.bounds = CGRectMake(0, -5, 20, 20);
                        attributedStr = [[NSAttributedString alloc]initWithString:@""];
                        attributedStr = [NSAttributedString attributedStringWithAttachment:attachment];
                    }
                }
                else{
                    attributedStr = [[NSAttributedString alloc]initWithString:obj];
                }
                [mutableAttributedStr appendAttributedString:attributedStr];
            }
        }];
        return mutableAttributedStr;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
    }
}

@end
