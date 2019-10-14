//
//  XKCommonDefine.h
//  XKComponentBaseProject
//
//  Created by Jamesholy on 2019/2/28.
//  Copyright © 2019 Jamesholy. All rights reserved.
//

#ifndef XKCommonDefine_h
#define XKCommonDefine_h




//--------------------------  数据库表名  --------------------------
//#define XKHistorySearchTable    [NSString stringWithFormat:@"%@_%@", @"XKHistorySearchTable", [XKUserInfo getCurrentUserId]]
#define XKIMP2PTopChatDataBaseTable                   @"XKIMP2PTopChatDataBaseTable"              //可友单聊置顶
#define XKIMTeamTopChatDataBaseTable                  @"XKIMTeamTopChatDataBaseTable"             //可友群聊置顶
#define XKIMSecretTopChatDataBaseTable                @"XKIMSecretTopChatDataBaseTable"           //密友单聊置顶
#define XKIMSecretSilenceChatDataBaseTable            @"XKIMSecretSilenceChatDataBaseTable"       //密友单聊静音
#define XKHistorySearchDataBaseTable                  @"XKHistorySearchDataBaseTable"             //搜索历史
#define XKHistoryGamesDataBaseTable                   @"XKHistoryGamesDataBaseTable"              //游戏历史(玩过的)
#define XKHistorySearchGamesDataBaseTable             @"XKHistorySearchGamesDataBaseTable"        //搜索游戏历史
#define XKIMTeamChatShowNickNameBaseTable             @"XKIMTeamChatShowNickNameBaseTable"        //群聊显示昵称
#define XKIMSecretChatLastMessageDataBaseTable        @"XKIMSecretChatLastMessageDataBaseTable"   //密友最后一条消息
#define XKIMSecretMessageFireMyselfDataBaseTable      @"XKIMSecretMessageFireMyselfDataBaseTable" //阅后即焚自己
#define XKIMSecretMessageFireOtherDataBaseTable       @"XKIMSecretMessageFireOtherDataBaseTable"  //阅后即焚对方
#define XKTouchIdOrFaceIdServerCheckCodeDataBaseTable @"XKTouchIdOrFaceIdServerCheckCodeDataBaseTable"  //TouchID/FaceID服务器校验码
//--------------------------  数据库表名  --------------------------


//app信息
#define XKAppVersion  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define KEY_WINDOW [UIApplication sharedApplication].keyWindow
//NavBar高度
#define NavigationBar_HEIGHT 44 //默认的NAVERgationBar 高度
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏高度。 iPhone X 之前是 20 iPhone X 是 44
#define NavigationAndStatue_Height (kStatusBarHeight+NavigationBar_HEIGHT)

#define kBottomSafeHeight ((iPhoneX)?(34):(0))  //距离底部的安全距离

#define TabBar_Height (50 + kBottomSafeHeight)   // Tabbar height.
// 导航栏适配X
#define kIphoneXNavi(XValue) (iPhoneX_Serious ? (XValue + 24) : (XValue))
//头像 大
#define BigAvatarWidth     (SCREEN_WIDTH>320?44:40)
//获取屏幕 宽度、高度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define BUTTON_WIDTH ((([UIScreen mainScreen].bounds.size.width) / 4) * 3)
#define BUTTON_HEIGHT (((([UIScreen mainScreen].bounds.size.width) / 4) * 3) / 6.3)

//根据375得到的比例

#define ScreenScale [NSString stringWithFormat:@"%.2f", SCREEN_WIDTH / 375.f].floatValue

#define KFitScale (ScreenScale>1.0 ?:1.0)

//根据667得到的比例 尽量不要使用这个 因为x xr xs 高度比正常的大
#define ScreenHeightScale [[UIScreen mainScreen] bounds].size.height/667.f
// 三个屏幕尺寸对应的宽度高度 从大到小
#define kLMSScreenFit(L,M,S) ((SCREEN_WIDTH>=414.0f) ? (L) : (SCREEN_WIDTH>=375.0f) ? (M) : (S))
// 建议用这个适配
#define kLMS(L,M,S) kLMSScreenFit(L,M,S)


//是否iphone5   320*568
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
// 是否为iPhone4/4S  320*480
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO)
// 是否为iPhone6/6S/7/7S  375*667
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen] currentMode].size) : NO)
// 是否为iPhone6*Plus/7*Plus   414*736
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)


