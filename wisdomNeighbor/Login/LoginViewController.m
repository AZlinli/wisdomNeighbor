//
//  LoginViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/14.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginHousingViewController.h"
#import "CYLTabBarController.h"
#import "BaseTabBarConfig.h"
#import "LoginModel.h"
#import "XKLoginUserContractView.h"
#import "XKJumpWebViewController.h"
#import "VerificationViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
/**contentView*/
@property(nonatomic, strong) UIView *contentView;
/**姓名的图片*/
@property(nonatomic, strong) UIImageView *nameImageView;
/**电话的图片*/
@property(nonatomic, strong) UIImageView *phoneImageView;
/**验证码的图片*/
@property(nonatomic, strong) UIImageView *codeImageView;

/**名字*/
@property(nonatomic, strong) UITextField *nameTextField;
/**电话*/
@property(nonatomic, strong) UITextField *phoneTextField;
/**验证码*/
@property(nonatomic, strong) UITextField *codeTextField;

/**背景图片*/
@property(nonatomic, strong) UIImageView  *bgImageView;

/**<##>*/
@property(nonatomic, strong) LoginViewController *LoginVC;

@property(nonatomic, strong) UIView *line1;
@property(nonatomic, strong) UIView *line2;
@property(nonatomic, strong) UIView *line3;
@property(nonatomic, strong) UIView *line4;


/**登录的标题*/
@property(nonatomic, strong) UILabel *titleLabel;

/**登录的图标*/
@property(nonatomic, strong) UIImageView *titleImageView;

/**描述的字*/
@property(nonatomic, strong) UILabel *desLabel;

/**发送验证码按钮*/
@property(nonatomic, strong) UIButton *sendCodeBuutton;
/**登录按钮*/
@property(nonatomic, strong) UIButton *longinButton;
/**游客模式登录按钮*/
@property(nonatomic, strong) UIButton *otherLonginButton;
/**协议界面*/
@property(nonatomic, strong) XKLoginUserContractView *contractView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenBackButton:YES];
    [self hideNavigation];
    
    if (self.vcType == loginVCTyoeLogin) {
        [self setNavTitle:@"账号登录" WithColor:HEX_RGB(0x222222)];
        [self configsendButton];
    }else{
        [self setNavTitle:@"游客登录" WithColor:HEX_RGB(0x222222)];
    }
    
    if (self.phone) {
        self.phoneTextField.text = self.phone;
    }
    [self loadUI];
}

- (void)sendButtonAction:(UIButton *)sender {
    [self loadMseCodeData];
}

- (void)loginButtonAction:(UIButton *)sender {
    if (self.vcType == loginVCTyoeLogin) {
        [self loginNetwork:YES];
    }else{
        [self loginNetwork:NO];
    }
}

- (void)otherLoginButtonAction:(UIButton *)sender {
    self.LoginVC = [LoginViewController new];
    if (self.vcType == loginVCTyoeLogin) {
        self.LoginVC.vcType = loginVCTyoeTourist;
    }else{
        self.LoginVC.vcType = loginVCTyoeLogin;
    }
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.LoginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)loadMseCodeData {
    NSString *phone;
    if (self.vcType == loginVCTyoeLogin) {
        phone = self.phoneTextField.text;
    }else{
        phone = self.nameTextField.text;
    }
    if ([self checkMobile:phone]) {
        [XKHudView showLoadingTo:self.view animated:YES];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"phone"] = phone;
        parameters[@"type"] = @"getsmscode";
        [HTTPClient postRequestWithURLString:@"project_war_exploded/smsServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
            [XKHudView hideHUDForView:self.view  animated:YES];
            [self countdown];
            [XKHudView showSuccessMessage:@"发送成功"];
        } failure:^(XKHttpErrror *error) {
            [XKHudView hideHUDForView:self.view  animated:YES];
            [XKAlertView showCommonAlertViewWithTitle:error.message rightText:@"立即验证" rightBlock:^{
                VerificationViewController *vc = [[VerificationViewController alloc]initWithNibName:@"VerificationViewController" bundle:nil];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];;
            }];
        }];
    }else{
        [XKHudView showErrorMessage:@"请输入正确的手机号"];
    }
}
   
