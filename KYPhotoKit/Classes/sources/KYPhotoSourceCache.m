//
//  KYPhotoSourceCache.m
//  KYPhotoKit
//
//  Created by yxf on 2020/10/19.
//

#import "KYPhotoSourceCache.h"

#define KYPhotoCacheDirName @"KYPhotoCacheDir"

@interface KYPhotoSourceCache (){
    NSString *_cacheDir;
}

///cache
@property (nonatomic,strong)NSCache *displayCache;
@property (nonatomic,strong)NSCache *bigCache;

@end

@implementation KYPhotoSourceCache

@dynamic cacheDir;

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static KYPhotoSourceCache *cache = nil;
    dispatch_once(&onceToken, ^{
        cache = [[self alloc] init];
    });
    return cache;
}

+(void)setDisplayCacheSize:(long long)size{
    KYPhotoSourceCache *cache = [KYPhotoSourceCache shareInstance];
    cache.displayCache.totalCostLimit = size;
}

+(void)setBigCacheSize:(long long)size{
    KYPhotoSourceCache *cache = [KYPhotoSourceCache shareInstance];
    cache.bigCache.totalCostLimit = size;
}

+(void)addAssetsImage:(UIImage *)image url:(NSString *)url{
    KYPhotoSourceCache *cache = [KYPhotoSourceCache shareInstance];
    NSString *name = [cache nameFromUrl:url];
    NSString *filepath = [cache.cacheDir stringByAppendingPathComponent:name];
    if (image && filepath) {
        NSData *imgData = UIImageJPEGRepresentation(image, 1);
        [imgData writeToFile:filepath atomically:YES];
    }
}

+(UIImage *)imageWithAssetUrl:(NSString *)url{
    KYPhotoSourceCache *cache = [KYPhotoSourceCache shareInstance];
    NSString *name = [cache nameFromUrl:url];
    NSString *filepath = [cache.cacheDir stringByAppendingPathComponent:name];
    return [[UIImage alloc] initWithContentsOfFile:filepath];
}

#pragma mark - file cache
-(NSString *)cacheDir{
    if (!_cacheDir) {
        NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:KYPhotoCacheDirName];
        _cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:name];
        if ([self fileIsDir:_cacheDir]) {
            [self createDir:_cacheDir];
        }
    }
    return _cacheDir;
}

-(void)setCacheDir:(NSString *)cacheDir{
    if ([cacheDir isEqualToString:self.cacheDir]) {
        return;
    }
    [self removeDir:self.cacheDir];
    _cacheDir = cacheDir;
    if ([self createDir:cacheDir]) {
        [[NSUserDefaults standardUserDefaults] setValue:cacheDir forKey:KYPhotoCacheDirName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)removeDir:(NSString *)dir{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([self fileIsDir:dir]) {
        [fm removeItemAtPath:dir error:nil];
    }
}

-(BOOL)createDir:(NSString *)dir{
    return [[NSFileManager defaultManager] createDirectoryAtPath:dir
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:nil];
}

-(BOOL)fileIsDir:(NSString *)dir{
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if ([fm fileExistsAtPath:dir isDirectory:&isDir] && isDir) {
        return YES;
    }
    return NO;
}

#pragma mark - memory cache
-(NSCache *)displayCache{
    if (!_displayCache) {
        _displayCache = [[NSCache alloc] init];
        _displayCache.totalCostLimit = 50 * 1024 * 1024;
    }
    return _displayCache;
}

-(NSCache *)bigCache{
    if (!_bigCache) {
        _bigCache = [[NSCache alloc] init];
        _bigCache.totalCostLimit = 50 * 1024 * 1024;
    }
    return _bigCache;
}


#pragma mark - url encode
-(NSString *)nameFromUrl:(NSString *)url{
    NSData *data = [url dataUsingEncoding:NSDataBase64Encoding64CharacterLineLength];
    return [data base64EncodedStringWithOptions:kNilOptions];
}

-(NSString *)urlFromName:(NSString *)name{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:name options:kNilOptions];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
