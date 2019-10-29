//
//  FriendsCirclelModel.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/20.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "FriendsCirclelModel.h"
@implementation Comments2
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ID" : @"id",
             };
}
@end
@implementation BeComments
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ID" : @"id",
             };
}
@end

@implementation Comments
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ID" : @"id",
             };
}
@end

@implementation Likes
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"userId" : @"id",
             };
}
@end
@implementation Userbelonghouse
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ID" : @"id",
             };
}
@end
@implementation SendUser
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"userId" : @"id",
             };
}
@end

@implementation FriendsCirclelListItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"likes":[Likes class],
             @"comments":[Comments class],
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"content" : @"text",
             @"ID" : @"id",
             };
}
- (NSString*)detailType {
    NSArray *pictureContents = [self.images componentsSeparatedByString:@"|"];
    if (pictureContents.count > 0) {
        return @"picture";
    }else{
        return @"";
    }
}

@end

@implementation FriendsCirclelModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[FriendsCirclelListItem class]};
}
@end
