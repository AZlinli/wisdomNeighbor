//
//  XKJumpWebViewController.m
//  XKSquare
//
//  Created by hupan on 2018/10/24.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKJumpWebViewController.h"

@interface XKJumpWebViewController ()<BaseWKWebViewDelegate>

@end

@implementation XKJumpWebViewController


#pragma mark - Life Cycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationBar];
    
    if (self.jumpWebVCType == JumpWebVC_H5games) {
        self.delegate = self;
        [self creatWkWebViewWithMethodNameArray:nil requestUrlString:self.url];
    } else {
        if (self.url) {
            [self creatWkWebViewWithMethodNameArray:nil requestUrlString:self.url];
        } else {
            [self creatWkWebViewWithMethodNameArray:nil requestUrlString:nil];
            if (self.html) {
                [self.webView loadHTMLString:self.html baseURL:nil];
            }
        }
    }
    
    
    NSArray *parmArr = [self.url componentsSeparatedByString:@"?"];
    NSMutableDictionary *tmpDic = @{}.mutableCopy;
    if (parmArr.count == 2) {
        NSString *parmStr = parmArr[1];
        NSArray *keyValues = [parmStr componentsSeparatedByString:@"&"];
        for (NSString *keyValue in keyValues) {
            NSArray *arr = [keyValue componentsSeparatedByString:@"="];
            [tmpDic setValue:arr[1] forKey:arr[0]];
        }
    }
    if ([[tmpDic allKeys] containsObject:@"isHead"]) {
        NSString *value = tmpDic[@"isHead"];
        if (value.integerValue == 2) {//没有导航
            [self hideNavigation];
            [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(-kStatusBarHeight, 0, 0, 0));
            }];
        } else {
          [self configViews];
        }
    } else {
        [self configViews];
    }
    
}

- (void)didPopToPreviousController {
    [self removeAllScriptMessageHandler];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Metheods


- (void)configNavigationBar {
    if (self.title) {
        [self setNavTitle:self.title WithColor:[UIColor blackColor]];
    } else {
        [self setNavTitle:@"详情" WithColor:[UIColor blackColor]];
    }
}

- (void)configViews {
    
    if (self.jumpWebVCType == JumpWebVC_H5games) {
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height, 0, 0, 0));
        }];
    } else {
        if (self.needEdge) {
            [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height + 10, 10, 10, 10));
            }];
        } else {
            [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height, 0, 0, 0));
            }];
        }
    }
}



#pragma mark - BaseWKWebViewDelegate

- (void)WkWebViewGetRedirectedUrl:(NSURL *)url {
    NSLog(@"跨域url=%@", url);

}


#pragma mark - Getters and Setters

@end
