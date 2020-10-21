//
//  KYAsset+Display.m
//  KYPhotoKit
//
//  Created by yxf on 2020/10/19.
//

#import "KYPhotoSource+Display.h"
#import <objc/runtime.h>
#import "KYDisplayMacro.h"
#import "KYPhotoSourceCache+Memory.h"
#import "UIImage+SYExtension.h"

char *asset_display = "asset_display";

@implementation KYPhotoSource (Display)

-(UIImage *)displayImage{
    return objc_getAssociatedObject(self, asset_display);
}

-(void)setDisplayImage:(UIImage *)displayImage{
    objc_setAssociatedObject(self, asset_display, displayImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setImageToImgView:(UIImageView *)imgView{
    if (CGRectGetWidth(imgView.frame) == 0 || CGRectGetHeight(imgView.frame) == 0) {
        return;
    }
    if (!self.displayImage) {
        CGSize size = CGSizeMake(CGRectGetWidth(imgView.frame) * KYSCREENSCALE,
                                 CGRectGetHeight(imgView.frame) * KYSCREENSCALE);
        self.displayImage = [UIImage resizeImage:self.image size:size];
    }
    imgView.image = self.displayImage;
//    imgView.image = self.image;
}

@end
