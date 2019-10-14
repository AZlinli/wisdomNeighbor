//
//  UIImage+Edit.m
//  Erp4iOS
//	编辑图片的扩展
//  Created by fakepinge on 17/5/22.
//  Copyright © 2017年 成都好房通科技股份有限公司. All rights reserved.
//

#import "UIImage+Edit.h"
#import <CoreImage/CoreImage.h>

void ProviderReleaseData(void *info, const void *data, size_t size) {
	free((void *)data);
}

@implementation UIImage (Edit)
// 根据给定的frame截取一张新的图片
- (UIImage *)imageCutToRect:(CGRect)newRect {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x = newRect.origin.x * scale;
    CGFloat y = newRect.origin.y * scale;
    CGFloat width  = newRect.size.width  * scale;
    CGFloat height = newRect.size.height * scale;
    CGRect rect = CGRectMake(x, y, width, height);
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContextWithOptions(smallBounds.size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage *newImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return newImage;
}

// 根据给定的尺寸截取一张新的图片
- (UIImage *)imageScaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark ----------------------------- 公用方法 ------------------------------
#pragma mark - 增加图片亮度
- (UIImage *)setInputBrightness:(CGFloat)iBrightValue {
	UIImage *image = self;
	// 分配内存
	const int imageWidth = image.size.width;
	const int imageHeight = image.size.height;
	size_t bytesPerRow = imageWidth * 4;
	uint32_t *rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
	// 创建context
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
	CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
	// 遍历像素
	int pixelNum = imageWidth * imageHeight;
	uint32_t *pCurPtr = rgbImageBuf;
	for (int i = 0; i < pixelNum; i++, pCurPtr++) {
		uint8_t *ptr = (uint8_t *)pCurPtr;
		unsigned char red = ptr[1];
		unsigned char green = ptr[2];
		unsigned char blue = ptr[3];
		// 修改颜色
		int temp1 = 0xff - red ;
		int temp2 = 0xff - green;
		int temp3 = 0xff - blue;
		int temp = MIN(MIN(MIN(temp1, temp2), temp3), iBrightValue);
		unsigned char Value = temp;
		red = red + Value;
		red = (red < 0x00) ? 0x00 : (red > 0xff) ? 0xff : red;
		green = green + Value;
		green = (green < 0x00) ? 0x00 : (green > 0xff) ? 0xff : green;
		blue = blue + Value;
		blue = (blue < 0x00) ? 0x00 : (blue > 0xff) ? 0xff : blue;
		ptr[1] = red;
		ptr[2] = green;
		ptr[3] = blue;
	}
	// 将内存转成image
	CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight,ProviderReleaseData);
	CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL, true, kCGRenderingIntentDefault);
	CGDataProviderRelease(dataProvider);
	UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
	// 释放
	CGImageRelease(imageRef);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	return resultUIImage;
}

#pragma mark - 增加图片亮度 弃用 （这个是曝光度）
- (UIImage *)setInputLightness:(CGFloat)iBrightValue {
	UIImage *myImage = self;
	CIContext *context = [CIContext contextWithOptions:nil];
	CIImage *superImage = [CIImage imageWithCGImage:myImage.CGImage];
	CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
	[lighten setValue:superImage forKey:kCIInputImageKey];
	// 修改亮度   -1---1   数越大越亮
	[lighten setValue:@(iBrightValue / 255.f) forKey:@"inputBrightness"];
//	// 修改饱和度  0---2
//	[lighten setValue:@(0.5) forKey:@"inputSaturation"];
//	// 修改对比度  0---4
//	[lighten setValue:@(2.5) forKey:@"inputContrast"];
	CIImage *result = [lighten valueForKey:kCIOutputImageKey];
	CGImageRef cgImage = [context createCGImage:result fromRect:[superImage extent]];
	// 得到修改后的图片
	myImage = [UIImage imageWithCGImage:cgImage];
	// 释放对象
	CGImageRelease(cgImage);
	return myImage;
}

#pragma mark -- image转化成Base64位
- (NSString *)imageChangeBase64WithCompressionRatio:(CGFloat)ratio {
	UIImage *image = self;
	NSData *imageData = nil;
	// NSString *mimeType  = nil;
	if ([self imageHasAlpha:image]) {
		imageData = UIImagePNGRepresentation(image);
		// mimeType = @"image/png";
	} else {
		imageData = UIImageJPEGRepresentation(image, ratio);
		// mimeType = @"image/jpeg";
	}
	return [NSString stringWithFormat:@"%@",[imageData base64EncodedStringWithOptions:0]];
}

 #pragma mark - 通过URL生成指定大小的等宽等高二维码图片
