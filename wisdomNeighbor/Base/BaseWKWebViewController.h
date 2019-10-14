//
//  BaseWKWebViewController.h
//  XKSquare
//
//  Created by hupan on 2018/8/21.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>


@protocol BaseWKWebViewDelegate <NSObject>

@optional
//加载成功或者重定向的回调
- (void)WkWebViewGetRedirectedUrl:(NSURL *)url;

@end



@interface BaseWKWebViewController : BaseViewController <WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) BOOL      jsHiddenHUDView;
@property (nonatomic, weak  ) id<BaseWKWebViewDelegate> delegate;

/**
 必须实现方法 webView初始化

 @param methodNameArray js调用oc的方法名数组 可为空
 @param urlStr 请求url 可为空
 */
- (void)creatWkWebViewWithMethodNameArray:(NSArray *)methodNameArray requestUrlString:(NSString *)urlStr;

/**
 oc调用js方法

 @param methodName 方法名
 @param parameters 参数
 @param completionHandler 回调
 */
- (void)ocCallJSWithMethodName:(NSString *)methodName parameters:(id)parameters completionHandler:(void (^ _Nullable)(_Nullable id data, NSError * _Nullable error))completionHandler;



/**
 重新刷新webView
 */
- (void)reloadWebView;


/**
 必须实现方法  移除所有注册方法 避免内存泄漏
 */
- (void)removeAllScriptMessageHandler;
//加载完成转圈消失
- (void)jsHiddenXKHUDView;

// 暴露给 XKMatchDetailViewController 子类调用
- (void)cleanCacheAndCookie;

@end


