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
    return [self initWithAsset:nil image:nil isInCloud:NO info:nil];
}

-(instancetype)initWithAsset:(PHAsset *)asset image:(UIImage *)image isInCloud:(BOOL)isInCloud info:(NSDictionary *)info{
    self = [super init];
    if (self) {
        _asset = asset;
        _image = image;
        _isInCloud = isInCloud;
        _imageInfo = info;
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
