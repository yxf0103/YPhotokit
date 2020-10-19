//
//  KYAsset+Display.m
//  KYPhotoKit
//
//  Created by yxf on 2020/10/19.
//

#import "KYPhotoSource+Display.h"
#import "UIImage+SYExtension.h"
#import <objc/runtime.h>
#import "KYDisplayMacro.h"

char *asset_display = "asset_display";

@implementation KYPhotoSource (Display)

-(UIImage *)displayImage{
    id image = objc_getAssociatedObject(self, asset_display);
    if (!image) {
        CGFloat length = KYAssetItemLength;
        image = [UIImage cropImgFromIamge:self.image inRect:CGRectMake(0, 0, length, length)];
        objc_setAssociatedObject(self, asset_display, image, OBJC_ASSOCIATION_RETAIN);
    }
    return image;
}

-(void)setDisplayImage:(UIImage *)displayImage{
    objc_setAssociatedObject(self, asset_display, displayImage, OBJC_ASSOCIATION_RETAIN);
}

@end
