//
//  QCloudManager.h
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/23.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCloudManager : NSObject
/**
 单例
 
 @return 返回一个上传文件的单例对象
 */
+ (instancetype)shareManager;

/**
 上传图片

 @param image 图片
 @param key 图片的名字
 @param success 成功的回调
 @param failure 失败的回调
 */
- (void)uploadImage:(UIImage *)image withKey:(NSString *)key success:(void(^)(NSString *url))success failure:(void (^)(NSString *data))failure;


/**
 上传视频

 @param url 视频url
 @param image 首诊图
 @param key key
 @param success 成功的回调
 @param failure 失败的回调
 */
- (void)uploadVideoWithUrl:(NSURL *)url FirstImg:(UIImage *)image WithKey:(NSString *)key Success:(void(^)(NSString *videoKey,NSString *imgKey))success Failure:(void (^)(NSString *error))failure;



@end

NS_ASSUME_NONNULL_END
