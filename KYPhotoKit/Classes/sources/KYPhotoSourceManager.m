//
//  KYPhotoSourceManager.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/3.
//

#import "KYPhotoSourceManager.h"
#import "UIImage+SYExtension.h"


@interface KYPhotoSourceManager ()

/** imageManager*/
@property(nonatomic,strong)PHImageManager *imageManager;

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
        _smallSize = CGSizeMake(200, 200);
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


+(void)getAssetsFromAlbum:(KYAlbum *)album complete:(KYGetAssetsBlock)complete{
    NSArray *arr = [self __getAssetsFromAlbum:album.album];
    complete(arr);
}

+(NSArray *)__getAssetsFromAlbum:(PHAssetCollection *)album{
    KYPhotoSourceManager *manager = [KYPhotoSourceManager shareInstance];
    PHFetchResult<PHAsset *> *result = [manager fetchResultFromAlbum:album];
    __block NSMutableArray *images = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KYAsset *asset = [[KYAsset alloc] initWithAsset:obj];
        [images addObject:asset];
    }];
    return images;
}

+(void)getMyCameraAssetsComplete:(KYGetAssetsBlock)complete{
    // 获得相机胶卷
    KYAlbum *album = [self getMyCameraAlbum];
    return [self getAssetsFromAlbum:album complete:complete];
}

+(KYAlbum *)getMyCameraAlbum{
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                             subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                             options:nil].lastObject;
    NSArray *assetArr = [self __getAssetsFromAlbum:cameraRoll];
    KYAlbum *album = [[KYAlbum alloc] initWithAlbum:cameraRoll assets:assetArr];
    return album;
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
        NSArray *assets = [self __getAssetsFromAlbum:obj];
        KYAlbum *album = [[KYAlbum alloc] initWithAlbum:obj assets:assets];
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
//MARK: 获取图片
+(void)getLocalImage:(KYAsset *)asset size:(CGSize)size complete:(KYGetImageBlock)complete{
    [self getImage:asset allowNetwork:NO size:size progress:nil complete:complete];
}

+(void)getCloudImage:(KYAsset *)asset size:(CGSize)size complete:(KYGetImageBlock)complete{
    [self getImage:asset allowNetwork:YES size:size progress:nil complete:complete];
}

+(void)getThumImage:(KYAsset *)asset complete:(KYGetImageBlock)complete{
    CGSize size = CGSizeMake(200, 200);
    [self getLocalImage:asset size:size complete:^(UIImage * _Nullable image) {
        if (image) {
            complete(image);
            return;
        }
        [self getCloudImage:asset size:size complete:complete];
    }];
}

+(void)getOriginImage:(KYAsset *)asset progress:(void (^)(double))progress complete:(KYGetImageBlock)complete{
    if (asset.inCloud) {
        [self getLocalImage:asset size:PHImageManagerMaximumSize complete:complete];
        return;
    }
    [self getImage:asset allowNetwork:YES size:PHImageManagerMaximumSize progress:progress complete:complete];
}

+(void)getImage:(KYAsset *)asset
   allowNetwork:(BOOL)allowNetwork
           size:(CGSize)size
       progress:(void (^)(double))progressCallback
       complete:(KYGetImageBlock)complete{
    KYPhotoSourceManager *manager = [KYPhotoSourceManager shareInstance];
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = allowNetwork;
    if (progressCallback) {
        option.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
            progressCallback(progress);
        };
    }
    [manager.imageManager requestImageForAsset:asset.asset
                                    targetSize:size
                                   contentMode:PHImageContentModeDefault
                                       options:option
                                 resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        complete(result);
    }];
}



@end
