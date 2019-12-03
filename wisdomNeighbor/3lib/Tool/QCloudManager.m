//
//  QCloudManager.m
//  wisdomNeighbor
//
//  Created by Lin Li on 2019/9/23.
//  Copyright © 2019 Lin Li. All rights reserved.
//

#import "QCloudManager.h"
#import <QCloudCore.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <Photos/Photos.h>
@interface QCloudManager ()

@property (nonatomic, strong) QCloudCOSXMLUploadObjectRequest *upload;
@property (nonatomic, strong, readonly) QCloudOperationQueue* uploadFileQueue;

@property (nonatomic, strong) dispatch_queue_t queue;

@end
@implementation QCloudManager
static QCloudManager *_manager = nil;
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[QCloudManager alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self.queue = dispatch_queue_create("requestQToken", DISPATCH_QUEUE_SERIAL);
//       _upload = [QCloudCOSXMLUploadObjectRequest new];
//       _uploadFileQueue = [QCloudOperationQueue new];

    }
    return self;
}

- (void)uploadImage:(UIImage *)image withKey:(NSString *)key success:(void(^)(NSString *url))success failure:(void (^)(NSString *data))failure{
    XKWeakSelf(ws);
    int a = arc4random() % 100000;
    NSString *str = [NSString stringWithFormat:@"%06d", a];
    NSString* tempPath = QCloudTempFilePathWithExtension(@"png");
    [UIImagePNGRepresentation(image) writeToFile:tempPath atomically:YES];
    self.upload = [QCloudCOSXMLUploadObjectRequest new];
    self.upload.body = [NSURL fileURLWithPath:tempPath];
    self.upload.bucket = kQCloudBucket;
    self.upload.object = [NSString stringWithFormat:@"%@%@.png",str,key];
    [self.upload setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        NSLog(@"%@",result.location);
        ws.upload = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                failure(error.description);
            }else{
                success(result.location);
            }
        });
    }];
    [self.upload setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        
    }];
//    QCloudCOSTransferMangerService *service = [QCloudCOSTransferMangerService costransfermangerServiceForKey:kQCloudRegion];
//    QCloudCOSXMLCopyObjectRequest *request = (QCloudCOSXMLCopyObjectRequest* )self.upload;
//    request.transferManager = service;
//    QCloudFakeRequestOperation* operation = [[QCloudFakeRequestOperation alloc] initWithRequest:self.upload];
//    [self.uploadFileQueue addOpreation:operation];
    
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:self.upload];
    
}
#pragma mark - 上传视频 phaseet
- (void)uploadVideo:(PHAsset *)asset WithKey:(NSString *)key Success:(void(^)(NSString *key))success Failure:(void (^)(NSString *error))failure {
    XKWeakSelf(ws);
    [self getVideoFromPHAsset:asset complete:^(NSString *error, AVURLAsset *asset) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        } else {
            [ws uploadVideoWithUrl:asset.URL WithKey:key Success:success Failure:failure];
        }
    }];
}


- (void)uploadVideoWithUrl:(NSURL *)url FirstImg:(UIImage * )image WithKey:(NSString *)key Success:(void(^)(NSString *videoKey,NSString *imgKey))success Failure:(void (^)(NSString *error))failure {
    if (image == nil) { // 要获取
        image = [self getFirstImage:[AVURLAsset assetWithURL:url]];
        if (image == nil) {
            EXECUTE_BLOCK(failure,@"处理视频出现异常");
            return;
        }
    }
    [self uploadImage:image withKey:key success:^(NSString *imgKey) {
        [self uploadVideoWithUrl:url WithKey:key Success:^(NSString *videoKey) {
            EXECUTE_BLOCK(success,videoKey,imgKey);
        } Failure:^(NSString *error) {
            EXECUTE_BLOCK(failure,@"上传视频失败");
        }];
    } failure:^(NSString *error) {
        EXECUTE_BLOCK(failure,@"上传视频失败");
    }];
}

/**
 上传视频
 
 @param url 视频url
 @param key 模块+业务名 自动拼接其他的
 @param success 成功回调
 @param failure 失败回调
 */
- (void)uploadVideoWithUrl:(NSURL *)url WithKey:(NSString *)key Success:(void(^)(NSString *url))success Failure:(void (^)(NSString *error))failure {
    XKWeakSelf(ws);
    self.upload = [QCloudCOSXMLUploadObjectRequest new];
    self.upload.body = url;
    self.upload.bucket = kQCloudBucket;
    self.upload.object = [NSString stringWithFormat:@"%@.mp4",key];
    [self.upload setFinishBlock:^(QCloudUploadObjectResult *result, NSError *error) {
        NSLog(@"%@",result.location);
        ws.upload = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                failure(error.description);
            }else{
                success(result.location);
            }
        });
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:self.upload];
}




NSString* QCloudTempDir(){
    return NSTemporaryDirectory();
}

NSString* QCloudTempFilePathWithExtension(NSString* extension){
    NSString* fileName = [NSUUID UUID].UUIDString;
    NSString* path = QCloudTempDir();
    path = [path stringByAppendingPathComponent:fileName];
    path = [path stringByAppendingPathExtension:extension];
    return path;
}


// 获取视频资源
- (void)getVideoFromPHAsset:(PHAsset *)phAsset complete:(void(^)(NSString *error,AVURLAsset *asset))result {
    
    if (phAsset.mediaType == PHAssetMediaTypeVideo || phAsset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionOriginal;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        options.networkAccessAllowed = YES;
        
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            result(nil,urlAsset);
        }];
    } else {
        result(@"未知错误", nil);
    }
}

#pragma mark - 获取首帧图
- (UIImage *)getFirstImage:(AVURLAsset *)asset {
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = 0;
    NSError *thumbnailImageGenerationError = nil;
    
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 15) actualTime:NULL error:&thumbnailImageGenerationError];
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;

    CGImageRelease(thumbnailImageRef);
    
    return thumbnailImage;
}

// 压缩视频并转成MP4
- (void)compressVideo:(AVURLAsset *)asset complete:(void(^)(NSString *error, id data))result {
    //保存至沙盒路径
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *videoPath = [NSString stringWithFormat:@"%@/compressTmpVideo.mp4", pathDocuments];
    [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
    
    //转码配置
    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputURL = [NSURL fileURLWithPath:videoPath];
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        int exportStatus = exportSession.status;
        switch (exportStatus)
        {
            case AVAssetExportSessionStatusFailed:
            {
                NSError *exportError = exportSession.error;
                result(exportError.localizedDescription,nil);
                break;
            }
            case AVAssetExportSessionStatusCompleted:
            {
                NSData *data = [NSData dataWithContentsOfFile:videoPath];
                [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
                result(nil,data);
                break;
            }
            default:{
                result(@"未知错误，请重试",nil);
            }
        }
    }];
}

@end
