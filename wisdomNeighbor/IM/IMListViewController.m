//
//  IMListViewController.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/15.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "IMListViewController.h"

@interface IMListViewController ()<RCIMUserInfoDataSource>

@end

@implementation IMListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"私聊消息";
    [RCIM sharedRCIM].userInfoDataSource = self;
    self.navigationController.navigationBar.hidden = NO;
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}


//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    IMConversationViewController *conversationVC = [[IMConversationViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    RCUserInfo *user = [[IMUserDBManager shareInstance]getUserWithUserId:model.targetId];
    conversationVC.title = user.name;
    conversationVC.portraitUrl = user.portraitUri;
    [self.navigationController pushViewController:conversationVC animated:YES];
}


- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *userInfo))completion {
    RCUserInfo *user = [[IMUserDBManager shareInstance]getUserWithUserId:userId];
    completion(user);
}
@end
