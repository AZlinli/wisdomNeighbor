//
//  VerificationModel.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/11/18.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "VerificationModel.h"

@implementation VerificationModelData
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
    };
}
@end

@implementation VerificationModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [VerificationModelData class]};
}
@end