- (void)loginNetwork:(BOOL)isNomal {
    NSString *phone;
    if (isNomal) {
        phone = self.phoneTextField.text;
    }else{
        phone = self.nameTextField.text;
    }
    if (![self checkMobile:phone]) {
        [XKHudView showErrorMessage:@"请输入正确的手机号"];
        return;
    }
    
    if (!self.contractView.isAgreeContract) {
        [XKHudView showErrorMessage:@"请先同意用户协议！"];
        return;
    }
    
    if (self.codeTextField.text.length == 0) {
        [XKHudView showErrorMessage:@"验证码不能为空"];
        return;
    }
    NSString *url = @"project_war_exploded/userServlet";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"phone"] = self.phoneTextField.text;
    if (isNomal) {
        parameters[@"type"] = @"loginUseSmsCode";
    }else{
        parameters[@"type"] = @"loginUseSmsCodeVisitor";
    }
    parameters[@"smsCode"] = self.codeTextField.text;

    [HTTPClient postRequestWithURLString:url timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        LoginModel *model = [LoginModel yy_modelWithJSON:responseObject];
        [self dealRegisterModel:model];
        [XKLoginConfig loginConfig];
        LoginHousingViewController *vc = [LoginHousingViewController new];
        vc.showBack = NO;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [UIApplication sharedApplication].delegate.window.rootViewController = nav;
    } failure:^(XKHttpErrror *error) {
        [XKHudView showErrorMessage:error.message];
    }];
}

#pragma mark - 处理登录后的信息
- (void)dealRegisterModel:(LoginModel *)model {
    [LoginModel saveCurrentUser:model];
}

- (void)countdown {
    XKWeakSelf(ws);
    [[CountdownManager defaultManager]scheduledCountDownWithKey:@"login" timeInterval:60.0 countingDown:^(NSTimeInterval leftTimeInterval) {
        NSString *timeStr = [NSString stringWithFormat:@"%.f秒后重发", leftTimeInterval];
        dispatch_async(dispatch_get_main_queue(), ^{
            ws.sendCodeBuutton.enabled = NO;
            [ws.sendCodeBuutton setTitle:timeStr forState:UIControlStateNormal];
        });
    } finished:^(NSTimeInterval finalTimeInterval) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ws.sendCodeBuutton.enabled = YES;
            [ws.sendCodeBuutton setTitle:@"获取验证码" forState:UIControlStateNormal];
        });
    }];
}

- (void)configsendButton {
    XKWeakSelf(ws);
    [[CountdownManager defaultManager]getCountDownWithKey:@"login" countingDown:^(NSTimeInterval leftTimeInterval) {
        NSString *timeStr = [NSString stringWithFormat:@"%.f秒后重发", leftTimeInterval];
        dispatch_async(dispatch_get_main_queue(), ^{
            ws.sendCodeBuutton.enabled = NO;
            [ws.sendCodeBuutton setTitle:timeStr forState:UIControlStateNormal];
        });
    } finished:^(NSTimeInterval finalTimeInterval) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ws.sendCodeBuutton.enabled = YES;
            [ws.sendCodeBuutton setTitle:@"获取验证码" forState:UIControlStateNormal];
        });
    }];
}
- (void)loadUI {
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.titleImageView];
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.nameImageView];
    [self.contentView addSubview:self.phoneImageView];
    [self.contentView addSubview:self.codeImageView];
    [self.contentView addSubview:self.sendCodeBuutton];
    [self.contentView addSubview:self.nameTextField];
    [self.contentView addSubview:self.phoneTextField];
    [self.contentView addSubview:self.codeTextField];
    [self.contentView addSubview:self.line1];
    [self.contentView addSubview:self.line2];
    [self.contentView addSubview:self.line3];
    [self.contentView addSubview:self.line4];
    [self.contentView addSubview:self.longinButton];
    [self.contentView addSubview:self.otherLonginButton];
    [self.contentView addSubview:self.desLabel];
    [self.contentView addSubview:self.contractView];

    [self layout];
}
- (void)layout {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(240);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.bgImageView.mas_bottom).offset(30);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(30);
    }];
    
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.bgImageView.mas_bottom).offset(30);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(60);
    }];
    
    [self.nameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleImageView.mas_bottom).offset(40);
        make.left.mas_equalTo(30);
        make.height.width.mas_equalTo(20);
    }];
    
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameImageView.mas_right).offset(25);
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(self.nameImageView);
        make.height.mas_equalTo(30);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameImageView.mas_left);
        make.right.mas_equalTo(-15);
        make.bottom.equalTo(self.nameImageView.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    [self.otherLonginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.mas_equalTo(-30);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    
    if (self.vcType == loginVCTyoeLogin) {
        [self layoutNomal];
    }else{
        [self layoutTourist];
    }
}

- (void)layoutNomal {
    [self.phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleImageView.mas_bottom).offset(40);
        make.left.mas_equalTo(30);
        make.height.width.mas_equalTo(20);
    }];
    
    [self.codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneImageView.mas_bottom).offset(40);
        make.left.mas_equalTo(30);
        make.height.width.mas_equalTo(20);
    }];
    
    [self.sendCodeBuutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.codeImageView);
        make.right.mas_equalTo(-35);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.right.equalTo(self.sendCodeBuutton.mas_left).offset(-10);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self.sendCodeBuutton);
    }];
    
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneImageView.mas_right).offset(25);
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(self.phoneImageView);
        make.height.mas_equalTo(30);
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeImageView.mas_right).offset(25);
        make.right.equalTo(self.line4.mas_left).offset(-10);
        make.centerY.equalTo(self.codeImageView);
        make.height.mas_equalTo(30);
    }];
    
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneImageView.mas_left);
        make.right.mas_equalTo(-15);
        make.bottom.equalTo(self.phoneImageView.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeImageView.mas_left);
        make.right.mas_equalTo(-15);
        make.bottom.equalTo(self.codeImageView.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    [self.longinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(self.line3.mas_bottom).offset(30);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(44);
    }];
    
    [self.contractView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.longinButton.mas_bottom).offset(20);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(20);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.bottom.equalTo(self.otherLonginButton.mas_top).offset(-20);
        make.top.equalTo(self.longinButton.mas_bottom).offset(10);
    }];
    
}

