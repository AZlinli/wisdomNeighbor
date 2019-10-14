/*******************************************************************************
 # File        : XKRouter.m
 # Project     : xk
 # Author      : Jamesholy
 # Created     : 12/6/17
 # Corporation : xk
 # Description :
 项目路由，负责分发页面跳转
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKRouter.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSString * const kOpenRouteSchmem  = @"xksquare"; // 小写



@interface XKRouter ()

@property (nonatomic, copy) NSString *routerScheme;
@property (nonatomic, strong)NSMutableArray *cacheUrlArray;

@end

@implementation XKRouter

/**
 路由单例对象
 
 @return 实例
 */
+ (instancetype)sharedInstance {
    static XKRouter *router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [XKRouter new];
        router.routerScheme = kOpenRouteSchmem;
    });
    return router;
}

- (void)configRouteScheme:(NSString *)scheme {
    self.routerScheme = scheme;
}

- (NSString *)scheme {
    return self.routerScheme;
}

- (BOOL)runRemoteUrl:(nullable NSString *)urlStr ParentVC:(nullable UIViewController *)vc {
    if (urlStr == nil) {
        return NO;
    }
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]; // 处理含有中文的情况
    NSURL *url = [NSURL URLWithString:urlStr];
    if (url == nil) {
        return NO;
    }
    NSString *scheme = url.scheme;
    if (![scheme isEqualToString:self.routerScheme]) {
        // 不处理 非xk scheme的URL
        return NO;
    }
    
    if (urlStr == nil || urlStr.length == 0) {
        return NO;
    }
    
    if (vc == nil) {
        // 当响应不存在时，此时就已经发生的 openurl ，所以将openurl 缓存起来
        if (self.cacheUrlArray.count>0) {
            [self.cacheUrlArray replaceObjectAtIndex:0 withObject:urlStr];
        } else {
            [self.cacheUrlArray addObject:urlStr];
        }
        return NO;
    }
    NSDictionary *params = [self parseURLParams:[url query]];
    NSString *host = url.host;
    if (!host || [host isEqualToString:@""]) {
        return NO;
    }
    [params setValue:url.absoluteString forKey:@"raw_url"];
    
    /*
     1. 优先查找对应的_RouterAdapter。因为有些页面跳转，不能简单的kvc，而是需要model传递，或者在跳转之前需要判断逻辑。
     例如：会话聊天界面，需要传递 NIMSession 这个对象，这种情况，动态性不能满足需求，所以需要在本地的相关_RouterAdapter中，来进行转换。
     2. 如果没有找到对应的_RouterAdapter，那么则走runtime动态映射。
     */
    
    /* 这里兼容RouterAdapter在host中指定或者在参数中指定
     格式规则
     host中格式 com.Dxa  会自动拼接类名-> ComDxa_RAdapter   params 中 key：routerAdapter value直接写全类型-> ComDxa_RAdapter
     */
    Class adapterClass = NSClassFromString([self adapterNameByClassName:host]);
    if (adapterClass == nil) {
        NSString *adapterName = params[kRouterAdapter];
        if (adapterName.length != 0) {
            adapterClass = NSClassFromString(adapterName);
        }
    }
    if (adapterClass) {
        if ([adapterClass respondsToSelector:@selector(jumpRemoteWithParams:Parent:)]) {
            [adapterClass jumpRemoteWithParams:params Parent:vc];
            return YES;
        }
    }else{
        // runtime 动态
        NSString *targetVCStr = params[kRouterTargetClass];
        if (targetVCStr) {
            UIViewController *targetVC = nil;
            if (params[kRouterStoryboard]) {
                // 支持 Storyboard 获取控制器实例
                UIStoryboard *story = [UIStoryboard storyboardWithName:params[kRouterStoryboard] bundle:[NSBundle mainBundle]];
                NSString *identifier = params[kRouterIdentifier];
                targetVC = [story instantiateViewControllerWithIdentifier:identifier];
            }
            if (!targetVC) {
                // 尝试 xib 初始化
                if (params[kRouterXibName]) {
                    targetVC = [[NSClassFromString(targetVCStr) alloc] initWithNibName:params[kRouterXibName] bundle:[NSBundle mainBundle]];
                }
            }
            if (!targetVC) {
                // 代码 创建控制器
                id obj = [NSClassFromString(targetVCStr) new];
                if (obj && [obj isKindOfClass:[UIViewController class]]) {
                    targetVC = (UIViewController *)obj;
                }
            }
            if (!targetVC) {
                // 不存在oc下代码方式创建的vc, 再次考虑寻找swift下的vc，由于工程内，无swift文件，所以这里暂时未实现。
                return NO;
            }
            NSArray *propertyNameArray = [XKRouter propertyListByClass:NSClassFromString(targetVCStr) propertyClassMap:nil];
            @try {
                for (NSString *property in propertyNameArray) {
                    NSString *key = [[property componentsSeparatedByString:@"-"] firstObject];
                    NSString *type = [[property componentsSeparatedByString:@"-"] lastObject];
                    if (params[key]) {
                        // 32位操作系统，iphone5 没有该 [__NSCFString charValue]
                        if ([type isEqualToString:kRouterBoolType]) {
                            NSInteger boolEle = 0;
                            // 兼容 true 和 false
                            if ([params[key] isEqualToString:kRouterBoolTrue]) {
                                boolEle = 1;
                            }else if ([params[key] isEqualToString:kRouterBoolFalse]) {
                                boolEle = 0;
                            }else {
                                boolEle = [params[key] integerValue];
                            }
                            [targetVC setValue:@(boolEle) forKey:key];
                        }else{
                            [targetVC setValue:params[key] forKey:key];
                        }
                    }
                }
                [vc.navigationController pushViewController:targetVC animated:YES];
                
            } @catch (NSException *exception) {
                NSLog(@"处理远程url，动态跳转异常。-- %@",exception);
            } @finally {
                return YES;
            }
        }
    }
    
    return NO;
    
}


