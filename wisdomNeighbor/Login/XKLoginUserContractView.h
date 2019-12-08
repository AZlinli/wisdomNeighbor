//
//  XKLoginUserContractView.h
//  XKSquare
//
//  Created by Lin Li on 2019/1/4.
//  Copyright © 2019 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef  void(^contractBlock)(void);

@interface XKLoginUserContractView : UIView

- (instancetype)initWithContractTitle:(NSString *)contractTitle contractFixationTitle:(NSString *)contractFixationTitle;

/**选择按钮*/
@property(nonatomic, strong) UIButton *selectButton;

/**是否已经同意协议*/
@property(nonatomic, assign) BOOL isAgreeContract;

/**用户协议的回调*/
@property(nonatomic, copy) contractBlock contractBlock;

/**固定的合同前缀*/
@property(nonatomic, copy) NSString *contractFixationTitle;

@end

NS_ASSUME_NONNULL_END
