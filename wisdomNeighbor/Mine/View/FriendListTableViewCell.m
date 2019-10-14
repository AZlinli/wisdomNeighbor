//
//  FriendListTableViewCell.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/30.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "FriendListTableViewCell.h"

@implementation FriendListTableViewCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
       
        // 初始化界面
        [self createUI];
       
    }
    return self;
}

#pragma mark - 初始化界面
- (void)createUI {
    [self.contentView addSubview:self.headerImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.centerY.equalTo(self.contentView);
        make.height.width.mas_equalTo(40);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImgView.mas_right).offset(20);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-20);
    }];

}


- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [UIImageView new];
        [_headerImgView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:kDefaultHeadImg];
    }
    return _headerImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = XKRegularFont(14);
        _nameLabel.textColor = HEX_RGB(0x000000);
    }
    return _nameLabel;
}
@end
