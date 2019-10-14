//
//  FriendsCircleListViewModel.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/20.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendCircleBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendsCircleListViewModel : FriendCircleBaseViewModel
/**请求列表*/
- (void)requestRefresh:(BOOL)refresh complete:(void (^)(id error,id data))completeBlock;

/**请求朋友圈详情列表*/
- (void)requestDetailWithFriendsCircleId:(NSString *)friendsCircleId complete:(void (^)(id error,id data))complete;

/**模糊搜索朋友圈*/
- (void)requestDetailWithFriendsKeyWord:(NSString *)keyWord complete:(void (^)(id error,id data))complete;
@end

NS_ASSUME_NONNULL_END
