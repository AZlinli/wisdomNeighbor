//
//  UIImage+Reduce.m
//  Erp4iOS
//    压缩图片的扩展
//  Created by Jamesholy on 17/5/25.
//  Copyright © 2017年 . All rights reserved.
//

#import "UIImage+Reduce.h"

#define kDefautImageSize (960 * 720)

@implementation UIImage (Reduce)

- (UIImage *)imageForReduceDefautImagePixels {
    CGFloat pixels = kDefautImageSize;
    UIImage *image = [self reduceImageForPixels:pixels];
    return [image fixOrientation];
}

- (UIImage *)imageForReduce:(CGFloat)imagePixels {
    CGFloat pixels = imagePixels;
    UIImage *image = [self reduceImageForPixels:pixels];
    return [image fixOrientation];
}

- (UIImage *)reduceImageForPixels:(CGFloat)suggestPixels {
    const CGFloat kMaxPixels = 4000000;
    const CGFloat kMaxRatio  = 3;
    CGFloat width = self.size.width;
    CGFloat height= self.size.height;
    // 对于超过建议像素，且长宽比超过max ratio的图做特殊处理
    if (width * height > suggestPixels &&
        (width / height > kMaxRatio || height / width > kMaxRatio)) {
        return [self scaleWithMaxPixels:kMaxPixels];
    } else {
        return [self scaleWithMaxPixels:suggestPixels];
    }
}

- (UIImage *)scaleWithMaxPixels:(CGFloat)maxPixels {
    CGFloat width = self.size.width;
    CGFloat height= self.size.height;
    if (width * height < maxPixels || maxPixels == 0) {
        return self;
    }
    CGFloat ratio = sqrt(width * height / maxPixels);
    if (fabs(ratio - 1) <= 0.01) {
        return self;
    }
    CGFloat newSizeWidth = width / ratio;
    CGFloat newSizeHeight= height/ ratio;
    return [self scaleToSize:CGSizeMake(newSizeWidth, newSizeHeight)];
}

// 内缩放，一条变等于最长边，另外一条小于等于最长边
- (UIImage *)scaleToSize:(CGSize)newSize {
    CGFloat width = self.size.width;
    CGFloat height= self.size.height;
    CGFloat newSizeWidth = newSize.width;
    CGFloat newSizeHeight= newSize.height;
    if (width <= newSizeWidth && height <= newSizeHeight) {
        return self;
    }
    if (width == 0 || height == 0 || newSizeHeight == 0 || newSizeWidth == 0) {
        return nil;
    }
    CGSize size;
    if (width / height > newSizeWidth / newSizeHeight) {
        size = CGSizeMake(newSizeWidth, newSizeWidth * height / width);
    } else {
        size = CGSizeMake(newSizeHeight * width / height, newSizeHeight);
    }
    return [self drawImageWithSize:size];
}

- (UIImage *)drawImageWithSize:(CGSize)size {
    CGSize drawSize = CGSizeMake(floor(size.width), floor(size.height));
    UIGraphicsBeginImageContext(drawSize);
    [self drawInRect:CGRectMake(0, 0, drawSize.width, drawSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)fixOrientation {
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height, CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (NSData *)imageCompressForSpecifyKB:(NSInteger)specifyKB {
    
    CGFloat currentRate = 1.0;
    const CGFloat stdSize = specifyKB*1024;
    NSData *resultData = UIImageJPEGRepresentation(self, currentRate);
    if (resultData.length > stdSize) {
        currentRate = 0.5;
        resultData = UIImageJPEGRepresentation(self, currentRate);
//        NSLog(@"try.rate = %.1f, try.size = %u", currentRate, resultData.length);
        const CGFloat rateOffset = resultData.length > stdSize ? -0.1 : 0.1;
        while (0 < currentRate && currentRate < 1) {
            //尝试下一级压缩
            NSData *tryData = UIImageJPEGRepresentation(self, currentRate+rateOffset);
//            NSLog(@"try.rate = %.1f, try.size = %u", currentRate+rateOffset, tryData.length);
            if (rateOffset < 0) {
                //如果不满足条件，则保存起来，并继续尝试
                currentRate += rateOffset;
                resultData = tryData;
                if (tryData.length <= stdSize) {
                    break;
                }
            } else {
                if (tryData.length < stdSize) {
                    currentRate += rateOffset;
                    resultData = tryData;
                } else {
                    break;
                }
            }
        }
    }
//    NSLog(@"ret.rate = %.1f, ret.size = %u", currentRate, resultData.length);
    return resultData;
}

@end
