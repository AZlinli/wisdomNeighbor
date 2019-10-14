/*******************************************************************************
 # File        : XKInfoProvider.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2019/2/28
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <Foundation/Foundation.h>
#import "XKUserInfo.h"
/*
 由于多个工程，用户信息，设备参数都不同，为了方便组件内获取这些信息与组件解耦，
 所以此类作为信息提供的适配器，为组件获取用户等信息提供统一的接口。
 使用方式：
 1.在不同工程，初始化该类的时候，将信息提供给该类。
 2.组件内部，通过属性和方法获取不同工程提供的值
 */

@interface XKInfoProvider : NSObject

/**初始化方式 给provider属性赋值*/
+ (void)providerConfig:(void(^)(XKInfoProvider *provider))providerConfig;

+ (XKInfoProvider *)shareProvider;

/********************
 1. 对于静态不会变化的信息，可以使用属性直接存储
 2. 对于用户信息可能会动态变化的信息，要使用block回调。每次调用block内的方法，获取最新的值。
 *********************/


#pragma mark - 静态
/*设备名称 iphone5s ..*/
@property(nonatomic, copy) NSString *deviceName;
/*设备id..*/
@property(nonatomic, copy) NSString *guid;
/**获取平台网络区分参数 ua ma ..*/
@property(nonatomic, copy) NSString *platformNetCode;
/**网络token失效错误码数组*/
@property(nonatomic, copy) NSArray<NSString *> *tokenFailCodeArr;

#pragma mark - 动态
/**获取用户信息 请初始化时赋值*/
@property(nonatomic, copy) XKUserInfo *(^getUser)(void);
/**获取网络加密盐*/
@property(nonatomic, copy) NSString  *(^getSalt)(void);
/**获取当前时间戳 毫秒*/
@property(nonatomic, copy) NSString  *(^getCurrentTimestamp)(void);
/**获取服务器本地时间时间戳差值 毫秒*/
@property(nonatomic, copy) NSNumber  *(^getTimestampDifference)(void);
/**获取BaseUrl*/
@property(nonatomic, copy) NSString  *(^getBaseUrlStr)(void);
/**获取云信登录用户id*/
@property(nonatomic, copy) NSString  *(^getIMAccoutId)(void);

/**通用获取值的方法 对于使用频率很低的参数，不想扩充属性去存储和获取，
 可以使用该方法动态获取. 就不用修改这个Provider文件了
 实现方式在主工程初始化时 通过key判断动态返回自己所需要的值。
 */
@property(nonatomic, copy) NSString *(^getSpecialValue)(NSString *specialKey);


@end
