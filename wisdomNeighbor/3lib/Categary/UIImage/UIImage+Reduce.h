//
//  UIImage+Reduce.h
//  Erp4iOS
//	压缩图片的扩展
//  Created by Jamesholy on 17/5/25.
//  Copyright © 2017年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Reduce)

/**
 上传图片压缩 默认比例  (960 * 720)

 @return 压缩后的图片
 */
- (UIImage *)imageForReduceDefautImagePixels;

/**
 上传图片压缩 自定义比例 width * height

 @param imagePixels 自定义比例 width * height
 @return 压缩后的图片
 */
- (UIImage *)imageForReduce:(CGFloat)imagePixels;

- (UIImage *)fixOrientation;


/**
 压缩图片

 @param specifyKB 指定kb大小

 @return data
 */
- (NSData *)imageCompressForSpecifyKB:(NSInteger)specifyKB;

@end
