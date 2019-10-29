//
//  FriendsCircleListViewModel.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/20.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "FriendsCircleListViewModel.h"
#import "XKFriendsTalkCommonRLCell.h"
#import "XKFriendCircleFooterView.h"
#import "XKFriendTalkReplyCell.h"
#import "XKCommentInputView.h"
#import "FriendCircleListViewController.h"

#define kMaxReply 100


static NSString *const replyCellId = @"replyCellId";
@interface FriendsCircleListViewModel()
@property(nonatomic, weak) BaseViewController *vc;
/**评论输入框*/
@property(nonatomic, strong) XKCommentInputView *replyView;
/**评论缓存*/
@property(nonatomic, strong) XKCommentInputInfo *commentInfo;
/**lastId*/
@property(nonatomic, copy) NSString *lastId;
@end

@implementation FriendsCircleListViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDefaultData];
    }
    return self;
}
- (void)dealloc {
    [_replyView removeFromSuperview];
}
- (void)configVCToolBar:(BaseViewController *)vc {
    _vc = vc;
    _replyView = [XKCommentInputView inputView];
    _replyView.hidden = YES;
    _replyView.autoHidden = YES;
    _replyView.bottom = SCREEN_HEIGHT;
    [KEY_WINDOW addSubview:_replyView];
    [self cleanInput];
    __weak typeof(self) weakSelf = self;
    _replyView.sureClick = ^(NSString *text) {
        weakSelf.commentInfo.content = text;
        [weakSelf reqeustComment];
    };
    [_replyView setTextChange:^(NSString *text) {
        weakSelf.commentInfo.content = text;
    }];
}

- (void)cleanInput {
    self.commentInfo = [XKCommentInputInfo new];
    [self.replyView endEditing];
    [_replyView setOriginText:@""];
    [_replyView setAtUserName:@""];
}

- (void)createDefaultData {
    self.lastId = @"0";
}

- (void)registerCellForTableView:(UITableView *)tableView {
    [tableView registerClass:[XKFriendsTalkCommonRLCell class] forCellReuseIdentifier:normalTextCellId];
    [tableView registerClass:[XKFriendsTalkCommonRLCell class] forCellReuseIdentifier:imgTextCellId];
    [tableView registerClass:[XKFriendsTalkCommonRLCell class] forCellReuseIdentifier:shareTextCellId];
    [tableView registerClass:[XKFriendCircleFooterView class] forHeaderFooterViewReuseIdentifier:@"emptyFooter"];
    [tableView registerClass:[XKFriendCircleFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
}

/**请求列表*/
- (void)requestRefresh:(BOOL)isRefresh complete:(void (^)(id error,id data))complete {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (isRefresh) {
        self.lastId = @"0";
    }
    
    params[@"type"] = @"getFriendsCircle";
    params[@"lastId"] = self.lastId;
    params[@"userHouse"] = [LoginModel currentUser].currentHouseId;

    [self requestWithParams:params block:^(NSString *error, id data) {
        if (error) {
            self.refreshStatus = Refresh_NoNet;
            EXECUTE_BLOCK(complete,error,nil);
        } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                NSArray *array = [NSArray yy_modelArrayWithClass:[FriendTalkModel class] json:data[@"data"]];
                FriendTalkModel *model1 = array.lastObject;
                self.lastId = model1.ID;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (isRefresh) {
                        [self.dataArray removeAllObjects];
                    }
                    
                    NSString *currentLastId = @"0";
                    
                    FriendTalkModel *model2 = self.dataArray.lastObject;
                    if (model2) {
                        currentLastId = model2.ID;
                    }
                    
                    if (currentLastId < self.lastId) {
                        self.refreshStatus = Refresh_HasDataAndHasMoreData;
                    } else {
                        self.refreshStatus = Refresh_NoDataOrHasNoMoreData;

                    }
                    [self.dataArray addObjectsFromArray:array];
                    EXECUTE_BLOCK(complete,nil,array);
                });
            });
        }
    }];
}

