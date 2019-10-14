//
//  BannerModel.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/30.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannerModelData :NSObject
@property (nonatomic , copy) NSString              * bannerId;
@property (nonatomic , copy) NSString              * belongestates;
@property (nonatomic , copy) NSString              * createtime;
@property (nonatomic , copy) NSString              * image;
@property (nonatomic , copy) NSString              * link;

@end

@interface BannerModel :NSObject
@property (nonatomic , copy) NSString              * returnCode;
@property (nonatomic , copy) NSArray<BannerModelData *>              * data;
@property (nonatomic , copy) NSString              * errorMessage;

@end

NS_ASSUME_NONNULL_END
