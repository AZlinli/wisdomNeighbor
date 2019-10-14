//
//  XKHttpErrror.m
//  XKSquare
//
//  Created by linli on 2018/9/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKHttpErrror.h"

@implementation XKHttpErrror
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"message" : @"errorMessage",
             @"code" : @"returnCode",
             };
}
@end
