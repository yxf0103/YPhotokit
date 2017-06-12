//
//  YPKManager.h
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/12.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YPKImageModel;
@class YPKAlbumModel;

//获取所有相册信息的回调
typedef void(^YPKAlbumsCompletion)(NSArray<YPKAlbumModel *> *collections ,NSError *error);

//获取相册所有图片信息的回调
typedef void(^YPKImagesCompleton)(NSArray<YPKImageModel *> *images,NSError *error);

//获取指定图片信息的回调
typedef void(^YPKImageCompletion)(YPKImageModel *image,NSError *error);


@interface YPKManager : NSObject

/** imageManager*/
@property(nonatomic,strong,readonly)PHImageManager *imageManager;

/** PHImageRequestOptions*/
@property(nonatomic,strong,readonly)PHImageRequestOptions *imageOption;

/** image PHFetchOptions*/
@property(nonatomic,strong,readonly)PHFetchOptions *imagefetchOption;

/** collection PHFetchOptions*/
@property(nonatomic,strong,readonly)PHFetchOptions *collectionFetchOption;

/** 初始化*/
+(instancetype)shareInstance;

/** 监听变化*/
-(void)startWork;

/** 停止监听变化*/
-(void)stopWork;

/** 检查相册是否能被访问*/
+(void)checkAuthorizedStatus:(void (^)(PHAuthorizationStatus status))status;

/** 获取所有相册*/
+(void)getAllAlbums:(YPKAlbumsCompletion)completion;

/** 获取某个相册的图片*/
+(void)getAlbum:(YPKAlbumModel *)album completion:(YPKImagesCompleton)completion;

/** 获取我的相机的相片信息*/
-(NSArray *)getNormalImagesWithUnitSize:(CGSize)size;

/** 获取某个图片的信息*/
+(void)getImage:(PHAsset *)image completion:(YPKImageCompletion)completion;

@end