-(nullable id)runNativeTarget:(NSString *)targetName Action:(NSString *)actionName Params:(NSDictionary *)params {
    NSObject *target = target = [NSClassFromString(targetName) new];
    if (!target) {
        // 仍然没有该目标对象
        return nil;
    }
    SEL action = NSSelectorFromString(actionName);
    if ([target respondsToSelector:action]) {
        return [self safeRunTarget:target Action:action Params:params];
    }else{
        // 有可能target是Swift对象
        actionName = [NSString stringWithFormat:@"%@WithParams:", actionName];
        action = NSSelectorFromString(actionName);
        if ([target respondsToSelector:action]) {
            return [self safeRunTarget:target Action:action Params:params];
        } else {
            // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFoundAction方法统一处理
            SEL action = NSSelectorFromString(@"notFoundAction:");
            if ([target respondsToSelector:action]) {
                return [self safeRunTarget:target Action:action Params:params];
            } else {
                
                return nil;
            }
        }
    }
    
    
    return nil;
}



- (void)handleCacheRemoteURL {
    for (int i=0; i<_cacheUrlArray.count; i++) {
        NSString *urlStr = _cacheUrlArray[i];
        [self runRemoteUrl:urlStr ParentVC:[self appFirstViewController]];
    }
    [_cacheUrlArray removeAllObjects];
}

- (NSDictionary *)getParamsWithParseURL:(NSString *)urlStr {
    if (urlStr == nil || urlStr.length == 0) {
        return nil;
    }
    
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]; // 处理含有中文的情况
    NSURL *url = [NSURL URLWithString:urlStr];
    if (url == nil) {
        return nil;
    }
    NSString *scheme = url.scheme;
    if (![scheme isEqualToString:self.routerScheme]) {
        // 不处理 非xk scheme的URL
        return nil;
    }
    NSDictionary *params = [self parseURLParams:[url query]];
    return params;
}

#pragma mark - private

