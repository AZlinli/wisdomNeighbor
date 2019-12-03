//
//  SweepQRCodeRootViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/11.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "SweepQRCodeRootViewController.h"
#import "SweepQRCodeDetailViewController.h"
#import "SDCycleScrollView.h"
#import "BannerModel.h"
#import "XKJumpWebViewController.h"


@interface SweepQRCodeRootViewController ()<SDCycleScrollViewDelegate>
/**头部视图*/
@property(nonatomic, strong) SDCycleScrollView *headerImageView;
/**二维码视图*/
@property(nonatomic, strong) UIView *qrcodeView;
/**生成门禁视图*/
@property(nonatomic, strong) UIImageView *creatCodeView;
/**生成门禁视图de头像和名字*/
@property(nonatomic, strong) UILabel *creatCodeTitleLabel;
/**生成门禁视图de箭头*/
@property(nonatomic, strong) UIImageView *creatCodeRightImageView;
/**滚动视图*/
@property(nonatomic, strong) UIScrollView *contentScrollView;
/**二维码*/
@property (nonatomic, strong) XKQRCodeView *codeView;
/**标题*/
@property(nonatomic, strong) UILabel *titleLabel;
/**门禁码*/
@property(nonatomic, strong) UILabel *codeLabel;
/**重新生成二维码*/
@property(nonatomic, strong) UIButton *changeCodeButton;
/**banner数组*/
@property(nonatomic, strong) NSArray *bannerArray;

@end

@implementation SweepQRCodeRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    self.view.backgroundColor = HEX_RGB(0xffffff);
    [self setNavTitle:[NSString stringWithFormat:@"%@小区",[LoginModel currentUser].currentHouseName] WithColor:HEX_RGB(0x222222)];
    [self hiddenBackButton:YES];
    [self hideNavigation];
    [self configUI];
    [self addGestureRecognizer];
    [self loadQrCode];
    [self loadBanner];
}

- (void)addGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.creatCodeView addGestureRecognizer:tap];
}

- (void)tap:(UIGestureRecognizer *)sender {
    SweepQRCodeDetailViewController *vc = [SweepQRCodeDetailViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadQrCode {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"getTempErcode";
    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;

    [HTTPClient postRequestWithURLString:@"project_war_exploded/ercodeServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        NSString *codeStr = responseObject[@"data"][@"ercode"];
        self.codeLabel.text = [NSString stringWithFormat:@"门禁码:%@",codeStr];
        [self.codeView createQRImageWithQRString:codeStr correctionLevel:@"L"];
    } failure:^(XKHttpErrror *error) {
        
    }];
}

- (void)loadBanner {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"getBanner";
    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;
    parameters[@"estates"] = [LoginModel currentUser].currentHouseId;
    [HTTPClient postRequestWithURLString:@"project_war_exploded/bannerServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        BannerModel *model = [BannerModel yy_modelWithJSON:responseObject];
        NSArray *modelArray = model.data;
        self.bannerArray = modelArray;
        NSMutableArray *picArray = [NSMutableArray array];
        for ( BannerModelData *model in modelArray) {
            [picArray addObject:model.image];
        }
        self.headerImageView.imageURLStringsGroup = picArray.copy;

    } failure:^(XKHttpErrror *error) {
        
    }];
}

- (void)configUI {
    [self.view addSubview:self.headerImageView];
    [self.view addSubview:self.qrcodeView];
    [self.view addSubview:self.creatCodeView];
    [self.qrcodeView addSubview:self.titleLabel];
    [self.qrcodeView addSubview:self.codeLabel];
    [self.qrcodeView addSubview:self.changeCodeButton];
    [self.creatCodeView addSubview:self.creatCodeTitleLabel];
    [self.creatCodeView addSubview:self.creatCodeRightImageView];

    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(160 * ScreenScale);
    }];
    
    [self.qrcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(20);
        make.height.mas_equalTo(SCREEN_WIDTH-(60 * ScreenScale));
    }];
    
    self.codeView = [[XKQRCodeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - (60 * ScreenScale), SCREEN_WIDTH - (60 * ScreenScale))];
    [self.qrcodeView addSubview:self.codeView];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.qrcodeView);
        make.width.height.mas_equalTo(SCREEN_WIDTH-40-160);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.qrcodeView);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.codeView.mas_top).offset(-40);
    }];
    
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.qrcodeView);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(self.changeCodeButton.mas_top).offset(-10);
    }];
    
    [self.changeCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.qrcodeView);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
        make.top.equalTo(self.codeView.mas_bottom).offset(30);
    }];
    
    [self.creatCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.qrcodeView.mas_bottom).offset(20);
        make.height.mas_equalTo(80 * ScreenScale);
    }];
    
    [self.creatCodeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self.creatCodeView);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(30);
    }];
    
    [self.creatCodeRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self.creatCodeView);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
}
- (NSArray *)bannerArray {
    if (!_bannerArray) {
        _bannerArray = [NSArray array];
    }
    return _bannerArray;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 40);
    }
    return _contentScrollView;
}

