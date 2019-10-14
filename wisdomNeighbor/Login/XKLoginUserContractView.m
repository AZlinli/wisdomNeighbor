//
//  XKLoginUserContractView.m
//  XKSquare
//
//  Created by Lin Li on 2019/1/4.
//  Copyright © 2019 xk. All rights reserved.
//

#import "XKLoginUserContractView.h"
@interface XKLoginUserContractView()
/**合同名字*/
@property(nonatomic, copy) NSString *contractTitle;
/**固定的合同前缀*/
@property(nonatomic, copy) NSString *contractFixationTitle;
/**选择按钮*/
@property(nonatomic, strong) UIButton *selectButton;
/**合同label*/
@property(nonatomic, strong) YYLabel *contractLabel;
/**容器*/
@property(nonatomic, strong) UIView *contentView;
@end

@implementation XKLoginUserContractView

- (instancetype)initWithContractTitle:(NSString *)contractTitle {
    if (self = [super init]) {
        _contractTitle = contractTitle;
        _contractFixationTitle = @"我已阅读并同意";
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.selectButton];
    [self.contentView addSubview:self.contractLabel];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(14 * 1);
    }];
    
    [self.contractLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectButton.mas_right).offset(5 *1);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(17 * 1);
        make.right.equalTo(self.contentView);
    }];
    XKWeakSelf(ws);
    NSMutableAttributedString *atrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",self.contractFixationTitle,self.contractTitle]];
    [atrStr yy_setTextHighlightRange:NSMakeRange(self.contractFixationTitle.length, self.contractTitle.length) color:HEX_RGB(0x4A90FA) backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [ws gotoContractDes];
    }];
    self.contractLabel.attributedText = atrStr;
    self.isAgreeContract = self.selectButton.selected;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [[UIButton alloc]init];
        [_selectButton setImage:[UIImage imageNamed:@"xk_ic_login_unselected"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"xk_ic_login_selected"] forState:UIControlStateSelected];
        _selectButton.selected = YES;
        [_selectButton addTarget:self action:@selector(selctedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (YYLabel *) contractLabel{
    if (!_contractLabel) {
        _contractLabel = [[YYLabel alloc]init];
        _contractLabel.font = XKRegularFont(12);
        _contractLabel.userInteractionEnabled = YES;
        _contractLabel.textColor = HEX_RGB(0x464646);
    }
    return _contractLabel;
}

- (void)gotoContractDes {
    NSLog(@"gotoContractDes---------------gotoContractDes");
    if (self.contractBlock) {
        self.contractBlock();
    }
}

- (void)selctedAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.isAgreeContract = sender.selected;
}
@end