+ (UIImage *)getQRCodeImageWithSize:(CGFloat)size codeUrlStr:(NSString *)codeUrlStr {
	// 实例化二维码滤镜
	CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
	// 恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
	[filter setDefaults];
	// 将字符串转换成NSdata
	NSData *data  = [codeUrlStr dataUsingEncoding:NSUTF8StringEncoding];
	// 通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
	[filter setValue:data forKey:@"inputMessage"];
	// 生成二维码
	CIImage *outputImage = [filter outputImage];
	// 调整生成二维码的大小
	UIImage *image = [UIImage changeImageSizeWithCIImage:outputImage size:size];
	return image;
}

- (UIImage *)roundImage {
    return [self roundImageWithCorners:UIRectCornerAllCorners];
}

- (UIImage *)roundImageWithCorners:(UIRectCorner)corners {
    return [self roundImageWithCorners:corners radius:self.size.width * 0.5];
}

- (UIImage *)roundImageWithCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    
    CGContextAddPath(context, maskPath.CGPath);
    CGContextClip(context);
    
    [self drawInRect:rect];
    
    UIImage *roundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return roundImage;
}

#pragma mark - 添加水印
+ (UIImage *)drawImage:(UIImage *)oldImage withText:(NSString *)text withRect:(CGRect)textRect shadowColor:(UIColor *)shadowColor textColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)alignment {
    // 上下文的大小
    int w = oldImage.size.width;
    int h = oldImage.size.height;
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    // 2.绘制图片
    [oldImage drawInRect:CGRectMake(0, 0, w, h)];
    // 3.绘制水印文字
    CGRect rect = CGRectMake(textRect.origin.x, textRect.origin.y, textRect.size.width, textRect.size.height);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = alignment;
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowBlurRadius = 5;
    shadow.shadowColor = shadowColor;
    shadow.shadowOffset = CGSizeMake(0, 1);
    // 文字的属性
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:textColor, NSShadowAttributeName:shadow, NSVerticalGlyphFormAttributeName:@(0)};
    // 将文字绘制上去
    [text drawInRect:rect withAttributes:dic];
    // 4.获取绘制到得图片
    UIImage *watermarkImage = UIGraphicsGetImageFromCurrentImageContext();
    // 5.结束图片的绘制
    UIGraphicsEndImageContext();
    return watermarkImage; // 获得添加水印后的图片
}

+ (UIImage *)drawImage:(UIImage *)oldImage withLogoImage:(UIImage *)logoImage withRect:(CGRect)logoRect {
    UIGraphicsBeginImageContext(oldImage.size);
    [oldImage drawInRect:CGRectMake(0, 0, oldImage.size.width, oldImage.size.height)];
    [logoImage drawInRect:CGRectMake(logoRect.origin.x, logoRect.origin.y, logoRect.size.width, logoRect.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)beginImageContext:(UIImage *)oldImage {
    // 上下文的大小
    int w = oldImage.size.width;
    int h = oldImage.size.height;
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    // 2.绘制图片
    [oldImage drawInRect:CGRectMake(0, 0, w, h)];
}

- (void)drawImage:(NSString *)text withRect:(CGRect)textRect shadowColor:(UIColor *)shadowColor textColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)alignment {
    CGRect rect = CGRectMake(textRect.origin.x,textRect.origin.y, textRect.size.width, textRect.size.height);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = alignment;
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowBlurRadius = 5;
    shadow.shadowColor = shadowColor;
    shadow.shadowOffset = CGSizeMake(3, 3);
    NSDictionary *dic = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:textColor,NSShadowAttributeName:shadow,NSVerticalGlyphFormAttributeName:@(0)};
    [text drawInRect:rect withAttributes:dic];
}

- (void)drawImage:(UIImage *)logoImage withRect:(CGRect)logoRect {
    [logoImage drawInRect:CGRectMake(logoRect.origin.x, logoRect.origin.y, logoRect.size.width, logoRect.size.height)];
}

- (UIImage *)endImageContext {
    UIImage *watermarkImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return watermarkImage;
}

#pragma mark - 创建纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark ----------------------------- 私有方法 ------------------------------
#pragma mark - 是否有透明度
- (BOOL)imageHasAlpha:(UIImage *)image {
	CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
	return (alpha == kCGImageAlphaFirst || alpha == kCGImageAlphaLast || alpha == kCGImageAlphaPremultipliedFirst || alpha == kCGImageAlphaPremultipliedLast);
}

#pragma mark - 调整图片大小
+ (UIImage *)changeImageSizeWithCIImage:(CIImage *)ciImage size:(CGFloat)size {
    CGRect extent = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImageRef = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImageRef);
    
    //保存bitmap到图片
    CGImageRef scaledImageRef = CGBitmapContextCreateImage(bitmapRef);
    UIImage *scaledImage = [UIImage imageWithCGImage:scaledImageRef];
    
    CGColorSpaceRelease(cs);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImageRef);
    CGImageRelease(scaledImageRef);
    
    return scaledImage;
}

@end
