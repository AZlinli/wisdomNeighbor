/*******************************************************************************
 # File        : XKFriendCirclePublishViewModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/23
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <Foundation/Foundation.h>
#import "XKUploadMediaInfo.h"

@interface XKFriendCirclePublishViewModel : NSObject
/**内容文本*/
@property(nonatomic, copy) NSString *contentStr;
/**当前的标签*/
@property(nonatomic, copy) NSString *tag;
/**当前的位置信息*/
@property(nonatomic, copy) NSString *currentAddess;
/**评论的图片视频信息*/
@property(nonatomic, strong) NSMutableArray<XKUploadMediaInfo *> *mediaInfoArr;

/**重设数据源 处理add选项*/
- (void)resetMedioArr;
/**获取资源实际数量 排除了add的选项*/
- (NSArray <XKUploadMediaInfo *> *)getMediaArray;
/**获取图片资源*/
- (NSArray <XKUploadMediaInfo *>*)getPicArray;
/**获取视频资源*/
- (NSArray <XKUploadMediaInfo *>*)getVideoArray;


- (void)requestPublishComplete:(void(^)(NSString *error, id data))complete;
@end


