//
//  GlobleCommonTool.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/22.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GlobleCommonTool : NSObject
+ (void)showBigImgWithImgsArr:(NSArray *)arr defualtIndex:(NSInteger)index viewController:(UIViewController *)viewController;

/**
 获取当前的时间
 */
+ (void)getCurrentDate;

/**
 通过当前时间显示背景图片

 @param bgImageView 需要显示的背景视图
 */
+ (void)configTimeHourWith:(UIImageView *)bgImageView;

/**
 跳转到个人朋友圈列表

 @param userId 需要跳转的UserId
 @param name 需要跳转的name
 @param headerIcon 需要跳转的headerIcon
 */
+ (void)jumpCircleListWithUserId:(NSString *)userId name:(NSString *)name headerIcon:(NSString *)headerIcon;

/**
 跳转到个人资料
 
 @param userId 需要跳转的UserId
 @param name 需要跳转的name
 @param headerIcon 需要跳转的headerIcon
 */
+ (void)jumpPersonalDataWithUserId:(NSString *)userId name:(NSString *)name headerIcon:(NSString *)headerIcon;

/**
 判断当前用户是否是自己，如果是自己就跳转到朋友圈列表，如果不是自己就跳转到个人资料页面
 
 @param userId 需要跳转的UserId
 @param name 需要跳转的name
 @param headerIcon 需要跳转的headerIcon
 */
+ (void)jumpToPersonalDataOrCircleListWithUserId:(NSString *)userId name:(NSString *)name headerIcon:(NSString *)headerIcon;
@end

NS_ASSUME_NONNULL_END
