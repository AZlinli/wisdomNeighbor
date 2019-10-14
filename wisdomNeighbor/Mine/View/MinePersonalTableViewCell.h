//
//  MinePersonalTableViewCell.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/13.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MinePersonalTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *smallLabel;
@property (nonatomic, strong)UILabel *rightTitlelabel;
@property (nonatomic, strong)UIImageView *nextImageView;
@property (nonatomic, strong)UIView      *myContentView;
@end

NS_ASSUME_NONNULL_END
