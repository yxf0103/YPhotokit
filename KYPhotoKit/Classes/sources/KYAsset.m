//
//  KYAsset.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/3.
//

#import "KYAsset.h"
#import "KYPhotoSourceManager.h"

@implementation KYAsset

-(instancetype)init{
    return [self initWithAsset:nil image:nil info:nil ];
}

-(instancetype)initWithAsset:(PHAsset *)asset image:(UIImage *)image info:(NSDictionary *)info{
    self = [super init];
    if (self) {
        self.asset = asset;
        self.image = image;
        self.imageInfo = info;
    }
    return self;
}

-(UIImage *)bigImage{
    if (!_bigImage) {
        _bigImage = [KYPhotoSourceManager maxImageForAsset:self];
    }
    return _bigImage;
}

@end
