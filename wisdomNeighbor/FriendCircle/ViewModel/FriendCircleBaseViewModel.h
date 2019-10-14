//
//  FriendCircleBaseViewModel.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/20.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendCircleBaseViewModel : NSObject<UITableViewDataSource,UITableViewDelegate>
/**请求页数*/
@property(nonatomic, assign) NSInteger page;
/**请求条数*/
@property(nonatomic, assign) NSInteger limit;

@property(nonatomic, assign) RefreshDataStatus refreshStatus;

@property(nonatomic, strong) NSMutableArray *dataArray;

- (void)configVCToolBar:(BaseViewController *)vc;

/**滚动回调*/
@property(nonatomic, copy) void(^scrollViewScroll)(UIScrollView *scrollView);

@property(nonatomic, copy) void(^refreshTableView)(void);

- (void)registerCellForTableView:(UITableView *)tableView;

- (void)requestDelete:(NSString *)did Complete:(void (^)(NSString *err, id data))completeBlock;

@end

NS_ASSUME_NONNULL_END
