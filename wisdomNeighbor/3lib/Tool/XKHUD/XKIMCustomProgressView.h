//
//  XKIMCustomProgressView.h
//  XKSquare
//
//  Created by xudehuai on 2019/3/8.
//  Copyright © 2019 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKIMCustomProgressView : UIView

+ (instancetype)hudWithImg:(UIImage *)img text:(NSString *)text textFont:(UIFont *)textFont textColor:(UIColor *)textColor;

- (void)startLoading;

- (void)stopLoading;

@end

NS_ASSUME_NONNULL_END