//是否iPhone X 系列 兼容老代码 新代码判断是否有刘海请使用iPhoneX_Serious判断 单独判断iphoneX使用iphoneX_X
#define iPhoneX iPhoneX_Serious
//是否iPhone X 系列 用于判断是否有刘海
#define iPhoneX_Serious ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)

//判断iPhoneX、iPhoneXs 逻辑点375*812
#define iphoneX_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define iphoneX_Xs  iphoneX_X

//判断iPHoneXr  逻辑点414*896
#define iphoneX_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhoneXs Max   逻辑点414*896
#define iphoneX_XsMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)


//**************************  颜色  **************************************************

// RGB颜色
#define RGB(r,g,b) RGBA(r,g,b,1)
// RGB颜色 灰色
#define RGBGRAY(A) RGB(A,A,A)
// 16进制颜色
#define HEX_RGB(rgbValue) HEX_RGBA(rgbValue, 1.0)
// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 16进制颜色+透明度
#define HEX_RGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0f \
blue:((float)(rgbValue & 0x0000FF))/255.0f \
alpha:alphaValue]
//默认分割线颜色
#define XKSeparatorLineColor UIColorFromRGB(0xF1F1F1)
//主体颜色
#define XKMainTypeColor UIColorFromRGB(0x4A90FA)
#define XKMainRedColor UIColorFromRGB(0xEE6161)
//密友颜色
#define XKSecreatFriendTypeColor UIColorFromRGB(0x4A90FA)
//***************************** 字体 *************************************************
#define XKFont(fontName,fontSize)   [UIFont setFontWithFontName:fontName andSize:fontSize]
#define XKRegularFont(fontSize)     XKFont(XK_PingFangSC_Regular,fontSize)
#define XKSemiboldFont(fontSize)    XKFont(XK_PingFangSC_Semibold,fontSize)
#define XKMediumFont(fontSize)      XKFont(XK_PingFangSC_Medium,fontSize)
#define XKNormalFont(fontSize)      [UIFont systemFontOfSize:fontSize]

//***************************** UI *************************************************
#define XKViewSize(size) size * KFitScale

#define XK_PingFangSC_Regular   @"PingFangSC-Regular"
#define XK_PingFangSC_Semibold  @"PingFangSC-Semibold"
#define XK_PingFangSC_Medium    @"PingFangSC-Medium"

//******************************* 强弱引用 ***********************************************
#define XKWeakSelf(weakSelf)     __weak __typeof(&*self)    weakSelf  = self;
#define XKStrongSelf(strongSelf)  __strong __typeof(&*self) strongSelf = weakSelf;

// 一般对象的弱引用
#define WEAK_TYPES(instance) __weak typeof(instance) weak##instance = instance;
//******************************* 安全执行block *******************************
#define EXECUTE_BLOCK(A,...) if(A){A(__VA_ARGS__);}


// log
#ifdef DEBUG
#define NSLog(...) {NSTimeInterval time_interval = [[NSDate date]timeIntervalSince1970];\
NSString *logoInfo = [NSString stringWithFormat:__VA_ARGS__];\
printf("%f  %s\n",time_interval,[logoInfo UTF8String]); \
[[NSNotificationCenter defaultCenter] postNotificationName:@"xk_log_noti" object: [NSString stringWithFormat:@"%.2f %@\n %@\n",time_interval,[NSThread currentThread],logoInfo]];}

#else
#define NSLog(...)
#endif


/* --------------------------- 常用工具宏-----------------------------*/
#define XKUserDefault               [NSUserDefaults standardUserDefaults]

#define IMG_NAME(imgName) [UIImage imageNamed:imgName]
#define kURL(urlStr) [NSURL URLWithString:urlStr]

#define kNeedFixHudOffestViewTag 1314520

#define FIXME_TO_WRITE_FUNCTION [XKAlertView showCommonAlertViewWithTitle:[NSString stringWithFormat:@"%s\n方法未实现功能",__func__]];


/* ------------------------- NSUserDefaults的相关 ------------------------*/
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
// 获得存储的对象
#define UserDefaultSetObjectForKey(__VALUE__,__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] setObject:__VALUE__ forKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}
// 取值
#define UserDefaultObjectForKey(__KEY__)  [[NSUserDefaults standardUserDefaults] objectForKey:__KEY__]
// 删除对象
#define UserDefaultRemoveObjectForKey(__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}




#endif /* XKCommonDefine_h */
