//
//  PersonalDataPicTableViewCell.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/21.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalDataPicTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIView  *myContentView;
@property (nonatomic, strong)UIView  *imageContentView;
@property (nonatomic, strong)UIImageView    *nextImageView;
/**朋友圈的图片*/
@property(nonatomic, strong) NSArray *imageArray;
@end

NS_ASSUME_NONNULL_END
