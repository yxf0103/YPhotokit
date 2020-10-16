//
//  UIImage+SYExtension.m
//  KYPhotoKit
//
//  Created by yxf on 2020/10/16.
//

#import "UIImage+SYExtension.h"

@implementation UIImage (SYExtension)

+(UIImage *)resizeImage:(UIImage *)image size:(CGSize)size{
    CGSize imgSize = image.size;
    if (imgSize.width <= size.width && imgSize.height <= size.height) {
        return image;
    }
    NSData *data = UIImageJPEGRepresentation(image, 1);
    return [self resizeImageData:data size:size];
}

+(UIImage *)resizeImageData:(NSData *)imageData size:(CGSize)size{
    CGImageSourceRef sourceRef = CGImageSourceCreateWithData((CFDataRef)imageData, nil);
    if (sourceRef == NULL) {
        return nil;
    }
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(sourceRef, 0, nil);
    CFRelease(sourceRef);
    if (imageRef == NULL) {
        return nil;
    }
    CGContextRef context = CGBitmapContextCreateWithData(nil,
                                                         size.width,
                                                         size.height,
                                                         CGImageGetBitsPerComponent(imageRef),
                                                         CGImageGetBytesPerRow(imageRef),
                                                         CGImageGetColorSpace(imageRef),
                                                         CGImageGetBitmapInfo(imageRef),
                                                         nil, nil);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), imageRef);
    
    CGImageRef scaleImg = CGBitmapContextCreateImage(context);
    CGImageRelease(imageRef);
    CGContextRelease(context);
    
    UIImage *retImage = [UIImage imageWithCGImage:scaleImg];
    CGImageRelease(scaleImg);
    
    return retImage;
}

@end
