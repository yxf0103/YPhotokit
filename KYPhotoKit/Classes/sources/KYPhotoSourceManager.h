//
//  KYPhotoSourceManager.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "KYAlbum.h"
#import "KYAsset.h"

@class KYAlbum,KYAsset;

typedef void(^KYGetAlbumsBlock)(NSArray<KYAlbum *> *albums);
typedef void(^KYGetAssetsBlock)(NSArray<KYAsset *> *assets);
typedef void(^KYGetImagesBlock)(NSArray<UIImage *> *images);

@interface KYPhotoSourceManager : NSObject

/** imageManager*/
@property(nonatomic,strong,readonly)PHImageManager *imageManager;

/** PHImageRequestOptions,一次只能读取一张图片*/
@property(nonatomic,strong,readonly)PHImageRequestOptions *imageOption;

/** image PHFetchOptions,根据creationDate生序排序*/
@property(nonatomic,strong,readonly)PHFetchOptions *imagefetchOption;

/** collection PHFetchOptions,根据endDate生序排序*/
@property(nonatomic,strong,readonly)PHFetchOptions *collectionFetchOption;

/*
 系统相册访问权限
 PHAuthorizationStatusNotDetermined = 0, 未授权
 PHAuthorizationStatusRestricted,家长权限
 PHAuthorizationStatusDenied,拒绝访问
 PHAuthorizationStatusAuthorized 同意访问
 */
@property (nonatomic,assign,readonly)PHAuthorizationStatus statu;

///缩略图大小
@property (nonatomic,assign)CGSize smallSize;

#pragma mark - 初始化
+(instancetype)shareInstance;

/**
 请求系统相册访问权限

 @param auth 用户授权结果
 */
+(void)requestSystemPhotoLibAuth:(void(^)(PHAuthorizationStatus statu))auth;

#pragma mark - func
#pragma mark - convenient func
/**
 获取所有相册信息,异步

 @param complete 包含相册信息的回调,主线程
 */
+(void)getAllAlbums:(KYGetAlbumsBlock)complete;

/**
 获取某个相册里面的所有图片,异步

 @param album 相册
 @param complete 包含图片的回调,主线程
 */
+(void)getImagesFromAlbum:(KYAlbum *)album imageSize:(CGSize)size complete:(KYGetImagesBlock)complete;

#pragma mark - diy func

/**
 获取某个相册里面的所有图片信息,异步
 
 @param album 相册
 @param complete 包含图片信息的回调,主线程
 */
+(void)getAssetsFromAlbum:(KYAlbum *)album imageSize:(CGSize)size complete:(KYGetAssetsBlock)complete;

/**
 获取我的相册里的图片信息,异步
 
 @param size 图片大小
 @param complete 回调,主线程
 */
+(void)getMyCameraAssetsWithSize:(CGSize)size complete:(KYGetAssetsBlock)complete;

/**
 获取我的相册

 @return 我的相册
 */
+(KYAlbum *)getMyCameraAlbum;

/**
 获取asset的最大图片

 @param asset 相册图片信息集
 @return 图片
 */
+(UIImage *)maxImageForAsset:(KYAsset *)asset;

@end
