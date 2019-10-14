//
//  PersonalDataViewController.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/21.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendTalkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonalDataViewController : BaseViewController
/**<##>*/
@property(nonatomic, assign)PersonalVcType vcType;
/**头像*/
@property(nonatomic, copy) NSString *headerIcon;
/**名字*/
@property(nonatomic, copy) NSString *name;
/**备注*/
@property(nonatomic, copy) NSString *otherName;
/**userId*/
@property(nonatomic, copy) NSString *userId;
@end

NS_ASSUME_NONNULL_END
