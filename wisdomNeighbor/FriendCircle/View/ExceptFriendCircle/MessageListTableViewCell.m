//
//  MessageListTableViewCell.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/21.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "MessageListTableViewCell.h"

@interface MessageListTableViewCell()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UIView  *myContentView;
@property (nonatomic, strong)UIImageView    *headerImageView;
@property (nonatomic, strong)UIImageView    *contentImageView;

@end

@implementation MessageListTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}


- (void)setModel:(MessageListModelData *)model {
    _model = model;
    self.titleLabel.text = model.comments.nickname;
    if ([model.type isEqualToString:@"1"]) {
        self.contentLabel.text = [NSString stringWithFormat:@"%@点了赞",model.comments.nickname];
    }else{
        self.contentLabel.text = model.content;
    }
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.comments.icon] placeholderImage:kDefaultHeadImg];
    if (model.firstFriendsImg) {
          [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.firstFriendsImg] placeholderImage:kDefaultPlaceHolderImg];
        self.contentImageView.hidden = NO;
    }else{
        self.contentImageView.hidden = YES;
    }
  
    self.timeLabel.text = model.createtime;
}

- (void)initViews {
    [self.contentView addSubview:self.myContentView];
    [self.myContentView addSubview:self.timeLabel];
    [self.myContentView addSubview:self.titleLabel];
    [self.myContentView addSubview:self.contentLabel];
    [self.myContentView addSubview:self.headerImageView];
    [self.myContentView addSubview:self.contentImageView];

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
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.width.height.mas_equalTo(47);
    }];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.width.height.mas_equalTo(47);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(10);
        make.top.equalTo(self.headerImageView.mas_top);
        make.height.mas_equalTo(14);
        make.right.equalTo(self.contentImageView.mas_left).offset(10);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(10);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(14);
        make.right.equalTo(self.contentImageView.mas_left).offset(10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(10);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(12);
        make.right.equalTo(self.contentImageView.mas_left).offset(10);
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
    }
    return _timeLabel;
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [UIImageView new];
    }
    return _headerImageView;
}

- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [UIImageView new];
    }
    return _contentImageView;
}
@end
