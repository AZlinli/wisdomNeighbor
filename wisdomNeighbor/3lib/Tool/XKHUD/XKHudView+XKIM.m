//
//  XKHudView+XKIM.m
//  XKSquare
//
//  Created by Jamesholy on 2019/4/26.
//  Copyright © 2019 xk. All rights reserved.
//

#import "XKHudView+XKIM.h"
#import "XKIMCustomProgressView.h"
@implementation XKHudView (XKIM)



//loding
+ (XKProgressHUD *)showIMLoadingTo:(UIView *_Nullable)view animated:(BOOL)annimated {
    return [self showIMLoadingMessage:@"加载中..." to:view animated:YES];
}

+ (XKProgressHUD *)showIMLoadingMessage:(NSString* _Nullable)message to:(UIView *_Nullable)view animated:(BOOL)annimated {
    return [self commonShowIMActivityMessage:message view:view time:0 animated:YES];
}

+ (XKProgressHUD *)commonShowIMActivityMessage:(NSString*)message view:(UIView *)view time:(NSTimeInterval)aTime animated:(BOOL)annimated {
    XKProgressHUD *hud = [self commonShowIMCustomIcon:@"XKHudResources.bundle/MBProgressHUD/MBHUD_Info" message:message view:view time:aTime animated:annimated completion:nil];
    [(XKIMCustomProgressView *)hud.customView startLoading];
    return hud;
}


// success
+ (XKProgressHUD *)showIMSuccessMessage:(NSString *)message {
     return [self showIMSuccessMessage:message to:nil animated:YES];
}

+ (XKProgressHUD *)showIMSuccessMessage:(NSString *)message to:(UIView *)view animated:(BOOL)annimated {
   return [self showIMSuccessMessage:message to:view time:toastDefaultTime animated:annimated completion:nil];
}

+ (XKProgressHUD *)showIMSuccessMessage:(NSString *)message to:(UIView * _Nullable)view time:(NSTimeInterval)time animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion {
    return [self commonShowIMCustomIcon:@"xk_img_IM_hud_success" message:message view:view time:time animated:YES completion:completion];
}

//error
+ (XKProgressHUD *)showIMErrorMessage:(NSString *)message {
     return [self showIMErrorMessage:message to:nil animated:YES];
}

+ (XKProgressHUD *)showIMErrorMessage:(NSString *)message to:(UIView *)view animated:(BOOL)annimated {
     return [self showIMErrorMessage:message to:view time:toastDefaultTime animated:annimated completion:nil];
}

+ (XKProgressHUD *)showIMErrorMessage:(NSString *)message to:(UIView * _Nullable)view time:(NSTimeInterval)time animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion {
    return [self commonShowIMCustomIcon:@"xk_img_IM_hud_error" message:message view:view time:time animated:YES completion:completion];
}

//error
+ (XKProgressHUD *)showIMInfoMessage:(NSString *)message {
      return [self showIMInfoMessage:message to:nil animated:YES];
}

+ (XKProgressHUD *)showIMInfoMessage:(NSString *)message to:(UIView *)view animated:(BOOL)annimated {
     return [self showIMInfoMessage:message to:view time:toastDefaultTime animated:annimated completion:nil];
}

+ (XKProgressHUD *)showIMInfoMessage:(NSString *)message to:(UIView * _Nullable)view time:(NSTimeInterval)time animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion {
    return [self commonShowIMCustomIcon:@"xk_img_IM_hud_info" message:message view:view time:time animated:YES completion:completion];
}

//warn
+ (XKProgressHUD *)showIMWarnMessage:(NSString *)message {
    return [self showIMWarnMessage:message to:nil animated:YES];
}

+ (XKProgressHUD *)showIMWarnMessage:(NSString *)message to:(UIView *)view animated:(BOOL)annimated {
    return [self showIMWarnMessage:message to:view time:toastDefaultTime animated:annimated completion:nil];
}

+ (XKProgressHUD *)showIMWarnMessage:(NSString *)message to:(UIView * _Nullable)view time:(NSTimeInterval)time animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion {
    return [self commonShowIMCustomIcon:@"xk_img_IM_hud_warn" message:message view:view time:time animated:YES completion:completion];
}

//custom
+ (XKProgressHUD *)commonShowIMCustomIcon:(NSString *)iconName message:(NSString *)message view:(UIView *)view time:(NSTimeInterval)aTime animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion {
    XKIMCustomProgressView *customView = [XKIMCustomProgressView hudWithImg:IMG_NAME(iconName) text:message textFont:XKRegularFont(12.0) textColor:[UIColor whiteColor]];
    XKProgressHUD *hud = [self showCustomView:customView to:view animated:annimated completion:nil];
    if (aTime > 0.0) {
        [hud hide:YES afterDelay:aTime];
    }
    return hud;
}

@end
