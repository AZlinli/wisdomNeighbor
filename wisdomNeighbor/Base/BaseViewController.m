//
//  BaseViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/11.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseViewFactory.h"

@interface BaseViewController () {
    UIButton *_backButton;
    UIView *_rightView;
    UILabel *_titleLabel;
    UIView *_customView;
    UIView *_leftView;
    UIView *_middleView;
    UIView *_lineView;
}

@end
@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigation];
    [self handleData];
    [self addCustomSubviews];
    if (self.title) {
        [self setNavTitle:self.title WithColor:[UIColor whiteColor]];
    }
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
#if DEBUG
    [self.view becomeFirstResponder];
#endif
    
}

- (void)dealloc {
    NSLog(@"%@_dealloc", [self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [IQKeyboardManager sharedManager].enable = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [self setNavStyle];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

-(void)initNavigation{
    Method method = class_getInstanceMethod([UIImage class], @selector(imageNamed:));
    Method change = class_getInstanceMethod([UIImage class], @selector(initWithArray:));
    method_exchangeImplementations(method, change);
    
    _navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationAndStatue_Height)];
    _navigationView.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, NavigationAndStatue_Height - 0.5, SCREEN_WIDTH, 0.5)];
    _lineView.tag = 101;
    _lineView.backgroundColor = XKSeparatorLineColor;
    [_navigationView addSubview:_lineView];
    [self.view addSubview:_navigationView];
    [self setBackButton:nil andName:nil];
}

- (void)setNavTitle:(NSString *)string WithColor:(UIColor *)color {
    
    if (!_titleLabel) {
        _titleLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, SCREEN_WIDTH - 120, NavigationBar_HEIGHT) text:string font:[UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:18] textColor:color?color:[UIColor blackColor] backgroundColor:[UIColor clearColor]];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_navigationView addSubview:_titleLabel];
    } else {
        _titleLabel.text = string;
        _titleLabel.textColor = color;
    }
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.navigationView.mas_centerX);
        make.bottom.mas_equalTo(self.navigationView.mas_bottom);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH - 120.0);
        make.height.mas_equalTo(NavigationBar_HEIGHT);
    }];
}

- (void)setNavAttributedTitle:(NSAttributedString *)attributedTitle {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_navigationView addSubview:_titleLabel];
    }
    _titleLabel.attributedText = attributedTitle;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.navigationView.mas_centerX);
        make.bottom.mas_equalTo(self.navigationView.mas_bottom);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH - 130.0);
        make.height.mas_equalTo(NavigationBar_HEIGHT);
    }];
}

/**
 * 隐藏导航栏
 */
- (void)hideNavigation{
    _navigationView.hidden = YES;
}

- (void)hideNavigationSeperateLine {
    UIView *line = [_navigationView viewWithTag:101];
    line.hidden = YES;
}

- (void)hiddenBackButton:(BOOL)hidden {
    if (_backButton) {
        _backButton.hidden = hidden;
    }
}

- (void)hiddenRightButton:(BOOL)hidden {
    if (_rightView) {
        _rightView.hidden = hidden;
    }
}

-(void)setBackButton:(UIImage *)image andName:(NSString *)string{
    UIImage *backImg;
    if (image == nil) {
        backImg = [UIImage imageNamed:@"xk_ic_login_back"];
    } else {
        backImg = image;
    }
    
    if (string == nil) {
        if (!_backButton) {
            _backButton = [[UIButton alloc]initWithFrame:CGRectMake(15, NavigationAndStatue_Height-32, 60, 20)];
            _backButton.titleLabel.font = XKMediumFont(17);
        }
        [_backButton setImage:backImg forState:UIControlStateNormal];
        [_backButton setTitle:@"       " forState:UIControlStateNormal];
    } else{
        [_backButton setImage:backImg forState:UIControlStateNormal];
        [_backButton setTitle:string forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (_navStyle == BaseNavWhiteStyle) {
            [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    [_backButton addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView addSubview:_backButton];
}

//必须_backButton存在时调用
- (void)changeBackButton:(UIImage *)image frame:(CGRect)frame {
    
    [_backButton setImage:image forState:UIControlStateNormal];
    _backButton.frame = CGRectMake(15, NavigationAndStatue_Height-32, frame.size.width, frame.size.height);
}

- (void)setMidBtnWithImage:(UIImage *)image
{
    UIImage *backImg;
    if (image == nil) {
        backImg = [UIImage imageNamed:@"navigation_xiaohua"];
    } else {
        backImg = image;
    }
    
    UIImageView *myImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, 70, 20)];
    [myImageView setImage:[UIImage imageNamed:@"navigation_xiaohua"]];
    [_navigationView addSubview:myImageView];
    [myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.navigationView.mas_centerX);
        make.bottom.mas_equalTo(self.navigationView.mas_bottom).offset(-15);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
}


//设置导航栏右边view
- (void)setRightView:(UIView *)view withframe:(CGRect)rect{
    if (view == nil) {
        [_rightView removeFromSuperview];
        return;
    }
    if (view != _rightView) {
        [_rightView removeFromSuperview];
    }
    [self setGlobalFont:view];
    _rightView = view;
    [_navigationView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.navigationView.mas_right).offset(-20);
        make.centerY.mas_equalTo(self.navigationView.mas_bottom).offset(-22);
        make.size.mas_equalTo(rect.size);
    }];
}

