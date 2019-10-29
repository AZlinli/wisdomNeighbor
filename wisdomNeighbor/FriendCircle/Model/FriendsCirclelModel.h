//
//  FriendsCirclelModel.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/20.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Userbelonghouse :NSObject
@property (nonatomic , copy) NSString              * friendscirclelastuser;
@property (nonatomic , copy) NSString              * houseid;
@property (nonatomic , copy) NSString              * friendsremindnum;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * estate;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * userid;
@property (nonatomic , copy) NSString              * usertype;
@property (nonatomic , copy) NSString              * createbyuser;

@end

@interface Comments2 :NSObject
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * truename;
@property (nonatomic , strong) Userbelonghouse              * userbelonghouse;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * usertype;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              * icon;
@property (nonatomic , copy) NSString              * sex;


@end

@interface BeComments :NSObject
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * truename;
@property (nonatomic , strong) Userbelonghouse              * userbelonghouse;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * usertype;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              * icon;
@property (nonatomic , copy) NSString              * sex;

@end


@interface Comments :NSObject
@property (nonatomic , strong) Comments2              * comments;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * friendscircleid;
@property (nonatomic , strong) BeComments              * beComments;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * senderid;
@property (nonatomic , copy) NSString              * useridSender;
@property (nonatomic , copy) NSString              * belongestates;
@property (nonatomic , copy) NSString              * useridBecomment;
@property (nonatomic , copy) NSString              * type;
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
@property (nonatomic , strong) Userbelonghouse              * userbelonghouse;

@end


@interface SendUser :NSObject
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * truename;
@property (nonatomic , strong) Userbelonghouse              * userbelonghouse;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * usertype;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              * icon;
@property (nonatomic , copy) NSString              * sex;
@end


@interface FriendsCirclelListItem :NSObject <YYModel>
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSArray<Comments *>              * comments;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              * belongestates;
@property (nonatomic , copy) NSArray<Likes *>              * likes;
@property (nonatomic , copy) NSString              * userbelonghouse;
@property (nonatomic , copy) NSString              * contenttype;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * tag;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * images;
@property (nonatomic , strong) SendUser              * sendUser;
@property (nonatomic , copy) NSString              * locationaddress;


@end


@interface FriendsCirclelModel : NSObject
@property (nonatomic , assign) NSInteger              returnCode;
@property (nonatomic , copy) NSArray<FriendsCirclelListItem *>              * data;
@property (nonatomic , copy) NSString                 * errorMessage;
@end




NS_ASSUME_NONNULL_END
