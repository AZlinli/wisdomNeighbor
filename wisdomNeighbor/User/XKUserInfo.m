//
//  XKUserInfo.m
//  XKSquare
//
//  Created by hupan on 2018/7/31.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKUserInfo.h"
#import "YYModel.h"

static NSString *XKUserCacheKey = @"staticUserCacheKey2";
static dispatch_queue_t _serialQueue;
static NSString *XKPlatformPhone = @"";
static XKUserInfo *_user;

@interface XKUserInfo ()<YYModel> {
    NSString *_platformPhone;
}

@end

@implementation XKUserInfo

+ (void)load {
    _serialQueue = dispatch_queue_create("user_save_queue", DISPATCH_QUEUE_SERIAL);
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userId": @"id"};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"userId" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}

+ (XKUserInfo *)currentUser {
    __block XKUserInfo *cUser;
    dispatch_sync(_serialQueue, ^{
        if (!_user) {
            XKUserInfo *user = [XKUserInfo yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:XKUserCacheKey]];
            if (user == nil) {
                user = [[XKUserInfo alloc] init];
            }
            _user = user;
        }
        cUser = _user;
    });
    
    return cUser;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - 清除用户
+ (void)cleanUser {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:XKUserCacheKey];
    _user = nil;
}

#pragma mark - 同步当前用户至userDefault
+ (void)synchronizeUser {
    [self saveCurrentUser:_user];
}

#pragma mark - 保存用户至单例 并且存至userDefult
+ (void)saveCurrentUser:(XKUserInfo *)user {
    _user = user;
    dispatch_async(_serialQueue, ^{
        if (_user == nil) {
            [self cleanUser];
        } else {
            NSString *userStr = [_user yy_modelToJSONString];
            [[NSUserDefaults standardUserDefaults] setObject:userStr forKey:XKUserCacheKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    });
}


@end


@implementation XKUserImAccount

@end