- (void)layoutTourist {
    
    [self.codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameImageView.mas_bottom).offset(40);
        make.left.mas_equalTo(30);
        make.height.width.mas_equalTo(20);
    }];
    
    [self.sendCodeBuutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.codeImageView);
        make.right.mas_equalTo(-35);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.right.equalTo(self.sendCodeBuutton.mas_left).offset(-10);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self.sendCodeBuutton);
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeImageView.mas_right).offset(25);
        make.right.equalTo(self.line4.mas_left).offset(-10);
        make.centerY.equalTo(self.codeImageView);
        make.height.mas_equalTo(30);
    }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeImageView.mas_left);
        make.right.mas_equalTo(-15);
        make.bottom.equalTo(self.codeImageView.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    [self.phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeImageView.mas_bottom).offset(40);
        make.left.mas_equalTo(30);
        make.height.width.mas_equalTo(20);
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneImageView.mas_right).offset(25);
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(self.phoneImageView);
        make.height.mas_equalTo(30);
    }];
   
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneImageView.mas_left);
        make.right.mas_equalTo(-15);
        make.bottom.equalTo(self.phoneImageView.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
  
    [self.longinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(self.line2.mas_bottom).offset(10);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(44);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.bottom.equalTo(self.otherLonginButton.mas_top).offset(-20);
        make.top.equalTo(self.longinButton.mas_bottom).offset(10);
    }];
}

- (XKLoginUserContractView *)contractView {
    if (!_contractView) {
        XKWeakSelf(ws);
        _contractView = [[XKLoginUserContractView alloc]initWithContractTitle:@"智邻用户协议"];
        _contractView.contractBlock = ^{
            [ws contractAction];
        };
    }
    return _contractView;
}

- (void)contractAction {
    NSString *h5String = @"http://139.155.41.184:8090/system/loginProvision";
    XKJumpWebViewController *vc = [[XKJumpWebViewController alloc] init];
    vc.url = h5String;
    vc.title = @"智邻用户协议";
    [self presentViewController:vc animated:YES completion:nil];
}


- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView  = [UIImageView new];
        [GlobleCommonTool configTimeHourWith:_bgImageView];
    }
    return _bgImageView;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = HEX_RGB(0xffffff);
    }
    return _contentView;
}

- (UIImageView *)titleImageView {
    if (!_titleImageView) {
        _titleImageView = [UIImageView new];
        _titleImageView.image = [UIImage imageNamed:@"home_appname_light"];
        _titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _titleImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.hidden = YES;
        if (self.vcType == loginVCTyoeLogin) {
            _titleLabel.text = @"账号登录";
        }else{
            _titleLabel.text = @"游客登录模式";
        }
        _titleLabel.textColor = HEX_RGB(0x222222);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = XKMediumFont(20);
    }
    return _titleLabel;
}
- (UIImageView *)nameImageView {
    if (!_nameImageView) {
        _nameImageView = [UIImageView new];
        _nameImageView.hidden = YES;
        _nameImageView.contentMode = UIViewContentModeScaleAspectFill;
        _nameImageView.image = [UIImage imageNamed:@"mine_set_1"];
    }
    return _nameImageView;
}

- (UIImageView *)phoneImageView {
    if (!_phoneImageView) {
        _phoneImageView = [UIImageView new];
        _phoneImageView.contentMode = UIViewContentModeScaleAspectFill;
        if (self.vcType == loginVCTyoeLogin) {
            _phoneImageView.image = [UIImage imageNamed:@"mine_set_2"];
        }else{
            _phoneImageView.image = [UIImage imageNamed:@"mine_set_4"];
        }
    }
    return _phoneImageView;
}

