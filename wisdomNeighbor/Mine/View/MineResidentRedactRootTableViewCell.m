//
//  MineResidentRedactRootTableViewCell.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/11/17.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "MineResidentRedactRootTableViewCell.h"
@interface MineResidentRedactRootTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nextImageView;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

@implementation MineResidentRedactRootTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    self.titleLabel.textColor = UIColorFromRGB(0x222222);
    self.desLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10];
    self.desLabel.textColor = UIColorFromRGB(0x777777);
    self.headerImageView.xk_clipType = XKCornerClipTypeAllCorners;
    self.headerImageView.xk_openClip = YES;
    self.headerImageView.xk_radius = 6;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(MineResidentRedactModelData *)model {
    _model = model;
    self.titleLabel.text = model.nickname;
    if ([model.usertype isEqualToString:@"1"]) {
        self.desLabel.text = @"业主";
    }else if ([model.usertype isEqualToString:@"2"]){
        self.desLabel.text = @"畅享卡";
    }else if ([model.usertype isEqualToString:@"6"]){
        self.desLabel.text = @"便捷卡";
    }
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.model.icon] placeholderImage:kDefaultHeadImg];

}

- (void)isShowNextImage:(BOOL)isShow {
    self.nextImageView.hidden = !isShow;
}
@end
