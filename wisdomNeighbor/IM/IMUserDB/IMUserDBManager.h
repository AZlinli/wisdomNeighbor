//
//  IMUserDBManager.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/29.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMUserDBManager : NSObject{
    
    FMDatabaseQueue *_dbQueue;  // 这个类在多个线程来执行查询和更新时会使用这个类。避免同时访问同一个数据。
    FMDatabasePool *_dbPool;    // 数据库连接池 减少连接开销（这要明确知道不会同一时刻有多个线程去操作数据库，如果会就是用FMDatabaseQueue）
}

+ (IMUserDBManager *)shareInstance;

/**
 创建表
 */
- (void)createTable;

/**
 user添加数据

 @param model RCUserInfo
 */
- (void)insertUserDataInTable:(RCUserInfo *)model;


/**
 所有user更新数据

 @param model RCUserInfo
 */
- (void)updateUserTable:(RCUserInfo *)model;

/**
 根据userId查询当前用户

 @param userId 用户的id
 @return RCUserInfo
 */
- (RCUserInfo *)getUserWithUserId:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END
