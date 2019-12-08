//
//  RegistPlotTableViewCell.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/12/5.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegistPlotTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *smallLabel;
@property (nonatomic, strong)UITextField *rightTitlelabel;
@property (nonatomic, strong)UIImageView *nextImageView;
@property (nonatomic, strong)UIView      *myContentView;
@property (nonatomic, strong)UIImageView *titleImageView;
@property (nonatomic, strong)UILabel *numLabel;

@end

NS_ASSUME_NONNULL_END