- (SDCycleScrollView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[SDCycleScrollView alloc]initWithFrame:CGRectZero];
        _headerImageView.delegate = self;
        _headerImageView.showPageControl = YES;
        _headerImageView.autoScrollTimeInterval = 5.0;
        _headerImageView.backgroundColor = [UIColor whiteColor];
    }
    return _headerImageView;
}

- (UIView *)qrcodeView {
    if (!_qrcodeView) {
        _qrcodeView = [[UIView alloc]init];
        _qrcodeView.backgroundColor = [UIColor whiteColor];
        _qrcodeView.xk_radius = 8;
        _qrcodeView.xk_openClip = YES;
        _qrcodeView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return _qrcodeView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = [NSString stringWithFormat:@"%@",[LoginModel currentUser].currentHouseName];
        _titleLabel.textColor = HEX_RGB(0x222222);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = [UILabel new];
        _codeLabel.font = [UIFont systemFontOfSize:14];
        _codeLabel.text = [NSString stringWithFormat:@"门禁码:"];
        _codeLabel.textColor = HEX_RGB(0x222222);
        _codeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _codeLabel;
}

-(UIButton *)changeCodeButton {
    if (!_changeCodeButton) {
        _changeCodeButton = [UIButton new];
        [_changeCodeButton setTitle:@"点此刷新二维码" forState:0];
        [_changeCodeButton setTitleColor:HEX_RGB(0x222222) forState:0];
        [_changeCodeButton addTarget:self action:@selector(changeCodeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _changeCodeButton.titleLabel.font = XKMediumFont(14);
    }
    return _changeCodeButton;
}

- (UIImageView *)creatCodeView {
    if (!_creatCodeView) {
        _creatCodeView = [[UIImageView alloc]init];
        _creatCodeView.image = [UIImage imageNamed:@"tempercodeback"];
        _creatCodeView.xk_radius = 8;
        _creatCodeView.xk_openClip = YES;
        _creatCodeView.xk_clipType = XKCornerClipTypeAllCorners;
        _creatCodeView.userInteractionEnabled = YES;
    }
    return _creatCodeView;
}


- (UILabel *)creatCodeTitleLabel {
    if (!_creatCodeTitleLabel) {
        _creatCodeTitleLabel = [UILabel new];
        _creatCodeTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_creatCodeTitleLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {            confer.text(@"生成临时门禁码").textColor(HEX_RGB(0xffffff)).font(XKRegularFont(14));
        }];
        
    }
    return _creatCodeTitleLabel;
}


- (UIImageView *)creatCodeRightImageView {
    if (!_creatCodeRightImageView) {
        _creatCodeRightImageView = [UIImageView new];
        _creatCodeRightImageView.image = [UIImage imageNamed:@"tempercode_right"];
    }
    return _creatCodeRightImageView;
}

- (void)changeCodeButtonAction:(UIButton *)sender {
    [self changeLoadQrCode];
}

- (void)changeLoadQrCode {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"refreshLocalUserErcode";
    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;

    [HTTPClient postRequestWithURLString:@"project_war_exploded/ercodeServlet" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        NSString *codeStr = responseObject[@"data"];
        self.codeLabel.text = [NSString stringWithFormat:@"门禁码:%@",codeStr];
        [self.codeView createQRImageWithQRString:codeStr correctionLevel:@"L"];
    } failure:^(XKHttpErrror *error) {
        
    }];
}



#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    BannerModelData *model = self.bannerArray[index];
    if (model.link) {
        XKJumpWebViewController *vc = [XKJumpWebViewController new];
        vc.url = model.link;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    
}
@end
