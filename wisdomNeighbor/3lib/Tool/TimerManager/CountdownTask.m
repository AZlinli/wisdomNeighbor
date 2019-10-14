//
//  CountdownTask.m
//  TimerManager
//
//  Created by Lin Li on 2019/6/4.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "CountdownTask.h"

@implementation CountdownTask
- (void)main {
    
    @autoreleasepool {
    self.taskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];

    while (--self.leftTimeInterval > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.countingDownBlcok){
                self.countingDownBlcok(self.leftTimeInterval);
            }
        });
        
        [NSThread sleepForTimeInterval:1];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.finishedBlcok) {
            self.finishedBlcok(0);
        }
    });
    
    if (self.taskIdentifier != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.taskIdentifier];
        self.taskIdentifier = UIBackgroundTaskInvalid;
    }
  }

}

- (void)start {
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
}


@end
