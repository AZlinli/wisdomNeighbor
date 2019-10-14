//
//  FriendCircleListViewController.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/22.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendCircleListViewController : BaseViewController
/**userId*/
@property(nonatomic, copy) NSString *userId;
/**头像*/
@property(nonatomic, copy) NSString *headerIcon;
/**名字*/
@property(nonatomic, copy) NSString *name;
@end

NS_ASSUME_NONNULL_END