- (UIImageView *)codeImageView {
    if (!_codeImageView) {
        _codeImageView = [UIImageView new];
        _codeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _codeImageView.image = [UIImage imageNamed:@"mine_set_3"];
    }
    return _codeImageView;
}

- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [UITextField new];
        _nameTextField.textColor = HEX_RGB(0x999999);
        if (self.vcType == loginVCTyoeLogin) {
            _nameTextField.placeholder = @"请输入姓名";
        }else{
            _nameTextField.placeholder = @"请输入手机号";
        }
        _nameTextField.hidden = YES;
        _nameTextField.font = XKRegularFont(14);
    }
    return _nameTextField;
}

- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [UITextField new];
        _phoneTextField.textColor = HEX_RGB(0x999999);
        if (self.vcType == loginVCTyoeLogin) {
            _phoneTextField.placeholder = @"请输入物业登记手机号码";
        }else{
            _phoneTextField.placeholder = @"设置昵称";
        }
        _phoneTextField.returnKeyType = UIReturnKeyDone;
        _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        _phoneTextField.font = XKRegularFont(14);

    }
    return _phoneTextField;
}

- (UITextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [UITextField new];
        _codeTextField.textColor = HEX_RGB(0x999999);
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.delegate = self;
        _codeTextField.returnKeyType = UIReturnKeyDone;
        _codeTextField.keyboardType = UIKeyboardTypePhonePad;
        _codeTextField.font = XKRegularFont(14);
    }
    return _codeTextField;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [UIView new];
        _line1.hidden = YES;
        _line1.backgroundColor = XKSeparatorLineColor;
    }
    return _line1;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [UIView new];
        _line2.backgroundColor = XKSeparatorLineColor;
    }
    return _line2;
}

- (UIView *)line3 {
    if (!_line3) {
        _line3 = [UIView new];
        _line3.backgroundColor = XKSeparatorLineColor;
    }
    return _line3;
}

- (UIView *)line4 {
    if (!_line4) {
        _line4 = [UIView new];
        _line4.backgroundColor = XKSeparatorLineColor;
    }
    return _line4;
}

- (UIButton *)sendCodeBuutton {
    if (!_sendCodeBuutton) {
        _sendCodeBuutton = [[UIButton alloc]init];
        [_sendCodeBuutton setTitle:@"获取验证码" forState:0];
        _sendCodeBuutton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_sendCodeBuutton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sendCodeBuutton setTitleColor:XKMainTypeColor forState:0];
        [_sendCodeBuutton.titleLabel setFont:XKRegularFont(14)];
    }
    return _sendCodeBuutton;
}

- (UIButton *)longinButton {
    if (!_longinButton) {
        _longinButton = [[UIButton alloc]init];
        [_longinButton setTitle:@"登录" forState:0];
        [_longinButton setTitleColor:HEX_RGB(0xffffff) forState:0];
        [_longinButton setBackgroundColor:XKMainTypeColor];
        _longinButton.layer.masksToBounds = YES;
        _longinButton.layer.cornerRadius = 8;
        [_longinButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _longinButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_longinButton.titleLabel setFont:XKRegularFont(16)];

    }
    return _longinButton;
}

- (UIButton *)otherLonginButton {
    if (!_otherLonginButton) {
        _otherLonginButton = [[UIButton alloc]init];
        if (self.vcType == loginVCTyoeLogin) {
            [_otherLonginButton setTitle:@"游客登录模式" forState:0];
        }else{
            [_otherLonginButton setTitle:@"正常登录模式" forState:0];
        }
        _otherLonginButton.hidden = YES;
        [_otherLonginButton addTarget:self action:@selector(otherLoginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _otherLonginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _otherLonginButton.backgroundColor = HEX_RGB(0xffffff);
        [_otherLonginButton setTitleColor:HEX_RGB(0x55555) forState:0];
        [_otherLonginButton.titleLabel setFont:XKRegularFont(16)];
    }
    return _otherLonginButton;
}


- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [UILabel new];
        _desLabel.text = @"温馨提示：用户首次使用需要注册，注册信息必须与物业录入的个人信息保持一致。如有疑问，请咨询物业工作人员。";
        _desLabel.numberOfLines = 0;
        _desLabel.textColor = HEX_RGB(0x555555);
        _desLabel.font = XKRegularFont(13);
        if (self.vcType == loginVCTyoeLogin) {
            _desLabel.hidden = NO;
        }else{
            _desLabel.hidden = YES;
        }
        _desLabel.hidden = YES;
    }
    return _desLabel;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];//取消第一响应者
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
