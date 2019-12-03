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

NS_ASSUME_NONNULL_BEGIN

@interface LoginHousingTableViewCell : UITableViewCell
/**<##>*/
@property(nonatomic, strong)LoginModelHouses *model;
@property(nonatomic, strong)VerificationModelData *modelData;

@end

NS_ASSUME_NONNULL_END
