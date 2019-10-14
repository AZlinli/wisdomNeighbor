//
//  MineResidentRedactViewController.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/14.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "BaseViewController.h"
#import "MineResidentRedactModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface MineResidentRedactViewController : BaseViewController

/**控制器类型*/
@property(nonatomic, assign) MineResidentRedactVCTyoe vcType;
/**model*/
@property(nonatomic, strong) MineResidentRedactModelData *model;
@end

NS_ASSUME_NONNULL_END