/**模糊搜索朋友圈*/
- (void)requestDetailWithFriendsKeyWord:(NSString *)keyWord complete:(void (^)(id error,id data))complete {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"searchFriendsCircle";
    params[@"userHouse"] = [LoginModel currentUser].currentHouseId;
    params[@"searchContent"] = keyWord;
    [self requestWithParams:params block:^(NSString *error, id data) {
        if (error) {
            EXECUTE_BLOCK(complete,error,nil);
        } else {
            self.dataArray = [NSArray yy_modelArrayWithClass:[FriendTalkModel class] json:data[@"data"]].mutableCopy;
            EXECUTE_BLOCK(complete,nil,self.dataArray);
        }
    }];
}

/**请求朋友圈详情列表*/
- (void)requestDetailWithFriendsCircleId:(NSString *)friendsCircleId complete:(void (^)(id error,id data))complete {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"getOneFriendsCircle";
    params[@"userHouse"] = [LoginModel currentUser].currentHouseId;
    params[@"friendsCircleId"] = friendsCircleId;
    NSMutableArray *modelArray = [NSMutableArray array];

    [self requestWithParams:params block:^(NSString *error, id data) {
        if (error) {
            EXECUTE_BLOCK(complete,error,nil);
        } else {
            [modelArray removeAllObjects];
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                FriendTalkModel *model = [FriendTalkModel yy_modelWithJSON:data[@"data"]];
                [modelArray addObject:model];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.dataArray addObjectsFromArray:modelArray];
                    EXECUTE_BLOCK(complete,nil,modelArray);
                });
            });
        }
    }];
}
#pragma mark - 请求单条
- (void)updateItemForIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                   ^{
                       FriendTalkModel *model = self.dataArray[indexPath.section];
                       NSMutableDictionary *params = [NSMutableDictionary dictionary];
                       params[@"userHouse"] = [LoginModel currentUser].currentHouseId;
                       params[@"type"] = @"getOneFriendsCircle";
                       params[@"friendsCircleId"] = model.ID;
                       [self requestSingleWithParams:params block:^(NSString *error, id data) {
                           if (error) {
                               [XKHudView showErrorMessage:error to:self.vc.view animated:YES];
                           } else {
                               FriendTalkModel *newModel = [FriendTalkModel yy_modelWithJSON:data[@"data"]];
                               newModel.ID = model.ID;
                               newModel.singleImgWidth = model.singleImgWidth;
                               newModel.singleImgheight = model.singleImgheight;
                               __block NSInteger index = -1;
                               [self.dataArray enumerateObjectsUsingBlock:^(FriendTalkModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                   if ([obj.ID isEqualToString:model.ID]) {
                                       index = idx;
                                       *stop = YES;
                                   }
                               }];
                               if (index != -1) {
                                   [self.dataArray replaceObjectAtIndex:index withObject:newModel];
                               }
                               self.refreshTableView();
                           }
                       }];
                   });
}

