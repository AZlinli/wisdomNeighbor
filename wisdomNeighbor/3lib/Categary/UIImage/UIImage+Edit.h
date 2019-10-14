//
//  UIImage+Edit.h
//  Erp4iOS
//	编辑图片的扩展
//  Created by fakepinge on 17/5/22.
//  Copyright © 2017年 成都好房通科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Edit)

/**
 根据给定的frame截取一张新的图片

 @param newRect 给定的frame
 @return 裁剪后的新图片
 */
- (UIImage *)imageCutToRect:(CGRect)newRect;
/**
 根据给定的尺寸截取一张新的图片

 @param newSize 给定的尺寸
 @return 裁剪后的心图片
 */
- (UIImage *)imageScaledToSize:(CGSize)newSize;
/**
 通过URL生成指定大小的等宽等高二维码图片
 
 @param size 大小
 @param codeUrlStr 要生成二维码的url字符串
 @return 返回二维码图片
 */
+ (UIImage *)getQRCodeImageWithSize:(CGFloat)size codeUrlStr:(NSString *)codeUrlStr;

/**
 增加图片亮度

 @param iBrightValue 增加亮度值 0 - 255
 @return 处理过后的图片
 */
- (UIImage *)setInputBrightness:(CGFloat)iBrightValue;

/**
 增加图片亮度 请用上面的方法 测试方法 （这个是曝光度）
 
 @param iBrightValue 增加亮度值 0 - 255
 @return 处理过后的图片
 */
- (UIImage *)setInputLightness:(CGFloat)iBrightValue;

/**
 image转化成Base64位编码
 
 @param ratio 压缩比 0 - 1
 @return 处理过后的图片字符串
 */
- (NSString *)imageChangeBase64WithCompressionRatio:(CGFloat)ratio;

/**
 get圆角图片，默认四个角圆角，圆角半径为图片 ‘width’ 的一半
 
 @return 圆角图
 */
- (UIImage *)roundImage;


/**
 get圆角图片，默认圆角半径为图片 ‘width’ 的一半
 
 @param corners 需要圆角的角
 @return 圆角图
 */
- (UIImage *)roundImageWithCorners:(UIRectCorner)corners;


/**
 get圆角图片
 
 @param corners 需要圆角的角
 @param radius 圆角半径
 @return 圆角图
 */
- (UIImage *)roundImageWithCorners:(UIRectCorner)corners radius:(CGFloat)radius;

/**创建纯色图片*/
+ (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect;

#pragma mark - 添加水印
/**
 *  图片添加文字水印
 *
 *  @param oldImage 需要添加文字水印的图片
 *  @param text     文字
 *  @param textRect 水印添加的位置
 *
 *  @return 添加了水印的图片
 */
+ (UIImage *)drawImage:(UIImage *)oldImage withText:(NSString *)text withRect:(CGRect)textRect shadowColor:(UIColor *)shadowColor textColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)alignment;
/**
 *  图片添加图片水印
 *
 *  @param oldImage  需要添加图片水印的图片
 *  @param logoImage Logo
 *  @param logoRect 水印添加的位置
 *
 *  @return 添加了水印的图片
 */
+ (UIImage *)drawImage:(UIImage *)oldImage withLogoImage:(UIImage *)logoImage withRect:(CGRect)logoRect;

- (void)beginImageContext:(UIImage *)oldImage;

- (void)drawImage:(NSString *)text withRect:(CGRect)textRect shadowColor:(UIColor *)shadowColor textColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)alignment;

- (void)drawImage:(UIImage *)logoImage withRect:(CGRect)logoRect;

- (UIImage *)endImageContext;

@end
