//
//  MineResidentRedactModel.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/30.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface MineResidentRedactModelUserbelonghouse :NSObject
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

@interface MineResidentRedactModelData :NSObject
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * truename;
@property (nonatomic , strong) MineResidentRedactModelUserbelonghouse              * userbelonghouse;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * usertype;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              * icon;
@property (nonatomic , copy) NSString              * sex;

@end

@interface MineResidentRedactModel :NSObject
@property (nonatomic , copy) NSString              * returnCode;
@property (nonatomic , copy) NSArray<MineResidentRedactModelData *>              * data;
@property (nonatomic , copy) NSString              * errorMessage;

@end

NS_ASSUME_NONNULL_END
