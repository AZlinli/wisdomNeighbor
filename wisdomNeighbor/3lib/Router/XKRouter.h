/*******************************************************************************
 # File        : XKRouter.h
 # Project     : xk
 # Author      : Jamesholy
 # Created     : 12/6/17
 # Corporation : xk
 # Description :
 项目路由，负责分发页面跳转
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <UIKit/UIKit.h>

static NSString * const kRouterAdapter    = @"RAdapter";
static NSString * const kRouterStoryboard = @"storyboard";
static NSString * const kRouterIdentifier = @"identifier";
static NSString * const kRouterXibName    = @"nibname";
static NSString * const kRouterTargetClass= @"targetclass";


static NSString * const kRouterObjectType       = @"ObjectType";
static NSString * const kRouterBoolType         = @"BoolType";
static NSString * const kRouterIntegerType      = @"IntegerType";
static NSString * const kRouterFolatType        = @"FolatType";

static NSString * const kRouterBoolTrue         = @"true";
static NSString * const kRouterBoolFalse        = @"false";

NS_ASSUME_NONNULL_BEGIN

// xk使用. 其他app可使用 scheme 属性读取
extern NSString * const kOpenRouteSchmem;


#pragma mark -  XKRouterProtrol

@protocol XKRouterProtrol<NSObject>

@required
/**
 远程调用 跳转

 @param params NSDictionary
 @param vc 响应根控制器
 */
+ (void)jumpRemoteWithParams:(NSDictionary *)params Parent:(UIViewController *)vc;

@end



#pragma mark -  XKRouter
@interface XKRouter : NSObject

/**
 scheme
 */
@property (nonatomic, copy, readonly) NSString *scheme;


/**
 路由单例对象

 @return 实例
 */
+ (instancetype)sharedInstance;


/**
 配置路由scheme  default: xksquare:
 
 @desc: 在 didFinishLaunchingWithOptions: 中设置 或者 在mian.m 中设置，
        保证程序刚启动就已经配置完成。
        在《晓可》app 中可以不设置，使用默认选项即可，其他项目app则必须参考上述设置。
 */
- (void)configRouteScheme:(NSString *)scheme;

/**
 处理 远程 open Url  中文请进行url编码（uft-8）
 
 @param  urlStr 例如：xk://house.detail?caseId=6632361&caseType=1&bizType=1
 @param vc 响应跳转的根视图
 @return bool
 
 @desc:
    当 vc = nil，内部会将这次的路由跳转缓存起来,在能够处理响应的时候，调用 handleCacheOpenURL。
    query 支持 数组 字典类型。例如: xksquare://com.abc?city[0]=beijing&city[2]=shanghai&city[3]=hangzhou&person[name]=li&person[age]=21&id=53278
 
 @use scene:
    例如: apns推送，app 收到推送，需要处理url跳转，但是此刻app，可能刚被唤醒，所以可以当app 启动完成，进入第一个vc之后，再去处理响应。
 */
- (BOOL)runRemoteUrl:(nullable NSString *)urlStr ParentVC:(nullable UIViewController *)vc;


/**
 调用 本地 native 方法
 
 @desc: 使用于 组件化跨模块的方式 调用，基本不会在业务层直接调用，该方法主要用于组件化解耦，采用 target-action 模式，
 具体组件化实际调用流程： 1. 每个组件内部，有两个文件（ HFTRouter+ModuleName.h  Target_ModuleName.h）
 这两个文件是组件内部的通信子module,组件内部的跳转也可以使用这两个文件.
 2. 跨越组件通信的时候，以 HFTRouter 为底层通信处理，以内部通信组件为对接。
 
 @param targetName  目标类名（字符串）
 @param actionName  方法名 （字符串）
 @param params      传递参数 （k-v）
 @return id 类型
 */
- (nullable id)runNativeTarget:(NSString *)targetName Action:(NSString *)actionName Params:(nullable NSDictionary *)params;

/**
 处理缓存 url
 */
- (void)handleCacheRemoteURL;

/**
 获取参数
 
 @param urlStr 路由URL
 @return 参数
 */
- (NSDictionary *)getParamsWithParseURL:(NSString *)urlStr;

@end


#pragma mark - XKRouter (Host)

@interface XKRouter (Host)

/**
 生成 远程 url

 @param host host 例如：im.detail
 @param params 参数
 @return url
 */
- (NSString *)urlRemoteHost:(NSString *)host Params:(nullable NSDictionary *)params;


/**
 生成 动态调用的远程 url

 @param targetClass 目标类名
 @param storyname storyname 非storyname启动，则为nil
 @param identifier identifier
 @param xibName xib文件名
 @param params 参数
 @return url
 
 @desc: 
 示例
 NSString *url = [XKRouter urlDynamicTargetClassName:@"SosoDetailInfoViewController" Storyboard:@"SosoDetailInfoViewController" Identifier:@"SosoDetailInfoViewController" Params:@{@"houseId":@"1011097221",@"houseInfoState":@"0",@"isFromHome":@"1"}];

 获取到 xk://com.dynamic?storyboard=SosoDetailInfoViewController&targetclass=SosoDetailInfoViewController&houseInfoState=0&identifier=SosoDetailInfoViewController&houseId=1011097221&isFromHome=1
 
 */
- (NSString *)urlDynamicTargetClassName:(NSString *)targetClass Storyboard:(nullable NSString *)storyname Identifier:(nullable NSString *)identifier XibName:(nullable NSString *)xibName Params:(nullable NSDictionary *)params;


@end


@interface XKRouter (method)

+ (NSArray *)propertyListByClass:(Class)clasS propertyClassMap:(NSDictionary **)map;
@end


NS_ASSUME_NONNULL_END
