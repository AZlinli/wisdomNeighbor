//
//  SweepQRCodeDetailViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/12.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "SweepQRCodeDetailViewController.h"
#import "MineResidentManagementViewController.h"

@interface SweepQRCodeDetailViewController ()
/**上面的详情View*/
@property(nonatomic, strong) UIView *headerView;

/**上面的详情label*/
@property(nonatomic, strong) UILabel *headerLabel;

/***/
@property(nonatomic, strong) UIImageView *contentView;

/***/
@property(nonatomic, strong) UILabel *contentTitleLabel;

/***/
@property(nonatomic, strong) UILabel *contentNumLabel;

/**临时码*/
@property(nonatomic, copy) NSString *codeString;

/**复制按钮*/
@property(nonatomic, strong) UIButton *copyButton;

@property (nonatomic, strong)UIView      *myContentView;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UIImageView *nextImageView;

@property (nonatomic, strong)UIImageView *titleImageView;

@end

@implementation SweepQRCodeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:HEX_RGB(0xf6f6f6)];
    [self setNavTitle:@"临时门禁码" WithColor:HEX_RGB(0x222222)];
    [self configUI];
    [self loadQrCode];
}
- (void)loadQrCode {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"getTempErcode";
    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;

    [HTTPClient postRequestWithURLString:@"project_war_exploded/ercodeServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        NSString *codeStr = responseObject[@"data"][@"ercode"];
        self.codeString = codeStr;
        NSMutableAttributedString *string =[[NSMutableAttributedString alloc]initWithString:codeStr];
        //设置字间距
        long number = 10;
           CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [string addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[string length])];
           CFRelease(num);
        [string addAttribute:(id)kCTForegroundColorAttributeName value:(id)([UIColor whiteColor].CGColor) range:NSMakeRange(0,[string length])];
        self.contentNumLabel.attributedText = string;
    } failure:^(XKHttpErrror *error) {
        
    }];
}


- (void)creatView {
    self.myContentView = [[UIView alloc]init];
    [self.view addSubview:self.myContentView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToVc:)];
    [_myContentView addGestureRecognizer:tap];
    self.myContentView.backgroundColor = [UIColor whiteColor];
    [self.myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-60);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    
    UIImageView *titleImageView = [UIImageView new];
    titleImageView.image = [UIImage imageNamed:@"meset_manageuser"];
    [self.myContentView addSubview:titleImageView];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(self.myContentView);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(21);
    }];
    
    UILabel *label = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"住户管理" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14] textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
    [self.myContentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleImageView.mas_right).offset(17);
        make.centerY.equalTo(self.myContentView);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
    }];
    
    UIImageView *nextImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xk_btn_personal_nextBlack"]];
    [self.myContentView addSubview:nextImage];
    [nextImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.myContentView.mas_centerY);
        make.right.mas_equalTo(self.myContentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(8.8, 10));
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = XKSeparatorLineColor;
    [self.myContentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.myContentView);
        make.height.equalTo(@1);
    }];
    self.titleLabel = label;
    self.nextImageView = nextImage;
    self.titleImageView = titleImageView;
}


- (void)configUI {
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.headerLabel];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.contentTitleLabel];
    [self.contentView addSubview:self.contentNumLabel];
    [self.view addSubview:self.copyButton];
    if ([[LoginModel currentUser].currentUserType isEqualToString:@"1"] || [[LoginModel currentUser].currentUserType isEqualToString:@"2"]) {
        [self creatView];
    }
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.height.mas_equalTo(120);
    }];
    
    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.bottom.mas_equalTo(0);
    }];
    [self.contentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom).offset(20);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.contentTitleLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(120);
    }];
    
   
    [self.contentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(120);
    }];
    
    [self.copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.contentView.mas_bottom).offset(30);
        make.height.mas_equalTo(30);
    }];
}

- (UIButton *)copyButton {
    if (!_copyButton) {
        _copyButton = [UIButton new];
        _copyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_copyButton setTitle:@"复制地址和临时码" forState:0];
        [_copyButton setTitleColor:HEX_RGB(0x000000) forState:0];
        [_copyButton addTarget:self action:@selector(copyAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _copyButton;
}
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.backgroundColor = HEX_RGB(0xffffff);
    }
    return _headerView;
}

- (UILabel *)headerLabel {
    if (!_headerLabel) {
        _headerLabel = [UILabel new];
        _headerLabel.numberOfLines = 0;
        [_headerLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(@"为了您和大家的安全，临时码1小时内，只可进出小区各一次，之后将自动作废。请妥善管理，避免泄露给您造成不必要的麻烦。").textColor(HEX_RGB(0x222222)).font(XKRegularFont(16));
        }];
    }
    return _headerLabel;
}

- (UIImageView *)contentView {
    if (!_contentView) {
        _contentView = [UIImageView new];
        _contentView.image = [UIImage imageNamed:@"temp_ercodeback"];
        _contentView.xk_radius = 8;
        _contentView.xk_clipType = XKCornerClipTypeAllCorners;
        _contentView.xk_openClip = YES;
    }
    return _contentView;
}

- (UILabel *)contentTitleLabel {
    if (!_contentTitleLabel) {
        _contentTitleLabel = [UILabel new];
        _contentTitleLabel.textColor = HEX_RGB(0x222222);
        _contentTitleLabel.textAlignment = NSTextAlignmentCenter;
        _contentTitleLabel.text = [NSString stringWithFormat:@"%@ %@",[LoginModel currentUser].currentHouseName,[LoginModel currentUser].currentInestateslocation];
        _contentTitleLabel.backgroundColor = [UIColor clearColor];
        _contentTitleLabel.font = XKRegularFont(16);
    }
    return _contentTitleLabel;
}

- (UILabel *)contentNumLabel {
    if (!_contentNumLabel) {
        _contentNumLabel = [UILabel new];
        _contentNumLabel.font = XKMediumFont(40);
        _contentNumLabel.textColor = HEX_RGB(0xffffff);
        _contentNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentNumLabel;
}

- (void)copyAction:(UIButton *)sender {
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@%@",[LoginModel currentUser].currentHouseName,self.codeString];
    [XKHudView showSuccessMessage:@"已复制，快去分享吧~"];
}

- (void)tapToVc:(UIGestureRecognizer *)sender {
    MineResidentManagementViewController *vc = [MineResidentManagementViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
