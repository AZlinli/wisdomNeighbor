//
//  IMConversationViewController.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/29.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMConversationViewController : RCConversationViewController
/**头像*/
@property(nonatomic, copy) NSString *portraitUrl;
@end

NS_ASSUME_NONNULL_END
