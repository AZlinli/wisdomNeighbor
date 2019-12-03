//
//  VerificationNextModel.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/11/18.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "VerificationNextModel.h"


@implementation VerificationNextModelUserbelonghouse
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
    };
}
@end
@implementation VerificationNextModelData

@end
@implementation VerificationNextModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [VerificationNextModelData class]};
}
@end