- (void)requestSingleWithParams:(NSDictionary *)params block:(void(^)(NSString *error,id data))block {
    [HTTPClient postRequestWithURLString:@"project_war_exploded/friendsCircleServlet" timeoutInterval:20 parameters:params success:^(id responseObject) {
        EXECUTE_BLOCK(block,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(block,error.message,nil);
    }];
}


- (void)requestWithParams:(NSDictionary *)params block:(void(^)(NSString *error,id data))block {
    [HTTPClient postRequestWithURLString:@"project_war_exploded/friendsCircleServlet" timeoutInterval:20 parameters:params success:^(id responseObject) {
        EXECUTE_BLOCK(block,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(block,error.message,nil);
    }];
}

#pragma mark - 回复请求
- (void)reqeustComment {
    [KEY_WINDOW endEditing:YES];
    FriendTalkModel *model = self.dataArray[self.commentInfo.indexPath.section];

    NSMutableDictionary *params = @{}.mutableCopy;
    if (self.commentInfo.isReply) {
        params[@"useridBecomment"] = self.commentInfo.replyId;
    } else {
        params[@"useridBecomment"] = model.sendUser.userbelonghouse.ID;
    }
    params[@"friendsCircleId"] = self.commentInfo.did;
    params[@"userHouse"] = [LoginModel currentUser].currentHouseId;
    params[@"commentContent"] = self.commentInfo.content;
    params[@"type"] = @"sendComment";

    NSIndexPath *indexPath = self.commentInfo.indexPath;
    [XKHudView showLoadingTo:self.vc.view animated:YES];
    [HTTPClient postRequestWithURLString:@"project_war_exploded/commentsServlet" timeoutInterval:20 parameters:params success:^(id responseObject) {
        [XKHudView hideHUDForView:self.vc.view animated:YES];
        [self updateItemForIndexPath:indexPath];
        [self cleanInput];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.vc.view animated:YES];
        [XKHudView showErrorMessage:error.message to:self.vc.view animated:YES];
    }];
}

#pragma mark - 直接评论
- (void)commentForTalk:(NSIndexPath *)indexPath {
    if (![self.commentInfo.indexPath isEqual:indexPath]) { // 是其他说说
        self.commentInfo.content = nil;
        self.commentInfo.isReply = NO;
    }
    FriendTalkModel *model = self.dataArray[indexPath.section];
    self.commentInfo.indexPath = indexPath;
    self.commentInfo.did = model.ID;
    [_replyView setAtUserName:@""];
    [_replyView setOriginText:self.commentInfo.content];
    [_replyView beginEditing];
}

#pragma mark - 回复人
- (void)replyForUser:(Comments *)comment indexPath:(NSIndexPath *)indexPath {
    if (![self.commentInfo.indexPath isEqual:indexPath]) { // 是其他说说
        self.commentInfo.content = nil;
        self.commentInfo.isReply = YES;
    } else {
        if (self.commentInfo.isReply == NO) { // 同一个说说 之前保存的是评论
            self.commentInfo.content = nil;
            self.commentInfo.isReply = YES;
        }
        if (![self.commentInfo.replyId isEqualToString:comment.comments.userbelonghouse.ID]) { // 切换了回复人
            self.commentInfo.content = nil;
        }
    }
    FriendTalkModel *model = self.dataArray[indexPath.section];
    self.commentInfo.indexPath = indexPath;
    self.commentInfo.replyId = comment.comments.userbelonghouse.ID;
    self.commentInfo.did = model.ID;
    [_replyView setAtUserName:comment.content];
    [_replyView setOriginText:self.commentInfo.content];
    [_replyView beginEditing];
}

#pragma mark - 点赞
- (void)likeForTalk:(NSIndexPath *)indexPath {
    FriendTalkModel *model = self.dataArray[indexPath.section];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"friendsCircleId"] = model.ID;
    parameters[@"userHouse"] = [LoginModel currentUser].currentHouseId;
    BOOL isLikeB = NO;
    for (Likes *like in model.likes) {
        if ([[LoginModel currentUser].data.users.userId isEqualToString:like.userId]) {
            isLikeB = YES;
        }
    }
    NSString *isLike;
    if (!isLikeB) {
        isLike = @"true";
    }else{
        isLike = @"false";
    }
    parameters[@"isLike"] = isLike;
    parameters[@"type"] = @"likeOrDisLike";
    [XKHudView showLoadingTo:self.vc.view animated:YES];
    [HTTPClient postRequestWithURLString:@"project_war_exploded/friendsCircleServlet" timeoutInterval:10.0 parameters:parameters success:^(id responseObject) {
        [XKHudView hideHUDForView:self.vc.view animated:YES];
        if ([isLike isEqualToString:@"true"]) {
            model.type = @"1";
        }else{
            model.type = @"0";
        }
        self.refreshTableView();
        [self updateItemForIndexPath:indexPath];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.vc.view animated:YES];
        [XKHudView showErrorMessage:error.message to:self.vc.view animated:YES];
    }];
}

#pragma mark - 礼物
- (void)giftForTalk:(NSIndexPath *)indexPath {
}

