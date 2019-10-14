//
//  PersonalDataPicTableViewCell.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/21.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "PersonalDataPicTableViewCell.h"

@interface PersonalDataPicTableViewCell()

@end
@implementation PersonalDataPicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    for (int i = 0; i < self.imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[i]] placeholderImage:kDefaultPlaceHolderImg];
        [self.imageContentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i * 52);
            make.width.height.mas_equalTo(48);
            make.centerY.equalTo(self.imageContentView.mas_centerY);
        }];
    }
}
- (void)initViews {
    [self.contentView addSubview:self.myContentView];
    [self.myContentView addSubview:self.titleLabel];
    [self.myContentView addSubview:self.nextImageView];
    [self.myContentView addSubview:self.imageContentView];

    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [_myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = XKSeparatorLineColor;
    [self.myContentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.myContentView);
        make.height.equalTo(@1);
    }];
    
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.myContentView.mas_centerY);
        make.right.mas_equalTo(self.myContentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(8.8, 10));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.centerY.equalTo(self.myContentView);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(60);
    }];
    
    [self.imageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(38);
        make.centerY.equalTo(self.myContentView);
        make.height.mas_equalTo(79);
        make.right.equalTo(self.nextImageView.mas_left).offset(-50);
    }];
    
    
}

- (UIView *)myContentView {
    if (!_myContentView) {
        _myContentView = [[UIView alloc]init];
        _myContentView.backgroundColor = [UIColor whiteColor];
    }
    return _myContentView;
}

- (UIView *)imageContentView {
    if (!_imageContentView) {
        _imageContentView = [[UIView alloc]init];
        _imageContentView.backgroundColor = [UIColor whiteColor];
    }
    return _imageContentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = HEX_RGB(0x000000);
        _titleLabel.font = XKRegularFont(17);
    }
    return _titleLabel;
}

- (UIImageView *)nextImageView {
    if (!_nextImageView) {
        _nextImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xk_btn_personal_nextBlack"]];
    }
    return _nextImageView;
}
@end
