//
//  XKVideoDisplayMediator.h
//  XKSquare
//
//  Created by RyanYuan on 2018/11/7.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 列表播放类型
 */
typedef NS_ENUM(NSUInteger, XKVideoDisplayMediatorVideoListType) {
    XKVideoDisplayMediatorVideoListTypeHomePageRecommend = 1,       /** 首页推荐小视频列表 */
    XKVideoDisplayMediatorVideoListTypeRecommend,                   /** 推荐小视频列表 */
    XKVideoDisplayMediatorVideoListTypeSameCity,                    /** 同城小视频列表 */
    XKVideoDisplayMediatorVideoListTypeMyProduction,                /** 我的作品小视频列表 */
    XKVideoDisplayMediatorVideoListTypeMyCollection,                /** 我的收藏小视频列表 */
    XKVideoDisplayMediatorVideoListTypeMyHistory,                   /** 我的足迹小视频列表 */
    XKVideoDisplayMediatorVideoListTypeOtherProduction              /** 他人小视频列表 */
};

@class XKVideoDisplayVideoListItemModel;

@interface XKVideoDisplayMediator : NSObject

// ======================================== 列表播放 ========================================


// ======================================== 单独播放 ========================================
/**
 *  根据视频URL播放视频，不展示视频信息，附带转场动画，支持 http(s) (url 以 http:// https:// 开头)及 rtmp (url 以 rtmp:// 开头) 协议
 *
 *  @param viewController 当前控制器
 *  @param urlString 视频URL字符串
 *  @param view 触发播放操作的视图，用于生成转场动画，非必填
 */
+ (void)displaySingleVideoClearWithViewController:(UIViewController * _Nonnull)viewController
                                        urlString:(NSString * _Nonnull)urlString
                                         fromView:(UIView * _Nullable)view;

/**
 *  根据视频本地路径播放视频，不展示视频信息，附带转场动画，支持 file:// 及 assets-library://
 *
 *  @param viewController 当前控制器
 *  @param localFilePath 本地视频路径
 *  @param view 触发播放操作的视图，用于生成转场动画，非必填
 */
+ (void)displayLocalSingleVideoClearWithViewController:(UIViewController * _Nonnull)viewController
                                         localFilePath:(NSString * _Nonnull)localFilePath
                                              fromView:(UIView * _Nullable)view;

@end
