//
//  KYPhotoSourceManager.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/3.
//

#import "KYPhotoSourceManager.h"
#import "UIImage+SYExtension.h"
#import "KYPhotoSourceCache.h"


@interface KYPhotoSourceManager ()

/** imageManager*/
@property(nonatomic,strong)PHImageManager *imageManager;

/** PHImageRequestOptions*/
@property(nonatomic,strong)PHImageRequestOptions *imageOption;

/** image PHFetchOptions*/
@property(nonatomic,strong)PHFetchOptions *imagefetchOption;

/** collection PHFetchOptions*/
@property(nonatomic,strong)PHFetchOptions *collectionFetchOption;

@end

@implementation KYPhotoSourceManager

+(instancetype)shareInstance{
    static KYPhotoSourceManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+(void)requestSystemPhotoLibAuth:(void (^)(PHAuthorizationStatus))auth{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        auth(status);
    }];
}


#pragma mark - getter
-(PHImageManager *)imageManager
{
    if (!_imageManager)
    {
        _imageManager = [PHImageManager defaultManager];
    }
    return _imageManager;
}

-(PHImageRequestOptions *)imageOption
{
    if (!_imageOption)
    {
        _imageOption = [[PHImageRequestOptions alloc] init];
        // 同步获得图片, 只会返回1张图片
        _imageOption.synchronous = YES;
    }
    return _imageOption;
}

-(PHFetchOptions *)imagefetchOption
{
    if (!_imagefetchOption)
    {
        _imagefetchOption = [[PHFetchOptions alloc] init];
        _imagefetchOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    }
    return _imagefetchOption;
}

-(PHFetchOptions *)collectionFetchOption
{
    if (!_collectionFetchOption)
    {
        _collectionFetchOption = [[PHFetchOptions alloc] init];
        _collectionFetchOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"endDate"
                                                                                 ascending:YES]];
    }
    return _collectionFetchOption;
}
-(PHAuthorizationStatus)statu{
    return [PHPhotoLibrary authorizationStatus];
}

-(CGSize)smallSize{
    if (CGSizeEqualToSize(_smallSize, CGSizeZero)) {
        _smallSize = CGSizeMake(150, 150);
    }
    return _smallSize;
}


#pragma mark - 获取系统相册信息
+(void)getAllAlbums:(KYGetAlbumsBlock)complete{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *albums = [NSMutableArray array];
        
        //获得我的相片流(属于PHAssetCollectionTypeAlbum)
        NSArray *myPhotoAlbums = [self albumCollectionsFromType:PHAssetCollectionTypeAlbum
                                                        subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream];
        [albums addObjectsFromArray:myPhotoAlbums];
        
        //获得所有的系统相簿(属于PHAssetCollectionTypeSmartAlbum)
        NSArray *systemAlbums = [self albumCollectionsFromType:PHAssetCollectionTypeSmartAlbum
                                                       subtype:PHAssetCollectionSubtypeAny];
        [albums addObjectsFromArray:systemAlbums];
        
        // 获得所有的自定义相簿(属于PHAssetCollectionTypeAlbum)
        NSArray *customAlbums = [self albumCollectionsFromType:PHAssetCollectionTypeAlbum
                                                       subtype:PHAssetCollectionSubtypeAlbumRegular];
        [albums addObjectsFromArray:customAlbums];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(albums);
        });
    });
}


+(void)getAssetsFromAlbum:(KYAlbum *)album imageSize:(CGSize)size complete:(KYGetAssetsBlock)complete{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        KYPhotoSourceManager *manager = [KYPhotoSourceManager shareInstance];
        PHFetchResult<PHAsset *> *result = [manager fetchResultFromAlbum:album.album];
        __block NSMutableArray *images = [NSMutableArray array];
        [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            KYAsset *asset = [manager getImageInfo:obj size:size];
            [images addObject:asset];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(images);
        });
    });
}


+(void)getImagesFromAlbum:(KYAlbum *)album imageSize:(CGSize)size complete:(KYGetImagesBlock)complete{
    [self getAssetsFromAlbum:album imageSize:size complete:^(NSArray<KYAsset *> *assets) {
        __block NSMutableArray *images = [NSMutableArray array];
        [assets enumerateObjectsUsingBlock:^(KYAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [images addObject:obj.image];
        }];
        complete(images);
    }];
}

+(void)getMyCameraAssetsWithSize:(CGSize)size complete:(KYGetAssetsBlock)complete{
    // 获得相机胶卷
    KYAlbum *album = [self getMyCameraAlbum];
    return [self getAssetsFromAlbum:album imageSize:size complete:complete];
}

