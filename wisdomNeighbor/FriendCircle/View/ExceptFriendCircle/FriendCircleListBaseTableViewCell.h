//
//  FriendCircleListBaseTableViewCell.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/22.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendCircleListBaseTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *addessLabel;
@property (nonatomic, strong)UIView  *myContentView;

- (void)initViews;

- (NSString *)getCurrentMonthTimeString:(NSString *)timeStr;
- (NSString *)getCurrentDayTimeString:(NSString *)timeStr;
@end

NS_ASSUME_NONNULL_END
