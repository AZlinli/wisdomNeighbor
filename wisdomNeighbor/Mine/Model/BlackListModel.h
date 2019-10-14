//
//  BlackListModel.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/10/11.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlackListModelData :NSObject
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * truename;
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , assign) NSInteger              sex;
@property (nonatomic , assign) NSInteger              nowuseestates;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              * belonghouse;
@property (nonatomic , assign) NSInteger              usertype;
@property (nonatomic , assign) NSInteger              friendsremindnum;
@property (nonatomic , assign) NSInteger              createuserid;
@property (nonatomic , copy) NSString              * password;
@property (nonatomic , copy) NSString              * icon;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , assign) NSInteger              status;

@end

@interface BlackListModel :NSObject
@property (nonatomic , copy) NSArray<BlackListModelData *>              * data;
@property (nonatomic , assign) NSInteger              returnCode;
@property (nonatomic , copy) NSString              * errorMessage;

@end

NS_ASSUME_NONNULL_END
