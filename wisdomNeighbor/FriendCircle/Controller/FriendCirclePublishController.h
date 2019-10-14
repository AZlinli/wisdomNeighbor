//
//  FriendCirclePublishController.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/22.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendCirclePublishController : BaseViewController
/**发布成功回调*/
@property(nonatomic, copy) void(^publishSuccess)(void);
@end

NS_ASSUME_NONNULL_END
