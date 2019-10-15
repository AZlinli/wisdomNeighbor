//
//  FriendCircleListImageTableViewCell.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/22.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "FriendCircleListBaseTableViewCell.h"
#import "FriendTalkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendCircleListImageTableViewCell : FriendCircleListBaseTableViewCell
/**<##>*/
@property(nonatomic, strong) FriendTalkModel *model;
/**是否是当前用户*/
@property(nonatomic, assign) BOOL isMinePpecial;
@end

NS_ASSUME_NONNULL_END
