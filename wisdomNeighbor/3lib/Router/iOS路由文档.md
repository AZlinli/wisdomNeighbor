##iOS路由跳转文档
####1.路由结构：
```scheme://host?params```

>#####scheme: **xksquare**
>#####host: **com.dynamic**    // 可根据不同业务设置不同的。
>####params:**key1=vaule1&key2=value2**

***注意：value为中文时要对vaule进行url编码（uft-8）***
##### host 
>com.dynamic          不验证登录的跳转
>com.authDynamic  验证登录的跳转
>other 根据业务需要补充

---
#####跳转指定界面router demo: 
```xksquare://com.dynamic?targetclass=RouterTestViewController&name=%E4%BD%93%E8%B4%B4&num=2```
com.dynamic：代表不验证登录跳转指定界面
targetclass：跳转类
name、num ：参数

---
#####跳转指定界面 参数中带有模型 router demo: 
```"xksquare://model.dynamic?RAdapter=Model_RAdapter&targetclass=XKTestJumpViewController&info[nickname]=%E4%BD%93%E8%B4%B4&name[bb]=123&num=2```
com.dynamic：代表不验证登录跳转指定界面

RAdapter: Model_RAdapter  代表参数info为字典时需转换为模型

targetclass：跳转类
name、num ：参数

---
#####自定义业务router demo: 
```xksquare://xxx?xxxxxx```
xxx：代表自定义业务（自行定义）
xxxxxx：业务描述

---
###应用内根据推送或者消息跳转：
####通过推送或者消息跳转某个界面时，服务器只需要在指定字段内加入上述路由即可，详细路由由iOS开发人员提供。
---
###网页中跳转app ：
```<!DOCTYPE html>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<body>
    <p>路由跳转实例</p>
    <a href="javascript:;" id="openApp">小可广场跳转</a>
</body>

<script type="text/javascript">
    document.getElementById('openApp').onclick = function(e){
        if(navigator.userAgent.match(/(iPhone|iPod|iPad);?/i))
           {
            window.location.href = "xksquare://com.dynamic?targetclass=RouterTestViewController&name=%E4%BD%93%E8%B4%B4&num=2";//ios app协议
//          window.setTimeout(function() {
//              window.location.href = "https://itunes.apple.com/cn/app/id477927812"; // 没安装提示安装  测试地址 具体发布后可确定
//          }, 2000)
           }
        if(navigator.userAgent.match(/android/i))
           {
            window.location.href = "";//android app协议
            window.setTimeout(function() {
                window.location.href = "";//android 下载地址
            }, 2000)
        }
    };
</script>
</html>
```
safari浏览器测试：
![Bitmap.png](https://upload-images.jianshu.io/upload_images/1956050-6ca5188e8553d0f0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
###应用内跳转其他app：
#####1.调用方法
```
 [[UIApplication sharedApplication] openURL:kURL(@"xksquare://xxxx") options:@{} completionHandler:^(BOOL success) {
            //
        }];
```
#####2.指定界面跳转的处理
```
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    /* 如果使用动态跳转 使用下面的方法
     [[XKRouter sharedInstance] runRemoteUrl:routerUrl ParentVC:[self getCurrentUIVC]];
     其他业务规则 可以自行解析路由数据
     */
    if ([url.scheme containsString:@"xksquare"]) {
        if ([url.host isEqualToString:@"com.dynamic"]) { // 动态跳转 不需要用户登录的
            [self handleRouter:url];
        } else if ([url.host isEqualToString:@"com.authDynamic"]) {// 需要验证用户登录的 动态跳转
            /*
             if 未登录 {
             处理用户登录的操作 如果登录完想继续跳转 可先缓存该url 。
             [[XKRouter sharedInstance] runRemoteUrl:routerUrl ParentVC:nil]; // 传nil则是缓存
             登录成功后使用- (void)handleCacheRemoteURL; 处理缓存
             } else 登录 {
                [self handleRouter:url];
             }
             */
        } else {
            // 其他路由
        }
        return YES;
    }
    if ([url.host isEqualToString:@"safepay"] ||
        [url.host isEqualToString:@"pay"]) {
//       
        return [self payCenterApplication:app handleOpenURL:url];
    }
//    极光推送
    return [self JPushApplication:app openURL:url options:options];
}
```
```
#pragma mark - 处理路由跳转
- (void)handleRouter:(NSURL *)url {
    NSString *path = url.absoluteString;
    NSRange range = [path rangeOfString:@"xksquare://"];
    NSString *routerUrl = [path substringFromIndex:range.location];//截取正确的
    [[XKRouter sharedInstance] runRemoteUrl:routerUrl ParentVC:[self getCurrentUIVC]];
}
```
#####3.应用配置
>scheme 应为小写
######被跳转应用url schemes配置：
![image.png](https://upload-images.jianshu.io/upload_images/1956050-936e96f20458870e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
######主动跳转的应用info.plist白名单配置需要跳转的scheme：
![image.png](https://upload-images.jianshu.io/upload_images/1956050-78efd55365cf098b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###具体详细参考代码





