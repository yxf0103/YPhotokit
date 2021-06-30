//
//  KYPhotoSourceManager.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <KYPhotoKit/KYAlbum.h>
#import <KYPhotoKit/KYAsset.h>

@class KYAlbum,KYAsset;

typedef void(^KYGetAlbumsBlock)(NSArray<KYAlbum *> * _Nullable albums);
typedef void(^KYGetAssetsBlock)(NSArray<KYAsset *> *_Nullable assets);
typedef void(^KYGetImagesBlock)(NSArray<UIImage *> *_Nullable images);
typedef void(^KYGetImageBlock)(UIImage *_Nullable image);

@interface KYPhotoSourceManager : NSObject

/** imageManager*/
@property(nonatomic,strong,readonly)PHImageManager *_Nullable imageManager;

/** PHImageRequestOptions,一次只能读取一张图片*/
@property(nonatomic,strong,readonly)PHImageRequestOptions *_Nullable imageOption;

/** image PHFetchOptions,根据creationDate生序排序*/
@property(nonatomic,strong,readonly)PHFetchOptions *_Nullable imagefetchOption;

/** collection PHFetchOptions,根据endDate生序排序*/
@property(nonatomic,strong,readonly)PHFetchOptions *_Nullable collectionFetchOption;

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
+(instancetype _Nullable )shareInstance;

/**
 请求系统相册访问权限

 @param auth 用户授权结果
 */
+(void)requestSystemPhotoLibAuth:(void(^_Nullable)(PHAuthorizationStatus statu))auth;

#pragma mark - 相册
/**
 获取所有相册信息,异步

 @param complete 包含相册信息的回调,主线程
 */
+(void)getAllAlbums:(KYGetAlbumsBlock _Nullable )complete;

/**
 获取某个相册里面的所有图片信息,异步
 
 @param album 相册
 @param complete 包含图片信息的回调,主线程
 */
+(void)getAssetsFromAlbum:(KYAlbum *_Nullable)album complete:(KYGetAssetsBlock _Nullable)complete;

/**
 获取我的相册里的图片信息,异步
 
 @param complete 回调,主线程
 */
+(void)getMyCameraAssetsComplete:(KYGetAssetsBlock _Nullable)complete;

/**
 获取我的相册

 @return 我的相册
 */
+(KYAlbum *_Nullable)getMyCameraAlbum;

#pragma mark - 相片
///获取本地图片
+(void)getLocalImage:(KYAsset *_Nullable)asset
                size:(CGSize)size
            complete:(KYGetImageBlock _Nullable)complete;
///获取icloud里面的图片
+(void)getCloudImage:(KYAsset *_Nullable)asset
                size:(CGSize)size
            complete:(KYGetImageBlock _Nullable)complete;

///获取缩略图,先获取本地图片，再获取icloud图片
+(void)getThumImage:(KYAsset *_Nullable)asset
           complete:(KYGetImageBlock _Nullable)complete;

///获取原图,先获取本地图片，再获取icloud图片
+(void)getOriginImage:(KYAsset *_Nullable)asset
             progress:(void(^_Nullable)(double progress))progress
             complete:(KYGetImageBlock _Nullable)complete;

@end
