//
//  SelectPlotViewController.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/12/7.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectBlock)(NSString * name,NSString *ID);
@interface SelectPlotViewController : BaseViewController
/**<##>*/
@property(nonatomic, copy) SelectBlock selectBlock;
@end

NS_ASSUME_NONNULL_END
