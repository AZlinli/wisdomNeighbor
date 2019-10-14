//
//  BannerModel.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/30.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModelData
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"bannerId" : @"id",
             };
}
@end

@implementation BannerModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [BannerModelData class]};
}
@end
