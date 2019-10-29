//
//  LoginModel.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/22.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModelUsers
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userId" : @"id",
             };
}
@end
@implementation LoginModelEstates
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"estatesId" : @"id",
             };
}
@end

@implementation LoginModelUserbelonghouse
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             };
}
@end

@implementation LoginModelHouses
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"housesId" : @"id",
             };
}
@end
@implementation LoginModelData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"houses" : [LoginModelHouses class]};
}
@end


static NSString *XKUserCacheKey = @"staticUserCacheKey";
static dispatch_queue_t _serialQueue;
static NSString *XKPlatformPhone = @"";
static LoginModel *_user;

@implementation LoginModel
+ (void)load {
    _serialQueue = dispatch_queue_create("user_save_queue", DISPATCH_QUEUE_SERIAL);
}

+ (LoginModel *)currentUser {
    __block LoginModel *cUser;
    dispatch_sync(_serialQueue, ^{
        if (!_user) {
            LoginModel *user = [LoginModel yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:XKUserCacheKey]];
            if (user == nil) {
                user = [[LoginModel alloc] init];
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
+ (void)saveCurrentUser:(LoginModel *)user {
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
