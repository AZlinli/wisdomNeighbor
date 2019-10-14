//
//  MessageListModel.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/21.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "MessageListModel.h"


@implementation MessageListModelComments
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userId" : @"id",
             };
}
@end
@implementation MessageListModelData

@end

@implementation MessageListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [MessageListModelData class]};
}
@end
