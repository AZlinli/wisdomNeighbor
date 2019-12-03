//
//  VerificationNextModel.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/11/18.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VerificationNextModelUserbelonghouse :NSObject
@property (nonatomic , copy) NSString              * userid;
@property (nonatomic , copy) NSString              * houseid;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * usertype;
@property (nonatomic , copy) NSString              * friendsremindnum;
@property (nonatomic , copy) NSString              * friendscirclelastuser;
@property (nonatomic , copy) NSString              * estate;
@property (nonatomic , copy) NSString              * createbyuser;
@property (nonatomic , copy) NSString              * enterercode;
@property (nonatomic , copy) NSString              * dislike;

@end

@interface VerificationNextModelData :NSObject
@property (nonatomic , strong) VerificationNextModelUserbelonghouse              * userbelonghouse;
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * usertype;
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , copy) NSString              * truename;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * firstlogintime;
@property (nonatomic , copy) NSString              * sex;
@property (nonatomic , copy) NSString              * icon;
@property (nonatomic , copy) NSString              * createtime;

@end

@interface VerificationNextModel :NSObject
@property (nonatomic , copy) NSArray<VerificationNextModelData *>              * data;
@property (nonatomic , assign) NSInteger              returnCode;
@property (nonatomic , copy) NSString              * errorMessage;

@end

NS_ASSUME_NONNULL_END
