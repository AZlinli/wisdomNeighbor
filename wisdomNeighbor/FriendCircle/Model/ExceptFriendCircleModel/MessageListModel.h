//
//  MessageListModel.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/21.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageListModelComments :NSObject
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * createuserid;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * enterercode;
@property (nonatomic , copy) NSString              * logintime;
@property (nonatomic , copy) NSString              * friendscirclelastuser;
@property (nonatomic , copy) NSString              * friendsremindnum;
@property (nonatomic , copy) NSString              * likes;
@property (nonatomic , copy) NSString              * belonghouse;
@property (nonatomic , copy) NSString              * nowuseestates;
@property (nonatomic , copy) NSString              * sex;
@property (nonatomic , copy) NSString              * password;
@property (nonatomic , copy) NSString              * icon;
@property (nonatomic , copy) NSString              * truename;
@property (nonatomic , copy) NSString              * usertype;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * dislikes;
@property (nonatomic , copy) NSString              * status;

@end

@interface MessageListModelData :NSObject
@property (nonatomic , strong) MessageListModelComments              * comments;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * friendscircleid;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * userid;
@property (nonatomic , copy) NSString              * belongestates;
@property (nonatomic , copy) NSString              * useridBecomment;
@property (nonatomic , copy) NSString              * firstFriendsImg;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              * type;

@end

@interface MessageListModel :NSObject
@property (nonatomic , copy) NSString              * returnCode;
@property (nonatomic , copy) NSArray<MessageListModelData *>              * data;
@property (nonatomic , copy) NSString              * errorMessage;

@end

NS_ASSUME_NONNULL_END
