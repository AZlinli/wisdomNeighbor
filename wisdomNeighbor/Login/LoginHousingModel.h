//
//  LoginHousingModel.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/27.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginHousingModelData :NSObject
@property (nonatomic , assign) BOOL              isopen;
@property (nonatomic , copy) NSString              * totleperson;
@property (nonatomic , copy) NSString              * longitude;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * locationstring;
@property (nonatomic , copy) NSString              * latitude;
@property (nonatomic , copy) NSString              * jointime;
@property (nonatomic , copy) NSString              * name;

@end

@interface LoginHousingModel :NSObject
@property (nonatomic , copy) NSArray<LoginHousingModelData *>              * data;
@property (nonatomic , assign) NSInteger              returnCode;
@property (nonatomic , copy) NSString              * errorMessage;

@end

NS_ASSUME_NONNULL_END
