//
//  KYPhotoSourceCache.h
//  KYPhotoKit
//
//  Created by yxf on 2020/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface KYPhotoSourceCache : NSObject

///缓存目录
@property (nonatomic,copy)NSString *cacheDir;

@property (nonatomic,strong,readonly)NSCache *displayCache;
@property (nonatomic,strong,readonly)NSCache *bigCache;

+(instancetype)shareInstance;

///设置缩略图的缓存空间，默认50MB
+(void)setDisplayCacheSize:(long long)size;

///设置大图的缓存空间，默认20MB
+(void)setBigCacheSize:(long long)size;

+(void)addAssetsImage:(UIImage *)image url:(NSString *)url;

+(UIImage *)imageWithAssetUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
