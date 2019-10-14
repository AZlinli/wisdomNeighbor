//
//  FriendsCirclelModel.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/20.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface Comments2 :NSObject
@property (nonatomic , copy) NSString              *ID;
@property (nonatomic , copy) NSString              *createuserid;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * belonghouse;
@property (nonatomic , copy) NSString              * enterercode;
@property (nonatomic , copy) NSString              * friendscirclelastuser;
@property (nonatomic , assign) NSInteger              friendsremindnum;
@property (nonatomic , copy) NSString              * likes;
@property (nonatomic , copy) NSString              * logintime;
@property (nonatomic , assign) NSInteger              nowuseestates;
@property (nonatomic , assign) NSInteger              sex;
@property (nonatomic , copy) NSString              * password;
@property (nonatomic , copy) NSString              * icon;
@property (nonatomic , copy) NSString              * truename;
@property (nonatomic , assign) NSInteger              usertype;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * dislikes;
@property (nonatomic , assign) NSInteger              status;

@end

@interface BeComments :NSObject
@property (nonatomic , copy) NSString              *ID;
@property (nonatomic , copy) NSString              *createuserid;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * belonghouse;
@property (nonatomic , copy) NSString              * enterercode;
@property (nonatomic , copy) NSString              * friendscirclelastuser;
@property (nonatomic , assign) NSInteger              friendsremindnum;
@property (nonatomic , copy) NSString              * likes;
@property (nonatomic , copy) NSString              * logintime;
@property (nonatomic , assign) NSInteger              nowuseestates;
@property (nonatomic , assign) NSInteger              sex;
@property (nonatomic , copy) NSString              * password;
@property (nonatomic , copy) NSString              * icon;
@property (nonatomic , copy) NSString              * truename;
@property (nonatomic , assign) NSInteger              usertype;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * dislikes;
@property (nonatomic , assign) NSInteger              status;

@end


@interface Comments :NSObject
@property (nonatomic , strong) Comments2              * comments;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , assign) NSInteger              friendscircleid;
@property (nonatomic , strong) BeComments              * beComments;
@property (nonatomic , copy)  NSString              *ID;
@property (nonatomic , copy)  NSString               *userid;
@property (nonatomic , assign) NSInteger              belongestates;
@property (nonatomic , copy) NSString *              useridBecomment;
@property (nonatomic , assign) NSInteger              type;
@property (nonatomic , copy) NSString              * createtime;
#pragma mark - 辅助
/**<##>*/
@property(nonatomic, strong) NSAttributedString *contentMStr;
/**<##>*/
@property(nonatomic, assign) CGFloat contentHeight;
@end

@interface Likes :NSObject
@property (nonatomic , assign) NSInteger              status;
@property (nonatomic , assign) NSInteger              friendsremindnum;
@property (nonatomic , assign) NSInteger              nowuseestates;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , assign) NSInteger              usertype;
@property (nonatomic , assign) NSInteger              sex;
@property (nonatomic , copy) NSString              * icon;
@property (nonatomic , assign) NSInteger              createuserid;

@end


@interface SendUser :NSObject
@property (nonatomic , assign) NSInteger              status;
@property (nonatomic , assign) NSInteger              friendsremindnum;
@property (nonatomic , assign) NSInteger              nowuseestates;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * usertype;
@property (nonatomic , assign) NSInteger               sex;
@property (nonatomic , copy) NSString              * icon;
@property (nonatomic , assign) NSInteger              createuserid;

@end


@interface FriendsCirclelListItem :NSObject <YYModel>
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSArray<Comments *>              * comments;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , assign) NSInteger              belongestates;
@property (nonatomic , strong) NSArray<Likes *>              * likes;
@property (nonatomic , copy) NSString              * detailType;
@property (nonatomic , copy) NSString              * tag;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * images;
@property (nonatomic , strong) SendUser              * sendUser;
@property (nonatomic , copy) NSString              * locationaddress;
@property (nonatomic , copy) NSString              * uerid;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * contenttype;
@property (nonatomic , assign) BOOL                  isLike;

@end


@interface FriendsCirclelModel : NSObject
@property (nonatomic , assign) NSInteger              returnCode;
@property (nonatomic , copy) NSArray<FriendsCirclelListItem *>              * data;
@property (nonatomic , copy) NSString                 * errorMessage;
@end




NS_ASSUME_NONNULL_END
