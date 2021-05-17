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

+(UIImage *)cropImgFromIamge:(UIImage *)image inRect:(CGRect)rect{
    CGFloat scale = KYSCREENSCALE;
    CGFloat x = rect.origin.x * scale;
    CGFloat y = rect.origin.y * scale;
    CGFloat width = rect.size.width * scale;
    CGFloat height = rect.size.height * scale;
    if (image.size.width < width || image.size.height < height) {
        CGFloat frameScale = MAX(width / image.size.width, height / image.size.height);
        x = x / frameScale;
        y = y / frameScale;
        width = width / frameScale;
        height = height / frameScale;
    }
    CGRect drawRect = CGRectMake(x, y, width, height);
    
    CGImageRef imgRef = CGImageCreateWithImageInRect(image.CGImage, drawRect);
    UIImage *retImg = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    return retImg;
}

+(UIImage *)imageFromColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIImage *)defaultImage{
    return [self imageFromColor:KYColorRGB(0xE5E5EA)];
}

@end
