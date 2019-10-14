//
//  BaseViewController.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/11.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, BaseNavStyle) {
    BaseNavBlueStyle = 0 , // 蓝色风格
    BaseNavWhiteStyle = 1, // 白色风格
};

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
/**
 导航栏颜色状态
 强行改颜色 不用关心图片和原本文字颜色
 基类layoutsubview里会根据风格统一改变所有颜色
 */
@property(nonatomic, assign) BaseNavStyle navStyle;
@property (nonatomic, strong) UIView *navigationView;
/**
 用于网络出错提示
 */
@property(nonatomic, strong) XKEmptyPlaceView *emptyTipView;
/**
 隐藏NavigationBar
 */
- (void)hideNavigation;
/**
 隐藏NavigationBar底部的线
 */
- (void)hideNavigationSeperateLine;

/**
 隐藏返回按钮
 */
- (void)hiddenBackButton:(BOOL)hidden;
/**
 隐藏右侧按钮
 */
- (void)hiddenRightButton:(BOOL)hidden;
/**
 设置Navigation标题
 
 @param string 标题
 @param color 颜色
 */
- (void)setNavTitle:(NSString *)string WithColor:(UIColor *)color;

/**
 设置Navigation富文本标题
 
 @param attributedTitle 富文本
 */
- (void)setNavAttributedTitle:(NSAttributedString *)attributedTitle;

/**
 设置返回按钮
 
 @param image 返回图标 传nil为默认
 @param string 返回文字 传nil为空
 */
- (void)setBackButton:(UIImage *)image andName:(NSString *)string;

//必须_backButton存在时调用
- (void)changeBackButton:(UIImage *)image frame:(CGRect)frame;

/**
 设置导航栏customview
 
 @param view view
 @param rect rect
 */
- (void)setNaviCustomView:(UIView *)view withframe:(CGRect)rect;

/**
 设置导航栏左边view
 
 @param view view
 @param rect rect
 */
- (void)setLeftView:(UIView *)view withframe:(CGRect)rect;

/**
 设置导航栏中间view
 
 @param view view
 @param rect rect
 */
- (void)setMiddleView:(UIView *)view withframe:(CGRect)rect;

/**
 设置导航栏右边view
 
 @param view view
 @param rect rect
 */
- (void)setRightView:(UIView *)view withframe:(CGRect)rect;

/**
 重写时用
 */
- (void)backBtnClick;

/**
 处理默认数据
 */
- (void)handleData;

/**
 处理自定义视图
 */
- (void)addCustomSubviews;

- (void)resetMJHeaderFooter:(RefreshDataStatus)refreshStatus tableView:(UIScrollView *)tableView dataArray:(NSArray *)dataArry;

/**
 将要pop到上一个界面
 */
- (void)willPopToPreviousController;

/**
 已经pop到上一个界面
 */
- (void)didPopToPreviousController;

/**
 获取到标题标签
 */
- (UILabel *)getTitleLab;
@end

NS_ASSUME_NONNULL_END
