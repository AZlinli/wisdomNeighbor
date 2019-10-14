//
//  NoticeListTableViewCell.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/27.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeListTableViewCell : UITableViewCell
/**model*/
@property(nonatomic, strong) NoticeModelData *model;
@end

NS_ASSUME_NONNULL_END
