//
//  FriendListTableViewCell.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/30.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendListTableViewCell : UITableViewCell
/**图片*/
@property(nonatomic, strong) UIImageView *headerImgView;
/**名字*/
@property(nonatomic, strong) UILabel *nameLabel;
@end

NS_ASSUME_NONNULL_END
