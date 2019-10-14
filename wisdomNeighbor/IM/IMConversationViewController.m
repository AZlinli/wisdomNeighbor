//
//  IMConversationViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/29.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "IMConversationViewController.h"

@interface IMConversationViewController ()<RCIMUserInfoDataSource>

@end

@implementation IMConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    [RCIM sharedRCIM].userInfoDataSource = self;
   RCUserInfo *user = [[IMUserDBManager shareInstance]getUserWithUserId:self.targetId];
    
     RCUserInfo *newUser = [[RCUserInfo alloc]initWithUserId:self.targetId name:self.title portrait:self.portraitUrl];
    
    if (user) {
        [[IMUserDBManager shareInstance]updateUserTable:newUser];
    }else{
        [[IMUserDBManager shareInstance]insertUserDataInTable:newUser];

    }
    
   
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;

}
/*!
 获取用户信息
 
 @param userId      用户ID
 @param completion  获取用户信息完成之后需要执行的Block [userInfo:该用户ID对应的用户信息]
 
 @discussion SDK通过此方法获取用户信息并显示，请在completion中返回该用户ID对应的用户信息。
 在您设置了用户信息提供者之后，SDK在需要显示用户信息的时候，会调用此方法，向您请求用户信息用于显示。
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *userInfo))completion {
    RCUserInfo *user = [[IMUserDBManager shareInstance]getUserWithUserId:userId];
    completion(user);
}

//点击头像回调
- (void)didTapCellPortrait:(NSString *)userId {
    RCUserInfo *user = [[IMUserDBManager shareInstance]getUserWithUserId:userId];
    [GlobleCommonTool jumpToPersonalDataOrCircleListWithUserId:userId name:user.name headerIcon:user.portraitUri];
}
@end
