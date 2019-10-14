//
//  CountdownManager.m
//  TimerManager
//
//  Created by Lin Li on 2019/6/4.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "CountdownManager.h"
#import "CountdownTask.h"
@interface CountdownManager()
/**<##>*/
@property(nonatomic, strong) NSOperationQueue *pool;
@end

@implementation CountdownManager
static CountdownManager *instance;
+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CountdownManager alloc]init];
        instance.pool = [[NSOperationQueue alloc]init];
    });
    return instance;
}

- (void)scheduledCountDownWithKey:(NSString *)aKey timeInterval:(NSTimeInterval)timeInterval countingDown:(void (^)(NSTimeInterval))countingDown finished:(void (^)(NSTimeInterval))finished {
    if (_pool.operations.count >= 20)  // 最多 20 个并发线程
        return;
    
    CountdownTask *task = nil;
    if ([self coundownTaskExistWithKey:aKey task:&task]) {
        task.countingDownBlcok = countingDown;
        task.finishedBlcok     = finished;
        if (task.leftTimeInterval <= 0) {
            //如果当前NSOperation已经完成倒计时，就取消当前的NSOperation，并重新开始
            task.leftTimeInterval  = timeInterval;
            [task start];
            NSLog(@"%lu", (unsigned long)_pool.operations.count);
        }else{
            if (countingDown) {
                countingDown(task.leftTimeInterval);
            }
        }
        
    } else {
        task                   = [[CountdownTask alloc] init];
        task.name              = aKey;
        task.leftTimeInterval  = timeInterval;
        task.countingDownBlcok = countingDown;
        task.finishedBlcok     = finished;
        [_pool addOperation:task];
    }
}


- (void)getCountDownWithKey:(NSString *)aKey countingDown:(void (^)(NSTimeInterval))countingDown finished:(void (^)(NSTimeInterval))finished {
    CountdownTask *task = nil;
    if ([self coundownTaskExistWithKey:aKey task:&task]) {
        task.countingDownBlcok = countingDown;
        task.finishedBlcok     = finished;
        if (task.leftTimeInterval <= 0) {
            if (finished) {
                finished(task.leftTimeInterval);
            }
        }else{
            if (countingDown) {
                countingDown(task.leftTimeInterval);
            }
        }
    }
}

- (BOOL)coundownTaskExistWithKey:(NSString *)akey
                            task:(NSOperation *__autoreleasing  _Nullable *)task
{
    __block BOOL taskExist = NO;
    [_pool.operations enumerateObjectsUsingBlock:^(__kindof NSOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:akey]) {
            if (task) *task = obj;
            taskExist = YES;
            *stop     = YES;
        }
    }];
    
    return taskExist;
}

@end
