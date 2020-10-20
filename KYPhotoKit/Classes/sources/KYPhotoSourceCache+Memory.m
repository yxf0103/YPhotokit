//
//  KYPhotoSourceCache+Memory.m
//  KYPhotoKit
//
//  Created by yxf on 2020/10/19.
//

#import "KYPhotoSourceCache+Memory.h"

typedef NS_ENUM(NSUInteger, KYPhotoSourceCacheType) {
    KYPhotoSourceCacheTypeDisplay,
    KYPhotoSourceCacheTypeBig
};

@implementation KYPhotoSourceCache (Memory)

+(void)addDisplayImage:(UIImage *)image identifier:(NSString *)identifier{
    [self addImage:image identifier:identifier type:KYPhotoSourceCacheTypeDisplay];
}
+(UIImage *)displayImageWithId:(NSString *)identifier{
    return [self imageWithId:identifier type:KYPhotoSourceCacheTypeDisplay];
}


+(void)addBigImage:(UIImage *)image identifier:(NSString *)identifier{
    [self addImage:image identifier:identifier type:KYPhotoSourceCacheTypeBig];
}
+(UIImage *)bigImageWithId:(NSString *)identifier{
    return [self imageWithId:identifier type:KYPhotoSourceCacheTypeBig];
}


+(void)addImage:(UIImage *)image identifier:(NSString *)identifier type:(KYPhotoSourceCacheType)type{
    if (!image || !identifier || identifier.length == 0) {
        return;
    }
    NSCache *cache = [self cacheWithType:type];
    [cache setObject:image forKey:identifier];
}
+(UIImage *)imageWithId:(NSString *)identifier type:(KYPhotoSourceCacheType)type{
    NSCache *cache = [self cacheWithType:type];
    return [cache objectForKey:identifier];
}

+(NSCache *)cacheWithType:(KYPhotoSourceCacheType)type{
    KYPhotoSourceCache *cache = [KYPhotoSourceCache shareInstance];
    NSCache *ret = nil;
    switch (type) {
        case KYPhotoSourceCacheTypeDisplay:
            ret = cache.displayCache;
            break;
        case KYPhotoSourceCacheTypeBig:
            ret = cache.bigCache;
            break;
            
        default:
            break;
    }
    return ret;
}

@end
