//
//  HTTPClient.m
//  xiaohua
//
//  Created by linli on 16/8/15.
//  Copyright © 2016年 zld. All rights reserved.
//

#import "HTTPClient.h"
#import "XKInfoProvider.h"
#import "YYModel.h"
#import "XKCommonDefine.h"
#define kAllowConsole(url) [self allowSpecialUrl:url] && ![self isForbidConsoleNetResponse]

#define kReplaceUrl(urlStr) [self getReplaceUrl:urlStr]
//dev是yes 生产环境是no
#define CurrentDevEnvironment YES

#define CurrentBeseUrl CurrentDevEnvironment?@"http://139.155.41.184:8080/":@""


@interface HTTPClient ()

@property(nonatomic, copy) XKHttpSepcialResponseHandler hander;

@end

@implementation HTTPClient

+ (HTTPClient *)sharedHttpClient {
    
    static HTTPClient *_sharedHttpClient = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedHttpClient = [[self alloc] init];
     //   _sharedHttpClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:BaseUrl]];
        _sharedHttpClient.requestSerializer = [[AFJSONRequestSerializer serializer]init];
        _sharedHttpClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"application/json",@"text/json", nil];
    });
    return _sharedHttpClient;
}


- (void)handleSpecialResponse:(XKHttpSepcialResponseHandler)hander {
    self.hander = hander;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if (self) {
        
    }
    
    return self;
}

+ (NSString *)getReplaceUrl:(NSString *)url {
    NSString *appendUrl = [url containsString:@"http"] ? url : [CurrentBeseUrl stringByAppendingString:url];
    return appendUrl;
}

+ (NSDictionary *)getParameterDictonaryWithUrlString:(NSString *)UrlString
                                          parameters:(NSDictionary *)parameters
                                          encryption:(BOOL)encrypt{
    
    
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
//    NSString *userToken = [XKInfoProvider shareProvider].getUser().token;
//    NSString *userId = [XKInfoProvider shareProvider].getUser().userId;
//    if (userToken) {
//        [parameterDic setValue:userToken forKey:@"token"];
//    }
//    if (userId) {
//        [parameterDic setValue:userId forKey:@"userId"];
//    }
//    /**
//     os：操作系统
//     clientVersion：客户端版本号
//     mobileType：手机型号
//     guid：手机唯一标识
//     channel：渠道号
//     */
//    [parameterDic setValue:@"ios" forKey:@"os"];
//    [parameterDic setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"clientVersion"];
//    [parameterDic setValue:[XKInfoProvider shareProvider].deviceName forKey:@"mobileType"];
//    [parameterDic setValue:[XKInfoProvider shareProvider].guid forKey:@"guid"];
//    [parameterDic setValue:@"appStore" forKey:@"channel"];
//
    if (parameters) {
        [parameterDic addEntriesFromDictionary:parameters];
    }
#ifdef DEBUG
    NSLog(@"url = %@\n入参 = %@", UrlString, [parameterDic yy_modelToJSONString]);
#endif
    return parameterDic;
}


//post不加密请求
+ (void)postRequestWithURLString:(NSString *)URLString
                 timeoutInterval:(NSTimeInterval)timeoutInterval
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(XKHttpErrror *error))failure {
    NSDictionary *parameterDic = [self getParameterDictonaryWithUrlString:URLString parameters:parameters encryption:NO];
    [self sharedHttpClient].requestSerializer.timeoutInterval = timeoutInterval;
    [[self sharedHttpClient] POST:kReplaceUrl(URLString) parameters:parameterDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            [self parseResponseObject:responseObject urlString:URLString isEncrypt:NO success:success failed:failure];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         failure([self handleError:error]);
    }];
}

//get不加密请求
+ (void)getRequestWithURLString:(NSString *)URLString
                 timeoutInterval:(NSTimeInterval)timeoutInterval
                      parameters:(NSDictionary *)parameters
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(XKHttpErrror *error))failure {

    NSDictionary *parameterDic = [self getParameterDictonaryWithUrlString:URLString parameters:parameters encryption:NO];
    [self sharedHttpClient].requestSerializer.timeoutInterval = timeoutInterval;
    [[self sharedHttpClient] GET:kReplaceUrl(URLString) parameters:parameterDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            [self parseResponseObject:responseObject urlString:URLString isEncrypt:NO success:success failed:failure];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([self handleError:error]);
    }];
}