+(KYAlbum *)getMyCameraAlbum{
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                             subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                             options:nil].lastObject;
    KYAlbum *album = [[KYAlbum alloc] initWithAlbum:cameraRoll count:0 image:nil];
    return album;
}

+(UIImage *)maxImageForAsset:(KYAsset *)asset{
    __block UIImage *bigImage = nil;
    KYPhotoSourceManager *manager = [KYPhotoSourceManager shareInstance];
    //同步获取图片（self.imageOption）
    [manager.imageManager requestImageForAsset:asset.asset
                                    targetSize:PHImageManagerMaximumSize
                                   contentMode:PHImageContentModeDefault
                                       options:manager.imageOption
                                 resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                     bigImage = result;
                                 }];
    return bigImage;
}

#pragma mark - custom func
//获取系统相册
+(NSArray *)albumCollectionsFromType:(PHAssetCollectionType)type
                             subtype:(PHAssetCollectionSubtype)subType
{
    NSMutableArray *collectionsArray = [NSMutableArray array];
    KYPhotoSourceManager *manager = [KYPhotoSourceManager shareInstance];
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:type
                                                                                               subtype:subType
                                                                                               options:manager.collectionFetchOption];
    [collections enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHFetchResult<PHAsset *> *assets = [manager fetchResultFromAlbum:obj];
        if (assets.count == 0) {
            return;
        }
        PHAsset *asset = assets.lastObject;
        UIImage *cover = [manager getImageInfo:asset size:manager.smallSize].image;
        NSInteger count = assets.count;
        KYAlbum *album = [[KYAlbum alloc] initWithAlbum:obj
                                                  count:count
                                                  image:cover];
        [collectionsArray addObject:album];
    }];
    return collectionsArray;
}

//获取相册里的所有图片
-(PHFetchResult<PHAsset *> *)fetchResultFromAlbum:(PHAssetCollection *)collection
{
    return [PHAsset fetchAssetsInAssetCollection:collection
                                         options:self.imagefetchOption];
}

// 获取某张图片的信息
-(KYAsset *)getImageInfo:(PHAsset *)asset
                    size:(CGSize)imageSeize
{
    if (!asset) {
        return nil;
    }
    __block KYAsset *image = nil;
    [self.imageManager requestImageDataForAsset:asset
                                        options:self.imageOption
                                  resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        BOOL isInICloud = [info[PHImageResultIsInCloudKey] boolValue];
        UIImage *cacheImg = [KYPhotoSourceCache imageWithAssetUrl:asset.localIdentifier];
        if (cacheImg) {
            image = [[KYAsset alloc] initWithAsset:asset
                                             image:cacheImg
                                         isInCloud:isInICloud
                                              info:info];
            return;
        }
        if (imageData) {
            UIImage *img = [UIImage imageWithData:imageData];
            image = [[KYAsset alloc] initWithAsset:asset
                                             image:img
                                         isInCloud:isInICloud
                                              info:info];
            [KYPhotoSourceCache addAssetsImage:img url:asset.localIdentifier];
            return;
        }
        if (imageData == nil && isInICloud) {
            [self.imageManager requestImageForAsset:asset
                                         targetSize:imageSeize
                                        contentMode:PHImageContentModeDefault
                                            options:self.imageOption
                                      resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                image = [[KYAsset alloc] initWithAsset:asset
                                                 image:result
                                             isInCloud:isInICloud
                                                  info:info];
                [KYPhotoSourceCache addAssetsImage:result url:asset.localIdentifier];
            }];
            return;
        }
    }];
    
    return image;
}

+(UIImage *)requestImageWithAsset:(KYAsset *)asset size:(CGSize)size{
    __block UIImage *retImg = nil;
    KYPhotoSourceManager *manager = [KYPhotoSourceManager shareInstance];
    //同步获取图片（self.imageOption）
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.synchronous = YES;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    [manager.imageManager requestImageForAsset:asset.asset
                                    targetSize:size
                                   contentMode:PHImageContentModeDefault
                                       options:option
                                 resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            retImg = result;
            return;
        }
        //从icloud同步图片
        if(!result && [info objectForKey:PHImageResultIsInCloudKey]){
            option.networkAccessAllowed = YES;
            !asset.pullImageFromICloud ? : asset.pullImageFromICloud(asset,YES);
            [manager.imageManager requestImageDataForAsset:asset.asset
                                                   options:option
                                             resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                !asset.pullImageFromICloud ? : asset.pullImageFromICloud(asset,NO);
                if (imageData == nil) {
                    return;
                }
                retImg = [UIImage resizeImageData:imageData size:size];
            }];
        }
        
    }];
    return retImg;
}


@end
