//
//  HTTPClient.h
//  xiaohua
//
//  Created by linli on 16/8/15.
//  Copyright © 2016年 zld. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <Foundation/Foundation.h>
#import "XKHttpErrror.h"

typedef NS_ENUM(NSInteger,XKNetWorkStatus) {
    XKNetWorkLoginFailStatus = 0, // 登录失效
    XKNetWorkNoDataStatus = 1  // 无数据
};

typedef void(^XKCompletionHandler)(void);
typedef void(^XKHttpSepcialResponseHandler)(XKNetWorkStatus status, NSInteger code, NSString *message, XKCompletionHandler completeHandler);

@interface HTTPClient : AFHTTPSessionManager

+ (HTTPClient *)sharedHttpClient;

- (instancetype)initWithBaseURL:(NSURL *)url;


- (void)handleSpecialResponse:(XKHttpSepcialResponseHandler)hander;


/**
 POST不加密请求
 
 @param URLString URLString description
 @param timeoutInterval timeoutInterval 超时时间
 @param parameters parameters 业务参数
 @param success success 成功
 @param failure failure 失败
 */

+ (void)postRequestWithURLString:(NSString *)URLString
                 timeoutInterval:(NSTimeInterval)timeoutInterval
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(XKHttpErrror *error))failure;


/**
 GET不加密请求
 
 @param URLString URLString description
 @param timeoutInterval timeoutInterval 超时时间
 @param parameters parameters 业务参数
 @param success success 成功
 @param failure failure 失败
 */
+ (void)getRequestWithURLString:(NSString *)URLString
                timeoutInterval:(NSTimeInterval)timeoutInterval
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(XKHttpErrror *error))failure;

+ (NSDictionary *)getParameterDictonaryWithUrlString:(NSString *)UrlString
                                          parameters:(NSDictionary *)parameters
                                          encryption:(BOOL)encrypt;

+ (void)parseResponseObject:(id)responseObj urlString:(NSString *)url isEncrypt:(BOOL)isEncrypt success:(void (^)(id responseObject))success failed:(void (^)(XKHttpErrror *error))failure;

+ (XKHttpErrror *)handleError:(NSError *)error;

#pragma mark - 设置是否关闭打印
+ (BOOL)isForbidConsoleNetResponse;
+ (void)setForbidConsoleNetResponse:(BOOL)forbid;
@end


@interface HttpClientResponse:NSObject

@property(nonatomic, copy) NSString *message;
@property(nonatomic, assign) NSInteger status;
@property(nonatomic, copy) NSString *errorMessage;
@property(nonatomic, assign) NSInteger returnCode;

@end
