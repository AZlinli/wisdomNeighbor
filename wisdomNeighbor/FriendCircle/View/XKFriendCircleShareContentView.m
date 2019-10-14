/*******************************************************************************
 # File        : XKFriendCircleShareContentView.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2019/5/16
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendCircleShareContentView.h"

@interface XKFriendCircleShareContentView ()

@end

@implementation XKFriendCircleShareContentView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化默认数据
        [self createDefaultData];
        // 初始化界面
        [self createUI];
        // 布局界面
        [self createConstraints];
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {

}

#pragma mark - 初始化界面
- (void)createUI {
    self.backgroundColor = HEX_RGB(0xF3F3F5);
    self.imageView = [UIImageView new];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self addSubview:self.imageView];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.textColor = HEX_RGB(0x222222);
    self.contentLabel.font = XKNormalFont(13);
    self.contentLabel.numberOfLines = 0;
    [self addSubview:self.contentLabel];
}

#pragma mark - 布局界面
- (void)createConstraints {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(6);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_top).offset(2);
        make.left.equalTo(self.imageView.mas_right).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.bottom.mas_lessThanOrEqualTo(self.mas_bottom);
    }];

}

#pragma mark ----------------------------- 公用方法 ------------------------------


@end
