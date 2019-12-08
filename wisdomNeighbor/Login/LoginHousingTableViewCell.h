//
//  LoginHousingTableViewCell.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/11/17.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"
#import "VerificationModel.h"
#import "LoginHousingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginHousingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayout;
/**<##>*/
@property(nonatomic, strong)LoginModelHouses *model;
@property(nonatomic, strong)VerificationModelData *modelData;
@property(nonatomic, strong)LoginHousingModelData *housingModelData;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@end

NS_ASSUME_NONNULL_END
