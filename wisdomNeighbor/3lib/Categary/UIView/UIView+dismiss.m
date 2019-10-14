//
//  XKUploadManager.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/9.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "UIView+dismiss.h"
#import <objc/runtime.h>


static const void * kPopviewDismissBlockAddr = "popview_dismissblock_addr";

@implementation UIView (dismiss)

- (void)setPopviewDismissBlock:(PopviewDismissBlock)popviewDismissBlock {
    objc_setAssociatedObject(self, kPopviewDismissBlockAddr, popviewDismissBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (PopviewDismissBlock)popviewDismissBlock {
    return objc_getAssociatedObject(self, kPopviewDismissBlockAddr);
}

@end