- (void)setGlobalFont:(UIView *)view {
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)view;
        btn.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:btn.titleLabel.font.pointSize];
    }
}

//设置导航栏customview
- (void)setNaviCustomView:(UIView *)view withframe:(CGRect)rect{
    //    if (view == nil) {
    //        [_customView removeFromSuperview];
    //        return;
    //    }
    //    if (view != _customView) {
    //        [_customView removeFromSuperview];
    //    }
    //    _customView = view;
    [_navigationView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self->_backButton) {
            make.centerY.equalTo(self->_backButton);
            make.left.equalTo(self.navigationView.mas_left).offset(rect.origin.x);
            make.width.equalTo(@(rect.size.width));
            make.height.equalTo(@(rect.size.height));
        }
    }];
}

//设置导航栏中间view
- (void)setMiddleView:(UIView *)view withframe:(CGRect)rect{
    if (view == nil) {
        [_middleView removeFromSuperview];
        return;
    }
    if (view != _middleView) {
        [_middleView removeFromSuperview];
    }
    _middleView = view;
    [_navigationView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.navigationView);
        make.bottom.mas_equalTo(self.navigationView.mas_bottom).offset(-8);
        make.size.mas_equalTo(rect.size);
    }];
}

//设置导航栏左边view
- (void)setLeftView:(UIView *)view withframe:(CGRect)rect{
    if (view == nil) {
        [_leftView removeFromSuperview];
        return;
    }
    if (view != _leftView) {
        [_leftView removeFromSuperview];
    }
    _leftView = view;
    [_navigationView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.navigationView.mas_left).offset(10);
        make.centerY.mas_equalTo(self.navigationView.mas_bottom).offset(-22);
        make.size.mas_equalTo(rect.size);
    }];
}


//返回按钮  如需其他操作  重写即可
- (void)backBtnClick
{
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        //present方式
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)handleData {
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
}

- (void)addCustomSubviews {
    
}



- (void)resetMJHeaderFooter:(RefreshDataStatus)refreshStatus tableView:(UIScrollView *)tableView dataArray:(NSArray *)dataArry {
    switch (refreshStatus) {
            case Refresh_HasDataAndHasMoreData: { // 当前有数据 && 还有更多数据 显示footer
                [tableView.mj_header endRefreshing];
                [tableView.mj_footer endRefreshing];
                tableView.mj_footer.hidden = dataArry.count == 0;
            }
            break;
            case Refresh_NoDataOrHasNoMoreData: { // 当前无数据 || 没有更多数据 显示无数据footer  一条数据没有隐藏footer
                [tableView.mj_header endRefreshing];
                [tableView.mj_footer endRefreshingWithNoMoreData];
                tableView.mj_footer.hidden = dataArry.count == 0;
            }
            break;
            case Refresh_NoNet: { // 网络错误情况  单纯停止刷新
                [tableView.mj_header endRefreshing];
                [tableView.mj_footer endRefreshing];
                tableView.mj_footer.hidden = dataArry.count == 0;
            }
            break;
        default:
            break;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // [self setNavStyle];
}

- (void)setNavStyle {
    if (self.navStyle == BaseNavWhiteStyle) { // 把导航栏变白色
        
        UIColor *blackColor = RGBGRAY(51);
        NSArray *views = @[_rightView?:@"",_titleLabel?:@"",_customView?:@"",_rightView?:@"",_leftView?:@"",_middleView?:@""];
        self.navigationView.backgroundColor = [UIColor whiteColor];
        _lineView.backgroundColor = HEX_RGB(0xE2E2E2);
        [_backButton setImage:IMG_NAME(@"xk_ic_login_back") forState:UIControlStateNormal];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        for (NSObject *view in views) {
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)view;
                label.textColor = blackColor;
            } else if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)view;
                btn.tintColor = blackColor;
                [btn setTitleColor:blackColor forState:UIControlStateNormal];
            }
        }
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

/**
 第一次push进来的时候两个方法都会调用，parent的值不为空。当开始使用系统侧滑的时候，会先调用willMove，而parent的值为空；当滑动结束后返回了上个页面，则会调用didMove，parent的值也为空，如果滑动结束没有返回上个页面，也就是轻轻划了一下还在当前页面，那么则不会调用didMove方法。
 所以如果想要在侧滑返回后在上个页面做一些操作的话，可以在didMove方法中根据parent的值来判断。
 */
- (void)willMoveToParentViewController:(UIViewController*)parent{
    [super willMoveToParentViewController:parent];
    if(!parent){
        NSLog(@"页面willpop成功了");
        [self willPopToPreviousController];
    }
}
- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    if(!parent){
        NSLog(@"页面pop成功了");
        [self didPopToPreviousController];
    }
}

- (void)willPopToPreviousController {
    
}

- (void)didPopToPreviousController {
    
}

- (UILabel *)getTitleLab {
    [self setNavTitle:@"" WithColor:[UIColor whiteColor]];
    return _titleLabel;
}

@end
