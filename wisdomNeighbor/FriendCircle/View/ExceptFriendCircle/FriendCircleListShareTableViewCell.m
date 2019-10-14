//
//  FriendCircleListShareTableViewCell.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/22.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "FriendCircleListShareTableViewCell.h"

@interface FriendCircleListShareTableViewCell()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *listImageView;


@end
@implementation FriendCircleListShareTableViewCell

- (void)setModel:(FriendTalkModel *)model {
    _model = model;
    self.titleLabel.text = model.content;
    self.addessLabel.text = model.locationaddress;
    NSString *day = [self getCurrentDayTimeString:model.createtime];
    NSString *month = [self getCurrentMonthTimeString:model.createtime];
    NSString *monthStr = [NSString stringWithFormat:@"%@月",month];
    [self.timeLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text(day).font(XKMediumFont(23)).textColor(HEX_RGB(0x000000));
        confer.text(monthStr).font(XKRegularFont(14)).textColor(HEX_RGB(0x000000));
    }];
}

- (void)initViews {
    [super initViews];
    self.myContentView.backgroundColor = HEX_RGB(0xf5f5f5);
    [self.myContentView addSubview:self.titleLabel];
    [self.myContentView addSubview:self.listImageView];
    [self.listImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.myContentView.mas_centerY);
        make.width.height.mas_equalTo(44);
        make.left.mas_equalTo(4);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.listImageView.mas_right).offset(10);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-10);
    }];
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = XKRegularFont(14);
        _titleLabel.textColor = HEX_RGB(0x010101);
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIImageView *)listImageView {
    if (!_listImageView) {
        _listImageView = [UIImageView new];
    }
    return _listImageView;
}
@end
