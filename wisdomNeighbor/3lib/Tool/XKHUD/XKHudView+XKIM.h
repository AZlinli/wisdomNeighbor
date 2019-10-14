//
//  XKHudView+XKIM.h
//  XKSquare
//
//  Created by Jamesholy on 2019/4/26.
//  Copyright © 2019 xk. All rights reserved.
//

#import "XKHudView.h"


@interface XKHudView (XKIM)


+ (XKProgressHUD *)showIMLoadingTo:(UIView *_Nullable)view animated:(BOOL)annimated;
+ (XKProgressHUD *)showIMLoadingMessage:(NSString* _Nullable)message to:(UIView *_Nullable)view animated:(BOOL)annimated;

+ (XKProgressHUD *)showIMSuccessMessage:(NSString *_Nullable)message;
+ (XKProgressHUD *)showIMSuccessMessage:(NSString *_Nullable)message to:(UIView *_Nullable)view animated:(BOOL)annimated;
+ (XKProgressHUD *)showIMSuccessMessage:(NSString *_Nullable)message to:(UIView *_Nullable)view time:(NSTimeInterval)time animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion;

+ (XKProgressHUD *)showIMErrorMessage:(NSString *_Nullable)message;
+ (XKProgressHUD *)showIMErrorMessage:(NSString *_Nullable)message to:(UIView *_Nullable)view animated:(BOOL)annimated;
+ (XKProgressHUD *)showIMErrorMessage:(NSString *_Nullable)message to:(UIView *_Nullable)view time:(NSTimeInterval)time animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion;

+ (XKProgressHUD *)showIMInfoMessage:(NSString *_Nullable)message;
+ (XKProgressHUD *)showIMInfoMessage:(NSString *_Nullable)message to:(UIView *_Nullable)view animated:(BOOL)annimated;
+ (XKProgressHUD *)showIMInfoMessage:(NSString *_Nullable)message to:(UIView *_Nullable)view time:(NSTimeInterval)time animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion;

+ (XKProgressHUD *)showIMWarnMessage:(NSString *_Nullable)message;
+ (XKProgressHUD *)showIMWarnMessage:(NSString *_Nullable)message to:(UIView *_Nullable)view animated:(BOOL)annimated;
+ (XKProgressHUD *)showIMWarnMessage:(NSString *_Nullable)message to:(UIView *_Nullable)view time:(NSTimeInterval)time animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion;

+ (XKProgressHUD *)commonShowIMCustomIcon:(NSString *)iconName message:(NSString *)message view:(UIView *)view time:(NSTimeInterval)aTime animated:(BOOL)annimated completion:(XKHudCompletion _Nullable)completion;
@end