- (NSDictionary *)parseURLParams:(NSString *)query {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if (kv.count == 2) {
            NSString *key = [[kv firstObject] stringByRemovingPercentEncoding];
            NSString *value = [[[kv lastObject] stringByRemovingPercentEncoding] stringByRemovingPercentEncoding];
            
            // array name[0]=xx name[1]=xx  dictionary person[name]='zhangsan' person[age]=21
            if ([key containsString:@"["] && [key hasSuffix:@"]"]){
                
                @try {
                    
                    NSString *objName = [key substringToIndex:[key rangeOfString:@"["].location];
                    NSString *objValue = value;
                    NSString *type = [[key substringFromIndex:[key rangeOfString:@"["].location+1] stringByReplacingOccurrencesOfString:@"]" withString:@""];
                    
                    if ([self isPureInt:type]) {
                        // array type
                        NSMutableArray *tempArray = [[params objectForKey:objName] mutableCopy];
                        if (!tempArray) {
                            tempArray = [NSMutableArray array];
                        }
                        [tempArray addObject:objValue];
                        [params setObject:tempArray forKey:objName];
                    } else {
                        // diction type
                        NSString *objKey = type;
                        NSMutableDictionary *tempDic = [[params objectForKey:objName] mutableCopy];
                        if (!tempDic) {
                            tempDic = [NSMutableDictionary dictionary];
                        }
                        [tempDic setObject:objValue forKey:objKey];
                        [params setObject:tempDic forKey:objName];
                    }
                    
                } @catch (NSException *exception) {
                    NSLog(@"%@",exception);
                } @finally {
                    // nothing to do
                }
            } else {
                
                [params setObject:value forKey:key];
            }
        }
    }
    
    return params;
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (nullable UIViewController *)appFirstViewController {
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    
    //    if ([result.childViewControllers count] > 0) {
    //        result = [result.childViewControllers firstObject];
    //    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        UIViewController *tempVC = [[(UITabBarController *)result viewControllers] firstObject];
        result = tempVC;
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        UIViewController *tempVC = [[(UINavigationController *)result viewControllers] firstObject];
        result = tempVC;
    }
    return result;
}

- (NSString *)adapterNameByClassName:(NSString *)className {
    NSString *name = [className copy];
    NSArray *ary = [name componentsSeparatedByString:@"."];
    NSString *class_name = @"";
    for (NSString *eleName in ary) {
        NSString *tempName = @"";
        tempName = [NSString stringWithFormat:@"%@%@",[[eleName substringToIndex:1] uppercaseString],[eleName substringWithRange:NSMakeRange(1, eleName.length-1)]];
        class_name = [class_name stringByAppendingString:tempName];
    }
    NSString *adapterName = [NSString stringWithFormat:@"%@_%@",class_name,kRouterAdapter];
    return adapterName;
}

+ (NSArray *)propertyListByClass:(Class)class propertyClassMap:(NSDictionary **)map {
    NSMutableArray *propertyArray = [NSMutableArray array];
    NSMutableDictionary *propertyClassMap = @{}.mutableCopy;
    // 获取当前类和基类的所有属性，直到 NSObject 结束
    while (class != [NSObject class]) {
        
        unsigned int outCount = 0;
        objc_property_t * properties = class_copyPropertyList(class, &outCount);
        
        for (unsigned int i = 0; i < outCount; i ++) {
            
            objc_property_t property = properties[i];
            // property名
            const char * name = property_getName(property);
            NSString * propertyName = [NSString stringWithUTF8String:name];
            
            
            // property属性配置
            const char * nameAttribute = property_getAttributes(property);
            NSString * propertyAttribute = [NSString stringWithUTF8String:nameAttribute];
            NSString * firstStr = [[propertyAttribute componentsSeparatedByString:@","] firstObject];
            NSString * typeStr = firstStr.length >= 2 ? [firstStr substringWithRange:NSMakeRange(1, 1)]:nil;
            NSString *className = @" ";
            if (firstStr.length >= 2 && [firstStr containsString:@"\""]) {
                NSArray *ar = [firstStr componentsSeparatedByString:@"\""];
                if (ar.count >= 2) {
                    className = ar[1];
                }
            }
            // bool--Tc NSInteger--Ti CGFloat--Tf
            propertyClassMap[propertyName] = className;
            NSString * appenStr = @"";
            if ([typeStr containsString:@"@"]) {
                appenStr = [NSString stringWithFormat:@"-%@",kRouterObjectType];
            }else if ([typeStr isEqualToString:@"c"] || [typeStr isEqualToString:@"C"]) {
                appenStr = [NSString stringWithFormat:@"-%@",kRouterBoolType];;
            }else if ([typeStr isEqualToString:@"i"] || [typeStr isEqualToString:@"I"]) {
                appenStr = [NSString stringWithFormat:@"-%@",kRouterIntegerType];
            }else if ([typeStr isEqualToString:@"f"] || [typeStr isEqualToString:@"F"]) {
                appenStr = [NSString stringWithFormat:@"-%@",kRouterFolatType];
            }
            propertyName = [propertyName stringByAppendingString:appenStr];
            [propertyArray addObject:propertyName];
        }
        free(properties);
        class = class_getSuperclass(class);
    }
    if (map) {
        *map = propertyClassMap.copy;
    }
    return [propertyArray copy];
}

