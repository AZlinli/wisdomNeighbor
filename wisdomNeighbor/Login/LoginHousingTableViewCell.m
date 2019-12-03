//
//  LoginHousingTableViewCell.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/11/17.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "LoginHousingTableViewCell.h"
@interface LoginHousingTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextImageView;

@end

@implementation LoginHousingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.desLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    self.desLabel.textColor = UIColorFromRGB(0x222222);
    self.nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10];
    self.nameLabel.textColor = UIColorFromRGB(0x777777);
}

- (void)setModel:(LoginModelHouses *)model {
    _model = model;
    self.desLabel.text = model.estates.name;
    self.nameLabel.text = model.inestateslocation;
    self.backgroundColor = UIColorFromRGB(0xf6f6f6);
}


- (void)setModelData:(VerificationModelData *)modelData {
    _modelData = modelData;
    self.desLabel.text = modelData.name;
    self.nameLabel.text = modelData.locationstring;
    self.backgroundColor = UIColorFromRGB(0xffffff);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
