//
//  LoginViewController.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/14.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : BaseViewController
/**控制器类型*/
@property(nonatomic, assign) loginVCTyoe vcType;
/**<##>*/
@property(nonatomic, copy) NSString *phone;
@end

NS_ASSUME_NONNULL_END
