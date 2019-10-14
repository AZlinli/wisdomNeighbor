//
//  NoticeListTableViewCell.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/27.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "NoticeListTableViewCell.h"

@interface NoticeListTableViewCell()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UIView  *myContentView;

@end
@implementation NoticeListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)setModel:(NoticeModelData *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.timeLabel.text = model.createtime;
}
- (void)initViews {
    [self.contentView addSubview:self.myContentView];
    [self.myContentView addSubview:self.timeLabel];
    [self.myContentView addSubview:self.titleLabel];
    [self.myContentView addSubview:self.contentLabel];
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
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(14);
        make.right.mas_equalTo(-10);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.right.mas_equalTo(-10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(-10);
    }];
}

- (UIView *)myContentView {
    if (!_myContentView) {
        _myContentView = [[UIView alloc]init];
        _myContentView.backgroundColor = [UIColor whiteColor];
    }
    return _myContentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = HEX_RGB(0x576C95);
        _titleLabel.font = XKRegularFont(14);
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = HEX_RGB(0x000000);
        _contentLabel.font = XKRegularFont(14);
    }
    return _contentLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = HEX_RGB(0x737373);
        _timeLabel.font = XKRegularFont(12);
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

@end
