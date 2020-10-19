//
//  KYPhotoSourceCache+Memory.h
//  KYPhotoKit
//
//  Created by yxf on 2020/10/19.
//

#import <KYPhotoKit/KYPhotoSourceCache.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYPhotoSourceCache (Memory)

+(void)addDisplayImage:(UIImage *)image identifier:(NSString *)identifier;
+(UIImage *)displayImageWithId:(NSString *)identifier;


+(void)addBigImage:(UIImage *)image identifier:(NSString *)identifier;
+(UIImage *)bigImageWithId:(NSString *)identifier;


@end

NS_ASSUME_NONNULL_END
