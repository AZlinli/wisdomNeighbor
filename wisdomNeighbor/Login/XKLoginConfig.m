/*******************************************************************************
 # File        : XKLoginConfig.m
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/18
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKLoginConfig.h"


@implementation XKLoginConfig

/**
 退出之后的配置
 */
+ (void)loginDropOutConfig {
    [LoginModel cleanUser];

}


/**
 登录之后的配置
 */
+ (void)loginConfig {
    [self getToken];
    
}


+ (void)getToken {
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @"getToken";
    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;
    [HTTPClient postRequestWithURLString:@"project_war_exploded/imServlet" timeoutInterval:30 parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        XKUserInfo *user = [[XKUserInfo alloc]init];
        user.token = responseObject[@"data"];
        [XKUserInfo saveCurrentUser:user];
        [self imConfig];
    } failure:^(XKHttpErrror *error) {
        NSLog(@"%@", error.message);
    }];
}
+ (void)imConfig {
    [[RCIM sharedRCIM] initWithAppKey:kIMKey];
    [[RCIM sharedRCIM] connectWithToken:[XKUserInfo currentUser].token success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
}


@end
