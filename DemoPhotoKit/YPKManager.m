//
//  YPKManager.m
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/12.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import "YPKManager.h"
#import "YPKAlbumModel.h"
#import "YPKImageModel.h"

@interface YPKManager ()<PHPhotoLibraryChangeObserver>

/** imageManager*/
@property(nonatomic,strong)PHImageManager *imageManager;

/** PHImageRequestOptions*/
@property(nonatomic,strong)PHImageRequestOptions *imageOption;

/** image PHFetchOptions*/
@property(nonatomic,strong)PHFetchOptions *imagefetchOption;

/** collection PHFetchOptions*/
@property(nonatomic,strong)PHFetchOptions *collectionFetchOption;

@end

@implementation YPKManager

+(instancetype)shareInstance{
    static YPKManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

-(void)dealloc{
    
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
#pragma mark - public func

-(void)startWork{
//    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

-(void)stopWork{
//    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

+(void)checkAuthorizedStatus:(void (^)(PHAuthorizationStatus))status{
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    status(authStatus);
}

/** 获取所有相册*/
+(void)getAllAlbums:(YPKAlbumsCompletion)completion{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *albums = [NSMutableArray array];
        
//        NSLog(@"======= my photo stream ======");
        //获得我的相片流(属于PHAssetCollectionTypeAlbum)
        NSArray *myPhotoAlbums = [self addCollectionsFromType:PHAssetCollectionTypeAlbum
                                                      subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream];
        [albums addObjectsFromArray:myPhotoAlbums];
        
        
//        NSLog(@"======= system ======");
        //获得所有的系统相簿(属于PHAssetCollectionTypeSmartAlbum)
        NSArray *systemAlbums = [self addCollectionsFromType:PHAssetCollectionTypeSmartAlbum
                                                     subtype:PHAssetCollectionSubtypeAny];
        [albums addObjectsFromArray:systemAlbums];
        
//        NSLog(@"======= custom ======");
        // 获得所有的自定义相簿(属于PHAssetCollectionTypeAlbum)
        NSArray *customAlbums = [self addCollectionsFromType:PHAssetCollectionTypeAlbum
                                                     subtype:PHAssetCollectionSubtypeAlbumRegular];
        [albums addObjectsFromArray:customAlbums];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(albums,nil);
        });
    });
}

/** 获取某个相册的图片*/
+(void)getAlbum:(YPKAlbumModel *)album completion:(YPKImagesCompleton)completion{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        YPKManager *manager = [YPKManager shareInstance];
        PHFetchResult *result = [manager fetchResultFromAlbum:album.album];
        NSArray *images = [manager getImagesInResult:result size:CGSizeMake(50, 50)];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(images,nil);
        });
    });
}

/** 获取某个图片的信息*/
+(void)getImage:(PHAsset *)image completion:(YPKImageCompletion)completion{
    YPKManager *manager = [YPKManager shareInstance];
    YPKImageModel *assetImage = [manager getImageInfo:image size:CGSizeMake(100, 100)];
    completion(assetImage,nil);
}

#pragma mark - custom func
+(NSArray *)addCollectionsFromType:(PHAssetCollectionType)type
                                             subtype:(PHAssetCollectionSubtype)subType
{
    NSMutableArray *collectionsArray = [NSMutableArray array];
    YPKManager *manager = [YPKManager shareInstance];
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:type
                                                                                               subtype:subType
                                                                                               options:manager.collectionFetchOption];
    [collections enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *cover = [manager getAlbumCover:obj size:CGSizeMake(50, 50)];
        NSInteger count = [manager fetchResultFromAlbum:obj].count;
        YPKAlbumModel *album = [[YPKAlbumModel alloc] initWithAlbum:obj
                                                              count:count
                                                              image:cover];
        [collectionsArray addObject:album];
    }];
    return collectionsArray;
}

-(PHFetchResult<PHAsset *> *)fetchResultFromAlbum:(PHAssetCollection *)collection
{
    return [PHAsset fetchAssetsInAssetCollection:collection
                                         options:self.imagefetchOption];
}

#pragma mark - images
/** 获取某个相册的封面*/
-(UIImage *)getAlbumCover:(id)album
                     size:(CGSize)imageSize
{
    PHAsset *asset = [self fetchResultFromAlbum:album].lastObject;
    if (!asset) return nil;
    
    return [self getImageInfo:asset size:imageSize].image;
}

/** 获取一个相册里的所有图片*/
-(NSArray *)getImagesInCollection:(PHAssetCollection *)collection
                             size:(CGSize)imageSize
{
    PHFetchResult *result = [self fetchResultFromAlbum:collection];
    return [self getImagesInResult:result size:imageSize];
}

/** 获取一个PHFetchResult里的所有图片*/
-(NSArray *)getImagesInResult:(PHFetchResult<PHAsset *> *)result
                         size:(CGSize)size
{
    NSMutableArray *imagesArray = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imagesArray addObject:[self getImageInfo:obj size:size]];
    }];
    return imagesArray;
}

/** 获取我的相机的相片信息*/
-(NSArray *)getNormalImagesWithUnitSize:(CGSize)size
{
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                             subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                             options:nil].lastObject;
    return [self getImagesInCollection:cameraRoll size:size];
}

/** 获取某张图片的信息*/
-(YPKImageModel *)getImageInfo:(PHAsset *)asset
                               size:(CGSize)imageSeize
{
    __block YPKImageModel *image = nil;
    //同步获取图片（self.imageOption）
    [self.imageManager requestImageForAsset:asset
                                 targetSize:imageSeize
                                contentMode:PHImageContentModeDefault
                                    options:self.imageOption
                              resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                  image = [[YPKImageModel alloc] initWithAsset:asset
                                                                         image:result
                                                                          info:info];
                              }];
    return image;
}


#pragma mark -observer
-(void)photoLibraryDidChange:(PHChange *)changeInstance
{

}

@end