#pragma mark - 删除
- (void)deleteTalk:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    [XKAlertView showCommonAlertViewWithTitle:@"温馨提示" message:@"确定删除此条朋友圈？" leftText:@"取消" rightText:@"确定" leftBlock:nil rightBlock:^{
        FriendTalkModel *model = self.dataArray[indexPath.section];
        [XKHudView showLoadingTo:self.vc.view animated:YES];
        [self requestDelete:model.ID Complete:^(NSString *err, id data) {
            [XKHudView hideHUDForView:self.vc.view animated:YES];
            if (err) {
                [XKHudView showErrorMessage:err to:weakSelf.vc.view animated:YES];
            } else {
                [self.dataArray removeObjectAtIndex:indexPath.section];
                self.refreshTableView();
            }
        }];
    } textAlignment:NSTextAlignmentCenter];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section + 1 > self.dataArray.count) {
        return 0;
    }
    FriendTalkModel *model = self.dataArray[section];
    return (model.comments.count > kMaxReply ? kMaxReply : model.comments.count) + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTalkModel *model = self.dataArray[indexPath.section];
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        NSString *cellIdx = normalTextCellId;
        if (model.msgType == XKFriendTalkMsgNormalTextType) {
            cellIdx = normalTextCellId;
        } else if (model.msgType == XKFriendTalkMsgImgType) {
            cellIdx = imgTextCellId;
        } else if (model.msgType == XKFriendTalkMsgShareType) {
            cellIdx = shareTextCellId;
        }
        XKFriendsTalkCommonRLCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdx forIndexPath:indexPath];
        cell.contentExistFold = NO;
        cell.indexPath = indexPath;
        cell.mode = 0;
        [cell setModel:model];
        [cell setCommentClickBlock:^(NSIndexPath *indexPath, NSString *atUserName, NSString *userId) {
            [weakSelf commentForTalk:indexPath];
        }];
        [cell setFavorClickBlock:^(NSIndexPath *indexPath) {
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            [weakSelf likeForTalk:indexPath];
        }];
        [cell setGiftClickBlock:^(NSIndexPath *indexPath) {
            [weakSelf giftForTalk:indexPath];
        }];
        WEAK_TYPES(tableView)
        [cell setRefreshBlock:^(NSIndexPath *indexPath) {
            [weaktableView reloadData];
        }];
        [cell setDeleteClickBlock:^(NSIndexPath *indexPath) {
            [weakSelf deleteTalk:indexPath];
        }];
        return cell;
    }
    
    //====================================
    
    XKFriendTalkReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:replyCellId];
    if (cell == nil) {
        cell = [[XKFriendTalkReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:replyCellId];
        cell.shortCell = YES;
    }
    
    cell.indexPath = indexPath;
    NSInteger replyIndex = indexPath.row - 1;
    if (replyIndex == 0 && model.likes.count == 0) {
        cell.totalView.xk_clipType = XKCornerClipTypeTopBoth;
    } else {
        cell.totalView.xk_clipType = XKCornerClipTypeNone;
    }
    if (replyIndex == 0 && model.likes.count != 0) {
        [cell hideSperate:NO];
    } else {
        [cell hideSperate:YES];
    }
    [cell setModel:model];
    [cell setUserClickBlock:^(NSIndexPath *indexPath, Comments *comment, BOOL isReply) {
        if (isReply) {
            if ([[LoginModel currentUser].data.users.userId isEqualToString:comment.useridBecomment]) {
                [GlobleCommonTool jumpCircleListWithUserId:comment.comments.userbelonghouse.ID name:comment.beComments.nickname headerIcon:comment.beComments.icon];
            }else{
                [GlobleCommonTool jumpPersonalDataWithUserId:comment.useridBecomment name:comment.beComments.nickname headerIcon:comment.beComments.icon];
            }
        }else{
              [GlobleCommonTool jumpToPersonalDataOrCircleListWithUserId:comment.comments.userbelonghouse.ID name:comment.comments.nickname headerIcon:comment.comments.icon];
        }
        
    }];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTalkModel *model = self.dataArray[indexPath.section];
    NSLog(@"%ld", (long)indexPath.row);
    
    if (indexPath.row == 0) {
        
    }else{
        Comments *comment = model.comments[indexPath.row - 1];
        [self replyForUser:comment indexPath:indexPath];
    }
    
}

@end
