//
//  MinePersonalHeaderTableViewCell.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/13.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "MinePersonalHeaderTableViewCell.h"

@implementation MinePersonalHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    self.contentView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    UIView *myContentView = [[UIView alloc]init];
    [self.contentView addSubview:myContentView];
    myContentView.backgroundColor = [UIColor whiteColor];
    [myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.bottom.equalTo(self.contentView);
    }];
    myContentView.xk_radius = 8;
    myContentView.xk_clipType = XKCornerClipTypeAllCorners;
    myContentView.xk_openClip = YES;
    UILabel *label = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"头像" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14] textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
    label.adjustsFontSizeToFitWidth = YES;
    [myContentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(14 * ScreenScale));
        make.centerY.equalTo(myContentView);
        make.height.equalTo(@(30 * ScreenScale));
        make.width.equalTo(@(100 * ScreenScale));
    }];
    
    UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xk_img_personal_big_header"]];
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.clipsToBounds = YES;
    [myContentView addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-34 * ScreenScale));
        make.centerY.equalTo(myContentView);
        make.height.equalTo(@(52));
        make.width.equalTo(@(52));
    }];
    
    self.headerImageView = imageview;
    UIImageView *nextImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xk_btn_personal_nextBlack"]];
    [myContentView addSubview:nextImage];
    self.headerImageView.xk_radius = 8;
    self.headerImageView.xk_clipType = XKCornerClipTypeAllCorners;
    self.headerImageView.xk_openClip = YES;
    [nextImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(myContentView.mas_centerY);
        make.right.mas_equalTo(myContentView.mas_right).offset(-15 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(8.8 * ScreenScale, 10 * ScreenScale));
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = XKSeparatorLineColor;
    [myContentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(myContentView);
        make.height.equalTo(@1);
    }];
}


@end
