//
//  XKUploadManager.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/9.
//  Copyright © 2018年 xk. All rights reserved.
// commit 1 commit 2

#import <UIKit/UIKit.h>

typedef void(^PopviewDismissBlock)(void);

@interface UIView (dismiss)

/**消失*/
@property (nonatomic, copy) PopviewDismissBlock popviewDismissBlock;

@end
