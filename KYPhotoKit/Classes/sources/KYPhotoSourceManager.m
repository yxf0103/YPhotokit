//
//  KYPhotoSourceManager.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/3.
//

#import "KYPhotoSourceManager.h"


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
        PHAsset *asset = assets.lastObject;
        UIImage *cover = [manager getImageInfo:asset size:CGSizeMake(50, 50)].image;
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
    __block KYAsset *image = nil;
    //同步获取图片（self.imageOption）
    [self.imageManager requestImageForAsset:asset
                                 targetSize:imageSeize
                                contentMode:PHImageContentModeDefault
                                    options:self.imageOption
                              resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                  image = [[KYAsset alloc] initWithAsset:asset
                                                                   image:result
                                                                    info:info];
                              }];
    return image;
}



@end
