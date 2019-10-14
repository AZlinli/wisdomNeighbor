/*******************************************************************************
 # File        : XKFriendTalkImgView.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/17
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <UIKit/UIKit.h>
#import "FriendTalkModel.h"

@interface XKFriendTalkImgView : UIView

- (instancetype)initWithWidth:(CGFloat)width;
/**model*/
@property(nonatomic, strong) FriendTalkModel *model;
/**indexPath*/
@property(nonatomic, strong) NSIndexPath *indexPath;

@property(nonatomic, copy) void(^refreshBlock)(NSIndexPath *indexPath);
@end
