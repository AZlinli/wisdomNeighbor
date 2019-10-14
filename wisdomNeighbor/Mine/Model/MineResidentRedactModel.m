//
//  MineResidentRedactModel.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/30.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "MineResidentRedactModel.h"

@implementation MineResidentRedactModelData
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userId" : @"id",
             };
}
@end

@implementation MineResidentRedactModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [MineResidentRedactModelData class]};
}
@end


