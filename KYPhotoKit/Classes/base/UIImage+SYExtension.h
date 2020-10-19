//
//  UIImage+SYExtension.h
//  KYPhotoKit
//
//  Created by yxf on 2020/10/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SYExtension)

+(UIImage *)resizeImage:(UIImage *)image size:(CGSize)size;
+(UIImage *)resizeImageData:(NSData *)imageData size:(CGSize)size;

+(UIImage *)cropImgFromIamge:(UIImage *)image inRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
