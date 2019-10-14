//
//  MessageListTableViewCell.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/21.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageListTableViewCell : UITableViewCell
/**MessageListModel*/
@property(nonatomic, strong) MessageListModelData *model;
@end

NS_ASSUME_NONNULL_END
