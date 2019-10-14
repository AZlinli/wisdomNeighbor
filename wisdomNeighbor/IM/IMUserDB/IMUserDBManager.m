//
//  IMUserDBManager.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/29.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "IMUserDBManager.h"

#define TableAllUser                   @"TableAllUser"
//用户ID
#define TableUserId                       @"userId"
//用户名字
#define TableName                         @"name"
//用户头像url
#define TablePortraitUri                  @"portraitUri"

@implementation IMUserDBManager
static IMUserDBManager *manager = nil;
+ (IMUserDBManager *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

// 创建表
- (void)createTable {
    NSString* docuPath =  [self _getAppDocumentPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:docuPath]) { // 如果不存在直接创建
        [[NSFileManager defaultManager] createDirectoryAtPath:docuPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    //数据库的路径
    NSString *path = [docuPath stringByAppendingPathComponent:@"user.sqlite"];
    _dbQueue = [[FMDatabaseQueue alloc] initWithPath:path];
    _dbPool = [[FMDatabasePool alloc] initWithPath:path];
    [self createAllTables];
}

- (void)createAllTables {
  
    [self createUserTable];
    
}

- (void)createUserTable {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db setShouldCacheStatements:YES];
        db.logsErrors = YES;
        if ([db tableExists:TableAllUser]) {}else{
            NSString *sql = [NSString stringWithFormat:
                             @"CREATE TABLE IF NOT EXISTS %@ ( "
                             "%@ TEXT, "
                             "%@ TEXT, "
                             "%@ TEXT"
                             " ); ",
                             TableAllUser,
                             TableUserId,
                             TableName,
                             TablePortraitUri
                             ];
            NSLog(@"%@",sql);
            BOOL result = [db executeUpdate:sql];
            
            if (result) {
                NSLog(@"create user success");

            } else {
                NSLog(@"create user failed");

            }
        }
    }];
}

- (void)insertUserDataInTable:(RCUserInfo *)model {
    __block BOOL whoopsSomethingWrongHappened = true;
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db setShouldCacheStatements:YES];
        db.logsErrors = YES;
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ ( "
                               "%@, "
                               "%@, "
                               "%@ "
                               " ) VALUES(?,?,?);",
                               TableAllUser,
                               TableUserId,
                               TableName,
                               TablePortraitUri
                               ];
        whoopsSomethingWrongHappened = [db executeUpdate:insertSql,
                                        model.userId,
                                        model.name,
                                        model.portraitUri
                                        ];
        if (whoopsSomethingWrongHappened) {
                NSLog(@"save user success");
        } else {
                NSLog(@"save user failed");
            return;
        }
        
    }];
}

- (void)updateUserTable:(RCUserInfo *)model {
    __block BOOL whoopsSomethingWrongHappened = true;
    [_dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [db setShouldCacheStatements:YES];
        db.logsErrors = YES;
        NSString* deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ where %@ = ? ;",TableAllUser,TableUserId];
        whoopsSomethingWrongHappened = [db executeUpdate:deleteSql,model.userId];
        if (!whoopsSomethingWrongHappened) {
            NSLog(@"delete TableCity failed");
        }
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ ( "
                               "%@, "
                               "%@, "
                               "%@ "
                               " ) VALUES(?,?,?); ",
                               TableAllUser,
                               TableUserId,
                               TableName,
                               TablePortraitUri
                               ];
        whoopsSomethingWrongHappened = [db executeUpdate:insertSql,
                                        model.userId,
                                        model.name,
                                        model.portraitUri
                                        ];
        if (whoopsSomethingWrongHappened) {
            NSLog(@"update user success");

        } else {
            NSLog(@"update user failed");
            *rollback = YES;
            return;
        }
        
    }];
}

- (RCUserInfo *)getUserWithUserId:(NSString *)userId {
    __block RCUserInfo * dataModel;
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?;",TableAllUser,TableUserId];
        FMResultSet* resultSet = [db executeQuery:selectSql,userId];
        while ([resultSet next]) {
            NSDictionary *bb = [resultSet resultDictionary];
            NSLog(@"BB = %@",bb);
            dataModel = [RCUserInfo yy_modelWithDictionary:bb];
        }
        [resultSet close];
    }];
    return dataModel;
}


#pragma mark 私有函数
-(NSString *)_getAppDocumentPath {
    
    NSArray* lpPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* result = nil;
    
    if([lpPaths count] >0) {
        
        result = [NSString stringWithFormat:@"%@",[lpPaths objectAtIndex:0]];
        BOOL isDirectory = YES;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:result isDirectory:&isDirectory]) {
            
            [[NSFileManager defaultManager] createDirectoryAtPath:result withIntermediateDirectories:NO attributes:nil error:nil];
        }
        return result;
    } else {
        
        return result;
    }
}
@end
