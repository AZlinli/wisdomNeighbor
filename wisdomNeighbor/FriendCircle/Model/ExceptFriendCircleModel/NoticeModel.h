//
//  NoticeModel.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/27.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NoticeModelComments :NSObject

@end

@interface NoticeModelSendUser :NSObject
@property (nonatomic , assign) NSInteger              status;
@property (nonatomic , assign) NSInteger              friendsremindnum;
@property (nonatomic , assign) NSInteger              nowuseestates;
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , assign) NSInteger              usertype;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , assign) NSInteger              sex;
@property (nonatomic , copy) NSString              * icon;
@property (nonatomic , assign) NSInteger              createuserid;

@end

@interface NoticeModelLikes :NSObject

@end

@interface NoticeModelData :NSObject
@property (nonatomic , copy) NSArray<NoticeModelComments *>              * comments;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * updatetime;
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , strong) NoticeModelSendUser              * sendUser;
@property (nonatomic , assign) NSInteger              belongestates;
@property (nonatomic , copy) NSArray<NoticeModelLikes *>              * likes;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              * senduser;

@end

@interface NoticeModel :NSObject
@property (nonatomic , copy) NSArray<NoticeModelData *>              * data;
@property (nonatomic , assign) NSInteger              returnCode;
@property (nonatomic , copy) NSString              * errorMessage;

@end

NS_ASSUME_NONNULL_END
