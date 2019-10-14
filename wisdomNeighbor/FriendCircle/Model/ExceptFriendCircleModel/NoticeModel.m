//
//  NoticeModel.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/27.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "NoticeModel.h"

@implementation NoticeModelComments

@end

@implementation NoticeModelSendUser

@end

@implementation NoticeModelLikes

@end

@implementation NoticeModelData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"likes" : [NoticeModelLikes class],
             @"comments" : [NoticeModelComments class]
             };
}
@end


@implementation NoticeModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [NoticeModelData class]};
}
@end
