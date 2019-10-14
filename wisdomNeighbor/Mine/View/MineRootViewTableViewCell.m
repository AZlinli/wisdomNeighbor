//
//  MineRootViewTableViewCell.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/13.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "MineRootViewTableViewCell.h"

@implementation MineRootViewTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    self.myContentView = [[UIView alloc]init];
    [self.contentView addSubview:self.myContentView];
    
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.myContentView.backgroundColor = [UIColor whiteColor];
    [self.myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    UIImageView *titleImageView = [UIImageView new];
    [self.myContentView addSubview:titleImageView];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(self.myContentView);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(21);
    }];
    
    
    UILabel *label = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14] textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
    [self.myContentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleImageView.mas_right).offset(17);
        make.centerY.equalTo(self.myContentView);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
    }];
    
    
    UILabel *numlabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:15] textColor:UIColorFromRGB(0xffffff) backgroundColor:HEX_RGB(0xFA5251)];
    numlabel.xk_radius = 10;
    numlabel.xk_openClip = YES;
    numlabel.textAlignment = NSTextAlignmentCenter;
    numlabel.xk_clipType =  XKCornerClipTypeAllCorners;
    [self.myContentView addSubview:numlabel];
    [numlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(-15);
        make.centerY.equalTo(self.myContentView);
        make.height.width.mas_equalTo(21);
    }];
    
    UILabel *rightLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14] textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor whiteColor]];
    rightLabel.adjustsFontSizeToFitWidth = YES;
    rightLabel.textAlignment = NSTextAlignmentRight;
    [self.myContentView addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-33);
        make.centerY.equalTo(self.myContentView);
        make.height.mas_equalTo(20);
        make.left.equalTo(label.mas_right).offset(10);
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
    
    self.smallLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10] textColor:XKMainTypeColor backgroundColor:[UIColor whiteColor]];;
    [self.myContentView addSubview:_smallLabel];
    [self.smallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(8);
        make.centerY.equalTo(rightLabel);
    }];
    self.titleLabel = label;
    self.rightTitlelabel = rightLabel;
    self.nextImageView = nextImage;
    self.titleImageView = titleImageView;
    self.numLabel = numlabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.myContentView xk_forceClip];
}
@end
