//
//  KYPhotoTool.m
//  KYPhotosKit
//
//  Created by yxf on 2019/4/23.
//  Copyright © 2019 k_yan. All rights reserved.
//

#import "KYPhotoTool.h"

@implementation KYPhotoTool

@end

@implementation KYPhotoTool (image)

+(CGRect)destFrameWithImage:(UIImage *)image{
    //1.保证宽度占满屏幕
    //2.修改高度,如果高度大于屏幕高度，修改宽度
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if(fabs(image.size.height)<1e-6){
        return CGRectZero;
    }
    CGFloat imgRate = image.size.width / image.size.height;
    if (fabs(imgRate)<1e-6) {
        return CGRectZero;
    }
    CGFloat imgWidth = screenWidth;
    CGFloat imgHeight = imgWidth / imgRate;
    if (imgHeight > screenHeight) {
        imgHeight = screenHeight;
        imgWidth = imgHeight * imgRate;
    }
    
    CGFloat x = (screenWidth - imgWidth) / 2;
    CGFloat y = (screenHeight - imgHeight) / 2;
    
    return CGRectMake(x, y, imgWidth, imgHeight);
}

@end
