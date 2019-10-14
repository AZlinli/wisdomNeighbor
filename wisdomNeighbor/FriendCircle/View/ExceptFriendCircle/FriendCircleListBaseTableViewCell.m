//
//  FriendCircleListBaseTableViewCell.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/22.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "FriendCircleListBaseTableViewCell.h"

@interface FriendCircleListBaseTableViewCell()

@end

@implementation FriendCircleListBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}
- (void)initViews {
    [self.contentView addSubview:self.myContentView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.addessLabel];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(23);
    }];
    
    [self.addessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_left);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(7);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(40);
    }];
    
    [self.myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset(15);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-20);
    }];
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
    }
    return _timeLabel;
}

- (UILabel *)addessLabel {
    if (!_addessLabel) {
        _addessLabel = [UILabel new];
        _addessLabel.font = XKRegularFont(14);
        _addessLabel.textColor = HEX_RGB(0x606772);
        _addessLabel.text = @"成都";
    }
    return _addessLabel;
}


- (UIView *)myContentView {
    if (!_myContentView) {
        _myContentView = [UIView new];
    }
    return _myContentView;
}


- (NSString *)getCurrentMonthTimeString:(NSString *)timeStr{
    return [NSString stringWithFormat:@"%ld",(long)[[self getCurrentYearMonthDay:NSCalendarUnitMonth timeString:timeStr]month]];
}
- (NSString *)getCurrentDayTimeString:(NSString *)timeStr {
    
    return [NSString stringWithFormat:@"%ld",(long)[[self getCurrentYearMonthDay:NSCalendarUnitDay timeString:timeStr]day]];
}

- (NSDateComponents *)getCurrentYearMonthDay:(unsigned int)calendarUnit timeString:(NSString *)timeStr{
    // 创建日期格式化对象
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    // 设置地区
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [format dateFromString:timeStr];
    NSCalendar *cal = [NSCalendar currentCalendar];
    //这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    unsigned int unitFlags = calendarUnit;
    //把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    NSDateComponents *d = [cal components:unitFlags fromDate:date];
    return d;
}
@end
