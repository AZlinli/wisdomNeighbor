//
//  CYLTabBarController.m
//  CYLTabBarController
//
//  v1.16.0 Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2015 https://github.com/ChenYilong . All rights reserved.
//

#import "UIControl+CYLTabBarControllerExtention.h"
#import <objc/runtime.h>
#import "UIView+CYLTabBarControllerExtention.h"
#import "CYLConstants.h"
#import "UIView+Frame.h"

@implementation UIControl (CYLTabBarControllerExtention)

- (void)cyl_showTabBadgePoint:(UIView *)view {
    [self cyl_setShowTabBadgePointIfNeeded:YES view:view];
}

- (void)cyl_removeTabBadgePoint:(UIView *)view  {
    [self cyl_setShowTabBadgePointIfNeeded:NO view:view];
}

- (BOOL)cyl_isShowTabBadgePoint {
    return !self.cyl_tabBadgePointView.hidden;
}

- (void)cyl_setShowTabBadgePointIfNeeded:(BOOL)showTabBadgePoint view:(UIView *)view {
    @try {
        [self cyl_setShowTabBadgePoint:showTabBadgePoint view:view];
    } @catch (NSException *exception) {
        NSLog(@"CYLPlusChildViewController do not support set TabBarItem red point");
    }
}

- (void)cyl_setShowTabBadgePoint:(BOOL)showTabBadgePoint view:(UIView *)view {
    if (showTabBadgePoint && self.cyl_tabBadgePointView.superview == nil) {
        [self addSubview:self.cyl_tabBadgePointView];
        [self bringSubviewToFront:self.cyl_tabBadgePointView];
        self.cyl_tabBadgePointView.layer.zPosition = MAXFLOAT;
        
        self.cyl_tabBadgePointView.frame = CGRectMake(0, 0, 9, 9);
        self.cyl_tabBadgePointView.x = self.cyl_tabImageView.right-2;
        self.cyl_tabBadgePointView.y = self.cyl_tabImageView.top - 2;
        
        if (view) {
            [self layoutIfNeeded];
            [view layoutIfNeeded];
          
            CGRect frame= [self convertRect:self.cyl_tabBadgePointView.frame toView:view];
            NSLog(@"%@",NSStringFromCGRect(frame));
//            [self.cyl_tabBadgePointView removeFromSuperview];
            [view addSubview:self.cyl_tabBadgePointView];
            self.cyl_tabBadgePointView.frame = frame;
            
            NSLog(@"%@",NSStringFromCGRect(self.cyl_tabBadgePointView.frame));
        }
        
    }
    self.cyl_tabBadgePointView.hidden = showTabBadgePoint == NO;
    self.cyl_tabBadgeView.hidden = showTabBadgePoint == YES;
}

- (void)cyl_setTabBadgePointView:(UIView *)tabBadgePointView {
    UIView *tempView = objc_getAssociatedObject(self, @selector(cyl_tabBadgePointView));
    if (tempView) {
        [tempView removeFromSuperview];
    }
    if (tabBadgePointView.superview) {
        [tabBadgePointView removeFromSuperview];
    }
    
    tabBadgePointView.hidden = YES;
    objc_setAssociatedObject(self, @selector(cyl_tabBadgePointView), tabBadgePointView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)cyl_tabBadgePointView {
    UIView *tabBadgePointView = objc_getAssociatedObject(self, @selector(cyl_tabBadgePointView));
    
    if (tabBadgePointView == nil) {
        tabBadgePointView = self.cyl_defaultTabBadgePointView;
        objc_setAssociatedObject(self, @selector(cyl_tabBadgePointView), tabBadgePointView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tabBadgePointView;
}

- (void)cyl_setTabBadgePointViewOffset:(UIOffset)tabBadgePointViewOffset {
    objc_setAssociatedObject(self, @selector(cyl_tabBadgePointViewOffset), [NSValue valueWithUIOffset:tabBadgePointViewOffset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//offset如果都是正数，则往右下偏移
- (UIOffset)cyl_tabBadgePointViewOffset {
    id tabBadgePointViewOffsetObject = objc_getAssociatedObject(self, @selector(cyl_tabBadgePointViewOffset));
    UIOffset tabBadgePointViewOffset = [tabBadgePointViewOffsetObject UIOffsetValue];
    return tabBadgePointViewOffset;
}

- (UIView *)cyl_tabBadgeView {
    for (UIView *subview in self.subviews) {
        if ([subview cyl_isTabBadgeView]) {
            return (UIView *)subview;
        }
    }
    return nil;
}

- (UIImageView *)cyl_tabImageView {
    for (UIImageView *subview in self.subviews) {
        if ([subview cyl_isTabImageView]) {
            return (UIImageView *)subview;
        }
    }
    return nil;
}

- (UILabel *)cyl_tabLabel {
    for (UILabel *subview in self.subviews) {
        if ([subview cyl_isTabLabel]) {
            return (UILabel *)subview;
        }
    }
    return nil;
}

#pragma mark - private method

- (UIView *)cyl_defaultTabBadgePointView {
    UIView *defaultRedTabBadgePointView = [UIView cyl_tabBadgePointViewWithClolor:[UIColor redColor] radius:4.5];
    return defaultRedTabBadgePointView;
}

@end