-(id)safeRunTarget:(NSObject *)target Action:(SEL)action Params:(NSDictionary *)params {
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];
    
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if (params) {
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
    }
}


#pragma mark - lazy load
- (NSMutableArray *)cacheUrlArray {
    if (!_cacheUrlArray) {
        _cacheUrlArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _cacheUrlArray;
}

@end



#pragma mark - XKRouter(Host)

@implementation XKRouter(Host)

- (NSString *)urlRemoteHost:(NSString *)host Params:(nullable NSDictionary *)params {
    return [NSString stringWithFormat:@"%@://%@%@",[XKRouter sharedInstance].scheme,host,[[XKRouter sharedInstance]queryWithDictionary:params]];
}

- (NSString *)urlDynamicTargetClassName:(NSString *)targetClass Storyboard:(nullable NSString *)storyname Identifier:(nullable NSString *)identifier XibName:(nullable NSString *)xibName Params:(nullable NSDictionary *)params {
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    [mutableDic setObject:targetClass forKey:kRouterTargetClass];
    if (storyname) {
        [mutableDic setObject:storyname forKey:kRouterStoryboard];
    }
    if (identifier) {
        [mutableDic setObject:identifier forKey:kRouterIdentifier];
    }
    if (xibName) {
        [mutableDic setObject:xibName forKey:kRouterXibName];
    }
    if (params) {
        [mutableDic setValuesForKeysWithDictionary:params];
    }
    NSString *paramurl = [[XKRouter sharedInstance] queryWithDictionary:[mutableDic copy]];
    return [NSString stringWithFormat:@"%@://%@%@",[XKRouter sharedInstance].scheme,@"com.dynamic",paramurl];
}

- (NSString *)queryWithDictionary:(nullable NSDictionary *)params {
    NSString *query = @"";
    if (!params) {
        return query;
    }
    for (NSString *key in params.allKeys) {
        NSObject *obj = params[key];
        if ([obj isKindOfClass:[NSString class]]) {
            query = [query stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,[self percentEncryptString:obj]]];
        }else if ([obj isKindOfClass:[NSNumber class]]){
            query = [query stringByAppendingString:[NSString stringWithFormat:@"%@=%ld&",key,(long)[(NSNumber *)obj integerValue]]];
        }else {
            NSLog(@"params 含有其他类型，建议使用 NSString");
        }
    }
    if ([query hasSuffix:@"&"]) {
        query = [NSString stringWithFormat:@"?%@",query];
        query = [query substringToIndex:query.length-1];
    }
    return query;
}

#pragma mark - 百分号编码
- (NSString *)percentEncryptString:(NSString *)str {
    if (str.length == 0) {
        return @"";
    }
    CFStringRef encodedCFString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef) str, nil, CFSTR("?!@#$^&%*+,:;='\"`<>()[]{}/\\| "), kCFStringEncodingUTF8);
    NSString *string = [[NSString alloc] initWithString:(__bridge_transfer NSString *)encodedCFString];
    return string;
}




@end
