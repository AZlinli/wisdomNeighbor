//
//  UIImage+Common.h
//  Erp4iOS
//    编辑图片的扩展
//  Created by fakepinge on 17/5/22.
//  Copyright © 2017年 成都好房通科技股份有限公司. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIImage (Common)

+(UIImage *)imageWithColor:(UIColor *)aColor;
+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;

- (UIImage *)clipImageWithRadius:(CGFloat)radius;
@end
