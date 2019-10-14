//
//  XKJumpWebViewController.h
//  XKSquare
//
//  Created by hupan on 2018/10/24.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseWKWebViewController.h"

typedef enum : NSUInteger {
    JumpWebVC_normal,
    JumpWebVC_H5games,
} JumpWebVC;

@interface XKJumpWebViewController : BaseWKWebViewController

@property (nonatomic, assign) JumpWebVC jumpWebVCType;

//JumpWebVC_H5games时传
@property (nonatomic, copy) NSString *gameId;

@property (nonatomic, assign) BOOL needEdge;
// 如果传入的是url，则加载url
@property (nonatomic, copy) NSString *url;//注意汉字编码问题
// 如果传入的是html，则渲染html
@property (nonatomic, copy) NSString *html;

@end
