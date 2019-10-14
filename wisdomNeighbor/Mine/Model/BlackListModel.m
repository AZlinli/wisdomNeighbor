//
//  BlackListModel.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/10/11.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "BlackListModel.h"

@implementation BlackListModelData
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userId" : @"id",
             };
}
@end

@implementation BlackListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [BlackListModelData class]};
}
@end
