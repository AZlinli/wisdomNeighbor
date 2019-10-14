//
//  XKUserInfo.h
//  XKSquare
//
//  Created by hupan on 2018/7/31.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>


/**用户部分配置相关参数 目前服务器没有同步 本地存储 不随用户退出清除 直接拼接存在userDefault了*/


#define kAlreadySubscriptionArr [NSString stringWithFormat:@"alreadySubscriptionArr_%@", [XKUserInfo getCurrentUserId]]
#define kCanSubscriptionArr [NSString stringWithFormat:@"canSubscriptionArr_%@", [XKUserInfo getCurrentUserId]]


/**
 XKUserInfo 请只存放跟当前用户相关的信息  退出登录会清除所有
 */


@interface XKUserImAccount :NSObject
@property (nonatomic , copy) NSString              * accid;
@property (nonatomic , copy) NSString              * token;

@end

@interface
XKUserInfo : NSObject

#pragma mark - 想取出模型 key 和上述字符串对应即可

@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , copy) NSString              * token;
@property (nonatomic , strong) XKUserImAccount     * userImAccount;

@property (nonatomic , copy) NSString              * address;
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * realPhone;
@property (nonatomic , copy) NSString              * loginType;
@property (nonatomic , copy) NSString              * securityCode;
@property (nonatomic , copy) NSString              * age;
@property (nonatomic , copy) NSString              * birthday;
@property (nonatomic , copy) NSString              * constellation;
@property (nonatomic , copy) NSString              * qrCode;
@property (nonatomic , copy) NSString              * sex;
@property (nonatomic , copy) NSString              * signature;
@property (nonatomic , copy) NSString              * uid;
@property (nonatomic , strong) NSNumber            * timeInterval;
@property (nonatomic , copy) NSString              * platformPhone;

/**取得当前用户*/
+ (XKUserInfo *)currentUser;

/**同步当前用户至userDefault 以便下次程序启动有值*/
#define XKUserSynchronize [XKUserInfo synchronizeUser];
+ (void)synchronizeUser;

/**保存用户至单例 并且存至userDefult*/
+ (void)saveCurrentUser:(XKUserInfo *)user;

/**请空user*/
+ (void)cleanUser;


@end