+ (void)parseResponseObject:(id)responseObj urlString:(NSString *)url isEncrypt:(BOOL)isEncrypt success:(void (^)(id responseObject))success failed:(void (^)(XKHttpErrror *error))failure {
//    BOOL isIntercept = [self handleInterceptCode:responseObj isEncrypt:isEncrypt success:success failed:failure];
//    if(isIntercept) {
//        if (kAllowConsole(url)) { NSLog(@"%@ 的 Json:%@",url,responseObj);}
//        return;
//    }
    
    BOOL isSuccess = [self boolResultOf:responseObj];
    
//    if (!isSuccess && !message)
//        message = @"服务器返回数据为空";
    if (isSuccess) {
        if (kAllowConsole(url)) { NSLog(@"%@ 的 Json:%@",url,responseObj);}
        success(responseObj);
    } else {
        if (kAllowConsole(url)) { NSLog(@"%@ 的 Json:%@",url,responseObj);}
        XKHttpErrror *err = [XKHttpErrror yy_modelWithJSON:responseObj];
        failure(err);
    }
}

+ (XKHttpErrror *)handleError:(NSError *)error {
    XKHttpErrror *err = [XKHttpErrror new];
    err.code = error.code;
    err.message = @"网络错误";
    return err;
}

+ (BOOL)boolResultOf:(id)responseObj {
    
    if (!responseObj) {
        return NO;
    }
    HttpClientResponse *res = [HttpClientResponse yy_modelWithJSON:responseObj];

    if (res.returnCode == 200) {
        return YES;
    }
    if ([res.message isEqualToString:@"success"] || [res.message isEqualToString:@"SUCCESS"]) {
        return YES;
    }
    
    return NO;
}

static BOOL isShow = NO;
/**
 处理特定的错误码

 @param responseObj 返回数据
 @return 是否需要拦截
 */

+ (BOOL)handleInterceptCode:(id)responseObj isEncrypt:(BOOL)isEncrypt success:(void (^)(id responseObject))success failed:(void (^)(XKHttpErrror *error))failure {
    NSString *message = responseObj[@"message"] ?: @"";
    BOOL isIntercept = NO;
    NSInteger errorCode =[responseObj[@"code"] intValue];
    if ([responseObj[@"code"] isKindOfClass:[NSNull class]]) {
        errorCode = 500;
    }
    // 匹配是否是登录失效错误码
    NSArray *tokenErrCode = [XKInfoProvider shareProvider].tokenFailCodeArr;
    BOOL errCodeMatch = NO;
    for (NSString *failCode in tokenErrCode) {
        if (errorCode == failCode.integerValue) {
            errCodeMatch = YES;
            break;
        }
    }
    if (errCodeMatch) { // 登录失效
        isIntercept = YES;
        XKHttpErrror *err = [XKHttpErrror yy_modelWithJSON:responseObj];
        failure(err);
        if (!isShow) {
            isShow = YES;
            [[HTTPClient sharedHttpClient].operationQueue cancelAllOperations];
            [HTTPClient sharedHttpClient].hander(XKNetWorkLoginFailStatus,errorCode, message, ^{
                isShow = NO;
            });
            // 防止有同志没有回调上面的hander的回调，自己延迟设置回去。不然后面的框再也弹不出来
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                           ^{
                               isShow = NO;
                           });

        }
    } else if(errorCode == 409) {//空数据
         isIntercept = YES;
        [HTTPClient sharedHttpClient].hander(XKNetWorkNoDataStatus,errorCode,nil, ^{
        });
        success(nil);
    }
    return isIntercept;
}

+ (NSString *)dataTOjsonString:(id)object
{
    if (!object)
        return @"空";
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

/**是否关闭打印请求结果*/
+ (BOOL)isForbidConsoleNetResponse {
#ifdef DEBUG
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"forbidConsoleNetRes"];
#else
    return YES;
#endif
}

+ (void)setForbidConsoleNetResponse:(BOOL)forbid {
    [[NSUserDefaults standardUserDefaults] setBool:forbid forKey:@"forbidConsoleNetRes"];
}

/**指定响应不打印*/
+ (BOOL)allowSpecialUrl:(NSString *)url {
    if ([url containsString:@"sys/ua/regionPage"]) {
        return NO;
    }
    return YES;
}

@end


@implementation HttpClientResponse

@end
