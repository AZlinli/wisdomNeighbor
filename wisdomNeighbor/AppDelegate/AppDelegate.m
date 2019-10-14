//
//  AppDelegate.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/10.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "AppDelegate.h"
#import "CYLTabBarController.h"
#import "BaseTabBarConfig.h"
#import "XKMapManager.h"
#import "XKBaiduMapFactory.h"
#import "LoginModel.h"
#import "LoginViewController.h"
#import <QCloudCore.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import "LoginHousingViewController.h"

@interface AppDelegate ()<QCloudSignatureProvider>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    if ([LoginModel currentUser].data.users.phone) {
        if ([LoginModel currentUser].currentHouseId) {
            BaseTabBarConfig *tabBarControllerConfig = [[BaseTabBarConfig alloc] init];
            CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
            //已经登录
            self.window.rootViewController = tabBarController;
        }else{
            LoginHousingViewController *vc = [LoginHousingViewController new];
            vc.showBack = NO;
            //没有选择小区退出
            self.window.rootViewController = vc;
        }
       
    }else {
        LoginViewController *vc = [LoginViewController new];
        vc.vcType = loginVCTyoeLogin;
        //正常登录
        self.window.rootViewController = vc;
    }
    [self configQCloudService];
    [self configKeyboardManager];
    [self baiduMapConfig];
    [XKLoginConfig loginConfig];
    //创建数据库
    [self creatDB];
    [GlobleCommonTool getCurrentDate];
    return YES;
}


- (void)configKeyboardManager {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)baiduMapConfig {
    
    //记录使用什么地图
    [XKMapManager recodeFactory:[XKBaiduMapFactory class]];
    //创建对应工厂
    id<XKMapFactoryProtocol> mapFactory = [[XKBaiduMapFactory alloc] initWithAppkey:BaiduMapAppKey];
    NSLog(@"%@",mapFactory);
}

- (void)configQCloudService {
    QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];
    configuration.appID = kQCloudAppID;
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint* endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = kQCloudRegion;//服务地域名称，可用的地域请参考注释
    configuration.endpoint = endpoint;
    [QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
    [QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];
}

//第二步：实现QCloudSignatureProvider协议
- (void) signatureWithFields:(QCloudSignatureFields*)fileds
                     request:(QCloudBizHTTPRequest*)request
                  urlRequest:(NSURLRequest*)urlRequst
                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
{
    QCloudCredential* credential = [QCloudCredential new];
    credential.secretID  = kQCloudSecretID;
    credential.secretKey = kQCloudSecretKey;
    QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
    QCloudSignature* signature =  [creator signatureForData:urlRequst.copy];
    continueBlock(signature, nil);
}


//创建数据库
- (void)creatDB {
    
    [[IMUserDBManager shareInstance]createTable];
    //将自己的信息添加进数据库
    RCUserInfo *user = [[IMUserDBManager shareInstance]getUserWithUserId:[LoginModel currentUser].data.users.userId];
    RCUserInfo *newUser = [[RCUserInfo alloc]initWithUserId:[LoginModel currentUser].data.users.userId name:[LoginModel currentUser].data.users.nickname portrait:[LoginModel currentUser].data.users.icon];
    
    if (user) {
        [[IMUserDBManager shareInstance]updateUserTable:newUser];
    }else{
        [[IMUserDBManager shareInstance]insertUserDataInTable:newUser];
        
    }
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
