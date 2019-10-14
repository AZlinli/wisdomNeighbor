//
//  MineResidentRedactTableViewCell.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/14.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineResidentRedactTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *smallLabel;
@property (nonatomic, strong)UITextField *rightTitleTextField;
@property (nonatomic, strong)UIImageView *nextImageView;
@property (nonatomic, strong)UIView      *myContentView;
@end

NS_ASSUME_NONNULL_END
